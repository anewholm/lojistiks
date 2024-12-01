-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_distance(uuid, uuid)
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_distance(source_location_id uuid, destination_location_id uuid);
--
-- Name: fn_acorn_lojistiks_distance(uuid, uuid); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_acorn_lojistiks_distance(source_location_id uuid, destination_location_id uuid) RETURNS double precision
    LANGUAGE plpgsql
    AS $$
begin
	return (select point(sg.longitude, sg.latitude) <@> point(dg.longitude, dg.latitude)
		from public.acorn_lojistiks_locations sl
		inner join public.acorn_lojistiks_addresses sa on sl.address_id = sa.id
		inner join public.acorn_lojistiks_gps sg on sa.gps_id = sg.id,
		
		public.acorn_lojistiks_locations dl
		inner join public.acorn_lojistiks_addresses da on dl.address_id = da.id
		inner join public.acorn_lojistiks_gps dg on da.gps_id = dg.id
		
		where sl.id = source_location_id
		and dl.id = destination_location_id
	) * 1.609344; -- Miles to KM
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_is_date(character varying, timestamp with time zone)
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_is_date(s character varying, d timestamp with time zone);
--
-- Name: fn_acorn_lojistiks_is_date(character varying, timestamp with time zone); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_acorn_lojistiks_is_date(s character varying, d timestamp with time zone) RETURNS timestamp with time zone
    LANGUAGE plpgsql
    AS $$
            begin
                
                if s is null then
                    return d;
                end if;
                perform s::timestamp with time zone;
                    return s;
                exception when others then
                    return d;
            
            end;
            $$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_transfers_delete_calendar()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_transfers_delete_calendar();
--
-- Name: fn_acorn_lojistiks_transfers_delete_calendar(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_acorn_lojistiks_transfers_delete_calendar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	if not old.created_at is null then
		-- Use the Calendar system
		delete from acorn_calendar_event
			where id = old.created_at;
	end if;
	return old;
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_transfers_insert_calendar()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_transfers_insert_calendar();
--
-- Name: fn_acorn_lojistiks_transfers_insert_calendar(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_acorn_lojistiks_transfers_insert_calendar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
    pid uuid;
    event_name text;
begin
	-- Use the Calendar system
	select into event_name concat('Transfer (', coalesce(name, 'Unknown'), ')')
		from public.acorn_lojistiks_locations
		where id = new.destination_location_id;
	insert into public.acorn_calendar_event(calendar_id, owner_user_id, owner_user_group_id, external_url) 
		select id,
        -- TODO: This should be passed through from the transfer BackendAuth::user()
        (select id from acorn_user_users limit 1),
        (select id from acorn_user_user_groups limit 1),
        concat('/backend/acorn/lojistiks/transfers/update/', new.id)
		from acorn_calendar
		where name = 'Default'
		returning id into pid;
	insert into public.acorn_calendar_event_part(event_id, "name", description, "start", "end", type_id, status_id)
		select pid, event_name, '', now(), now(), id,
        (select id from acorn_calendar_event_status where name = 'Normal')
		from acorn_calendar_event_type
		where name = 'Transfer started';
	new.created_at = pid;

	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_transfers_update_calendar()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_transfers_update_calendar();
--
-- Name: fn_acorn_lojistiks_transfers_update_calendar(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.fn_acorn_lojistiks_transfers_update_calendar() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	event_name text;
begin
	if not new.created_at is null then
		-- Use the Calendar system
		select into event_name        concat('Transfer to ', coalesce(name, 'Unknown'))
			from public.acorn_lojistiks_locations
			where id = new.destination_location_id;
		update acorn_calendar_event_part 
			set name = event_name
			where event_id = new.created_at;
	end if;
	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_warehouses DROP CONSTRAINT IF EXISTS warehouses_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicles DROP CONSTRAINT IF EXISTS vehicles_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicle_types DROP CONSTRAINT IF EXISTS vehicle_types_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicles DROP CONSTRAINT IF EXISTS vehicle_type_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_drivers DROP CONSTRAINT IF EXISTS vehicle_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS vehicle_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS user_role_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS user_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_locations DROP CONSTRAINT IF EXISTS user_group_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS transfers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instance_transfer DROP CONSTRAINT IF EXISTS transfer_product_instances_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_purchase DROP CONSTRAINT IF EXISTS transfer_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_invoice DROP CONSTRAINT IF EXISTS transfer_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_containers DROP CONSTRAINT IF EXISTS transfer_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instance_transfer DROP CONSTRAINT IF EXISTS transfer_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instance DROP CONSTRAINT IF EXISTS transfer_container_product_instances_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instance DROP CONSTRAINT IF EXISTS transfer_container_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_containers DROP CONSTRAINT IF EXISTS transfer_container_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_suppliers DROP CONSTRAINT IF EXISTS suppliers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_products DROP CONSTRAINT IF EXISTS sub_product_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS source_location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_products DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_suppliers DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_warehouses DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instances DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_attributes DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_offices DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_brands DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_locations DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products_product_categories DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_categories DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_category_types DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instance DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_containers DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_drivers DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicles DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_containers DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicle_types DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instance_transfer DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_measurement_units DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_gps DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_area_types DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_purchase DROP CONSTRAINT IF EXISTS purchase_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products_product_categories DROP CONSTRAINT IF EXISTS products_product_categories_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products DROP CONSTRAINT IF EXISTS products_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_products DROP CONSTRAINT IF EXISTS product_products_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instances DROP CONSTRAINT IF EXISTS product_instances_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instance DROP CONSTRAINT IF EXISTS product_instance_transfer_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instance_transfer DROP CONSTRAINT IF EXISTS product_instance_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_attributes DROP CONSTRAINT IF EXISTS product_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_products DROP CONSTRAINT IF EXISTS product_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instances DROP CONSTRAINT IF EXISTS product_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products_product_categories DROP CONSTRAINT IF EXISTS product_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_category_types DROP CONSTRAINT IF EXISTS product_category_types_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_categories DROP CONSTRAINT IF EXISTS product_category_type_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products_product_categories DROP CONSTRAINT IF EXISTS product_category_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_categories DROP CONSTRAINT IF EXISTS product_categories_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_attributes DROP CONSTRAINT IF EXISTS product_attributes_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS person_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_drivers DROP CONSTRAINT IF EXISTS person_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS people_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_categories DROP CONSTRAINT IF EXISTS parent_product_category_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS parent_area_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_offices DROP CONSTRAINT IF EXISTS offices_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_measurement_units DROP CONSTRAINT IF EXISTS measurement_units_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products DROP CONSTRAINT IF EXISTS measurement_unit_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_locations DROP CONSTRAINT IF EXISTS locations_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_suppliers DROP CONSTRAINT IF EXISTS location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_warehouses DROP CONSTRAINT IF EXISTS location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_offices DROP CONSTRAINT IF EXISTS location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS last_transfer_source_location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS last_transfer_destination_location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS last_product_instance_source_location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS last_product_instance_destination_location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_invoice DROP CONSTRAINT IF EXISTS invoice_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instances DROP CONSTRAINT IF EXISTS initial_transfer_product_instance_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicles DROP CONSTRAINT IF EXISTS initial_transfer_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS gps_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS gps_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_gps DROP CONSTRAINT IF EXISTS gps_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS employees_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_drivers DROP CONSTRAINT IF EXISTS drivers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS driver_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS destination_location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_containers DROP CONSTRAINT IF EXISTS created_at_event_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instance DROP CONSTRAINT IF EXISTS created_at_event_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS created_at;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS created_at;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_containers DROP CONSTRAINT IF EXISTS containers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_containers DROP CONSTRAINT IF EXISTS container_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_brands DROP CONSTRAINT IF EXISTS brands_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products DROP CONSTRAINT IF EXISTS brand_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS areas_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_area_types DROP CONSTRAINT IF EXISTS area_types_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS area_type_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS area_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS addresses_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_locations DROP CONSTRAINT IF EXISTS address_id;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_electronic_products DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_computer_products DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_electronic_products DROP CONSTRAINT IF EXISTS product_id;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_electronic_products DROP CONSTRAINT IF EXISTS electronic_products_created_by_user;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_computer_products DROP CONSTRAINT IF EXISTS electronic_product_id;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_computer_products DROP CONSTRAINT IF EXISTS computer_products_created_by_user;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_warehouses_server_id ON public.acorn_lojistiks_warehouses;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_warehouses_new_replicated_row ON public.acorn_lojistiks_warehouses;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_vehicles_server_id ON public.acorn_lojistiks_vehicles;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_vehicles_new_replicated_row ON public.acorn_lojistiks_vehicles;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_vehicle_types_server_id ON public.acorn_lojistiks_vehicle_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_vehicle_types_new_replicated_row ON public.acorn_lojistiks_vehicle_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfers_update_calendar ON public.acorn_lojistiks_transfers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfers_server_id ON public.acorn_lojistiks_transfers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfers_new_replicated_row ON public.acorn_lojistiks_transfers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfers_insert_calendar ON public.acorn_lojistiks_transfers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfers_delete_calendar ON public.acorn_lojistiks_transfers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfer_container_server_id ON public.acorn_lojistiks_transfer_containers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfer_container_product_instanc ON public.acorn_lojistiks_transfer_container_product_instance;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfer_container_new_replicated_ ON public.acorn_lojistiks_transfer_containers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_suppliers_server_id ON public.acorn_lojistiks_suppliers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_suppliers_new_replicated_row ON public.acorn_lojistiks_suppliers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_products_server_id ON public.acorn_lojistiks_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_products_product_categories_server ON public.acorn_lojistiks_products_product_categories;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_products_product_categories_new_re ON public.acorn_lojistiks_products_product_categories;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_products_new_replicated_row ON public.acorn_lojistiks_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_products_server_id ON public.acorn_lojistiks_product_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_products_new_replicated_ro ON public.acorn_lojistiks_product_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_instances_server_id ON public.acorn_lojistiks_product_instances;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_instances_new_replicated_r ON public.acorn_lojistiks_product_instances;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_instance_transfer_server_i ON public.acorn_lojistiks_product_instance_transfer;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_instance_transfer_new_repl ON public.acorn_lojistiks_product_instance_transfer;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_category_types_server_id ON public.acorn_lojistiks_product_category_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_category_types_new_replica ON public.acorn_lojistiks_product_category_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_categories_server_id ON public.acorn_lojistiks_product_categories;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_categories_new_replicated_ ON public.acorn_lojistiks_product_categories;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_attributes_server_id ON public.acorn_lojistiks_product_attributes;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_attributes_new_replicated_ ON public.acorn_lojistiks_product_attributes;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_people_server_id ON public.acorn_lojistiks_people;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_people_new_replicated_row ON public.acorn_lojistiks_people;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_offices_server_id ON public.acorn_lojistiks_offices;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_offices_new_replicated_row ON public.acorn_lojistiks_offices;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_measurement_units_server_id ON public.acorn_lojistiks_measurement_units;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_measurement_units_new_replicated_r ON public.acorn_lojistiks_measurement_units;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_locations_server_id ON public.acorn_lojistiks_locations;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_locations_new_replicated_row ON public.acorn_lojistiks_locations;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_gps_server_id ON public.acorn_lojistiks_gps;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_gps_new_replicated_row ON public.acorn_lojistiks_gps;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_employees_server_id ON public.acorn_lojistiks_employees;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_employees_new_replicated_row ON public.acorn_lojistiks_employees;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_drivers_server_id ON public.acorn_lojistiks_drivers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_drivers_new_replicated_row ON public.acorn_lojistiks_drivers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_containers_server_id ON public.acorn_lojistiks_containers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_containers_new_replicated_row ON public.acorn_lojistiks_containers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_brands_server_id ON public.acorn_lojistiks_brands;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_brands_new_replicated_row ON public.acorn_lojistiks_brands;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_areas_server_id ON public.acorn_lojistiks_areas;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_areas_new_replicated_row ON public.acorn_lojistiks_areas;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_area_types_server_id ON public.acorn_lojistiks_area_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_area_types_new_replicated_row ON public.acorn_lojistiks_area_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_addresses_server_id ON public.acorn_lojistiks_addresses;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_addresses_new_replicated_row ON public.acorn_lojistiks_addresses;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_electronic_products_server_id ON product.acorn_lojistiks_electronic_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_electronic_products_new_replicated ON product.acorn_lojistiks_electronic_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_computer_products_server_id ON product.acorn_lojistiks_computer_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_computer_products_new_replicated_r ON product.acorn_lojistiks_computer_products;
DROP INDEX IF EXISTS public.fki_transfer_id;
DROP INDEX IF EXISTS public.fki_purchase_id;
DROP INDEX IF EXISTS public.fki_parent_product_category_id;
DROP INDEX IF EXISTS public.fki_last_transfer_source_location_id;
DROP INDEX IF EXISTS public.fki_last_transfer_destination_location_id;
DROP INDEX IF EXISTS public.fki_last_product_instance_source_location_id;
DROP INDEX IF EXISTS public.fki_last_product_instance_destination_location_id;
DROP INDEX IF EXISTS public.fki_invoice_id;
DROP INDEX IF EXISTS public.fki_initial_transfer_id;
DROP INDEX IF EXISTS public.fki_created_at_event_id;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_warehouses_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_vehicles_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_vehicle_types_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_transfers_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_transfer_container_replica_identit;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_transfer_container_product_instanc;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_suppliers_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_products_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_products_product_categories_replic;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_product_products_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_product_instances_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_product_instance_transfer_replica_;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_product_category_types_replica_ide;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_product_categories_replica_identit;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_product_attributes_replica_identit;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_people_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_office_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_measurement_units_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_location_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_gps_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_employees_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_drivers_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_containers_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_brands_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_areas_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_area_types_replica_identity;
DROP INDEX IF EXISTS public.dr_acorn_lojistiks_addresses_replica_identity;
DROP INDEX IF EXISTS product.fki_server_id;
DROP INDEX IF EXISTS product.dr_acorn_lojistiks_electronic_products_replica_identi;
DROP INDEX IF EXISTS product.dr_acorn_lojistiks_computer_products_replica_identity;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicles DROP CONSTRAINT IF EXISTS vehicles_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicle_types DROP CONSTRAINT IF EXISTS vehicle_types_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS transfers_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instance_transfer DROP CONSTRAINT IF EXISTS transfer_product_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instance DROP CONSTRAINT IF EXISTS transfer_container_products_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_containers DROP CONSTRAINT IF EXISTS transfer_container_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_suppliers DROP CONSTRAINT IF EXISTS suppliers_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products_product_categories DROP CONSTRAINT IF EXISTS products_product_categories_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products DROP CONSTRAINT IF EXISTS products_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instances DROP CONSTRAINT IF EXISTS product_instances_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_category_types DROP CONSTRAINT IF EXISTS product_category_types_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_categories DROP CONSTRAINT IF EXISTS product_categories_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_attributes DROP CONSTRAINT IF EXISTS product_attributes_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS person_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_offices DROP CONSTRAINT IF EXISTS office_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_measurement_units DROP CONSTRAINT IF EXISTS measurement_units_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_locations DROP CONSTRAINT IF EXISTS location_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_gps DROP CONSTRAINT IF EXISTS gps_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_drivers DROP CONSTRAINT IF EXISTS drivers_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_containers DROP CONSTRAINT IF EXISTS containers_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_brands DROP CONSTRAINT IF EXISTS brands_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS areas_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_area_types DROP CONSTRAINT IF EXISTS area_types_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS addresses_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_warehouses DROP CONSTRAINT IF EXISTS acorn_lojistiks_warehouses_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_products DROP CONSTRAINT IF EXISTS acorn_lojistiks_product_products_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS acorn_lojistiks_employees_pkey;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_electronic_products DROP CONSTRAINT IF EXISTS office_products_pkey;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_computer_products DROP CONSTRAINT IF EXISTS computer_products_pkey;
DROP TABLE IF EXISTS public.acorn_lojistiks_warehouses;
DROP TABLE IF EXISTS public.acorn_lojistiks_vehicles;
DROP TABLE IF EXISTS public.acorn_lojistiks_vehicle_types;
DROP VIEW IF EXISTS public.acorn_lojistiks_vehicle_lasts;
DROP TABLE IF EXISTS public.acorn_lojistiks_transfer_purchase;
DROP TABLE IF EXISTS public.acorn_lojistiks_transfer_invoice;
DROP TABLE IF EXISTS public.acorn_lojistiks_transfer_containers;
DROP TABLE IF EXISTS public.acorn_lojistiks_transfer_container_product_instance;
DROP TABLE IF EXISTS public.acorn_lojistiks_suppliers;
DROP VIEW IF EXISTS public.acorn_lojistiks_stock_products;
DROP VIEW IF EXISTS public.acorn_lojistiks_stocks;
DROP TABLE IF EXISTS public.acorn_lojistiks_products_product_categories;
DROP TABLE IF EXISTS public.acorn_lojistiks_products;
DROP TABLE IF EXISTS public.acorn_lojistiks_product_products;
DROP TABLE IF EXISTS public.acorn_lojistiks_product_category_types;
DROP TABLE IF EXISTS public.acorn_lojistiks_product_categories;
DROP TABLE IF EXISTS public.acorn_lojistiks_product_attributes;
DROP TABLE IF EXISTS public.acorn_lojistiks_people;
DROP TABLE IF EXISTS public.acorn_lojistiks_offices;
DROP VIEW IF EXISTS public.acorn_lojistiks_movements;
DROP TABLE IF EXISTS public.acorn_lojistiks_transfers;
DROP TABLE IF EXISTS public.acorn_lojistiks_product_instances;
DROP TABLE IF EXISTS public.acorn_lojistiks_product_instance_transfer;
DROP TABLE IF EXISTS public.acorn_lojistiks_measurement_units;
DROP TABLE IF EXISTS public.acorn_lojistiks_locations;
DROP TABLE IF EXISTS public.acorn_lojistiks_gps;
DROP TABLE IF EXISTS public.acorn_lojistiks_employees;
DROP TABLE IF EXISTS public.acorn_lojistiks_drivers;
DROP TABLE IF EXISTS public.acorn_lojistiks_containers;
DROP TABLE IF EXISTS public.acorn_lojistiks_brands;
DROP TABLE IF EXISTS public.acorn_lojistiks_areas;
DROP TABLE IF EXISTS public.acorn_lojistiks_area_types;
DROP TABLE IF EXISTS public.acorn_lojistiks_addresses;
DROP TABLE IF EXISTS product.acorn_lojistiks_electronic_products;
DROP TABLE IF EXISTS product.acorn_lojistiks_computer_products;
SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: acorn_lojistiks_computer_products; Type: TABLE; Schema: product; Owner: -
--

CREATE TABLE product.acorn_lojistiks_computer_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    electronic_product_id uuid NOT NULL,
    memory bigint,
    "HDD_size" bigint,
    processor_version double precision,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    processor_type integer,
    response text
);


--
-- Name: acorn_lojistiks_electronic_products; Type: TABLE; Schema: product; Owner: -
--

CREATE TABLE product.acorn_lojistiks_electronic_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    voltage double precision,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_addresses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    number character varying(1024),
    image character varying(2048),
    area_id uuid NOT NULL,
    gps_id uuid,
    server_id uuid NOT NULL,
    created_by_user_id uuid,
    created_at_event_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_area_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_area_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_areas (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    area_type_id uuid NOT NULL,
    parent_area_id uuid,
    gps_id uuid,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(2048) NOT NULL,
    image character varying(2048),
    response text,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid
);


--
-- Name: acorn_lojistiks_containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_containers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    name character varying(1024),
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_drivers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_drivers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    vehicle_id uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_employees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    person_id uuid NOT NULL,
    user_role_id uuid NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_gps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_gps (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    longitude double precision,
    latitude double precision,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_locations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    address_id uuid NOT NULL,
    name character varying(2048) NOT NULL,
    image character varying(2048),
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text,
    user_group_id uuid
);


--
-- Name: acorn_lojistiks_measurement_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_measurement_units (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    short_name character varying(1024),
    uses_quantity boolean DEFAULT true NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_product_instance_transfer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_instance_transfer (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transfer_id uuid NOT NULL,
    product_instance_id uuid NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_product_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_instances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    external_identifier character varying(2048),
    initial_product_instance_transfer_id uuid,
    asset_class "char" DEFAULT 'C'::"char" NOT NULL,
    image character varying(2048),
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: COLUMN acorn_lojistiks_product_instances.initial_product_instance_transfer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.acorn_lojistiks_product_instances.initial_product_instance_transfer_id IS 'system: true';


--
-- Name: acorn_lojistiks_transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    source_location_id uuid NOT NULL,
    destination_location_id uuid NOT NULL,
    driver_id uuid,
    sent_at timestamp with time zone DEFAULT now(),
    arrived_at timestamp with time zone,
    server_id uuid NOT NULL,
    vehicle_id uuid,
    created_by_user_id uuid,
    created_at_event_id uuid,
    response text,
    pre_marked_arrived boolean DEFAULT false NOT NULL
);


--
-- Name: acorn_lojistiks_movements; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.acorn_lojistiks_movements AS
 SELECT tr.id AS transfer_id,
    'D'::text AS type,
    tr.destination_location_id AS location_id,
    tr.destination_location_id,
    tr.source_location_id,
    trp.product_instance_id,
    pi.quantity
   FROM ((public.acorn_lojistiks_transfers tr
     JOIN public.acorn_lojistiks_product_instance_transfer trp ON ((tr.id = trp.transfer_id)))
     JOIN public.acorn_lojistiks_product_instances pi ON ((pi.id = trp.product_instance_id)))
  WHERE ((((NOT (tr.arrived_at IS NULL)) AND (tr.arrived_at <= now())) OR (tr.pre_marked_arrived = true)) AND ((NOT (tr.sent_at IS NULL)) AND (tr.sent_at <= now())))
UNION ALL
 SELECT tr.id AS transfer_id,
    'S'::text AS type,
    tr.source_location_id AS location_id,
    tr.destination_location_id,
    tr.source_location_id,
    trp.product_instance_id,
    ((- (1)::numeric) * (pi.quantity)::numeric) AS quantity
   FROM ((public.acorn_lojistiks_transfers tr
     JOIN public.acorn_lojistiks_product_instance_transfer trp ON ((tr.id = trp.transfer_id)))
     JOIN public.acorn_lojistiks_product_instances pi ON ((pi.id = trp.product_instance_id)))
  WHERE ((NOT (tr.sent_at IS NULL)) AND (tr.sent_at <= now()));


--
-- Name: acorn_lojistiks_offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_offices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_people (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid,
    image character varying(2048),
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text,
    last_transfer_source_location_id uuid,
    last_transfer_destination_location_id uuid,
    last_product_instance_source_location_id uuid,
    last_product_instance_destination_location_id uuid
);


--
-- Name: acorn_lojistiks_product_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_attributes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    name character varying(1024) NOT NULL,
    value character varying(1024) NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    product_category_type_id uuid NOT NULL,
    parent_product_category_id uuid NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_product_category_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_category_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_product_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    sub_product_id uuid NOT NULL,
    quantity integer NOT NULL,
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    measurement_unit_id uuid NOT NULL,
    brand_id uuid NOT NULL,
    image character varying(2048),
    model_name character varying(2048),
    server_id uuid NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_products_product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_products_product_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    product_category_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_stocks; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.acorn_lojistiks_stocks AS
 SELECT row_number() OVER () AS id,
    alm.location_id,
    alm.product_instance_id,
    mi.uses_quantity,
    sum(alm.quantity) AS quantity
   FROM (((public.acorn_lojistiks_movements alm
     JOIN public.acorn_lojistiks_product_instances pi ON ((alm.product_instance_id = pi.id)))
     JOIN public.acorn_lojistiks_products pr ON ((pi.product_id = pr.id)))
     JOIN public.acorn_lojistiks_measurement_units mi ON ((pr.measurement_unit_id = mi.id)))
  GROUP BY alm.location_id, alm.product_instance_id, mi.uses_quantity
 HAVING (sum(alm.quantity) <> (0)::numeric);


--
-- Name: acorn_lojistiks_stock_products; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.acorn_lojistiks_stock_products AS
 SELECT row_number() OVER () AS id,
    als.location_id,
    alpi.product_id,
    als.uses_quantity,
    sum(als.quantity) AS quantity
   FROM ((public.acorn_lojistiks_stocks als
     JOIN public.acorn_lojistiks_product_instances alpi ON ((als.product_instance_id = alpi.id)))
     JOIN public.acorn_lojistiks_products alp ON ((alpi.product_id = alp.id)))
  GROUP BY als.location_id, alpi.product_id, als.uses_quantity;


--
-- Name: acorn_lojistiks_suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_suppliers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_transfer_container_product_instance; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_container_product_instance (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transfer_container_id uuid NOT NULL,
    product_instance_transfer_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at_event_id uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: COLUMN acorn_lojistiks_transfer_container_product_instance.transfer_container_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.acorn_lojistiks_transfer_container_product_instance.transfer_container_id IS 'todo: true';


--
-- Name: COLUMN acorn_lojistiks_transfer_container_product_instance.product_instance_transfer_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.acorn_lojistiks_transfer_container_product_instance.product_instance_transfer_id IS 'todo: true';


--
-- Name: acorn_lojistiks_transfer_containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_containers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transfer_id uuid NOT NULL,
    container_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at_event_id uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_transfer_invoice; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_invoice (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transfer_id uuid NOT NULL,
    invoice_id uuid NOT NULL
);


--
-- Name: acorn_lojistiks_transfer_purchase; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_purchase (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transfer_id uuid NOT NULL,
    purchase_id uuid NOT NULL
);


--
-- Name: acorn_lojistiks_vehicle_lasts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.acorn_lojistiks_vehicle_lasts AS
 SELECT tr.vehicle_id AS id,
    tr.vehicle_id,
    lasts.transfer_id,
        CASE
            WHEN ((tr.arrived_at IS NULL) AND (NOT tr.pre_marked_arrived)) THEN NULL::uuid
            ELSE tr.destination_location_id
        END AS location_id
   FROM (( SELECT acorn_lojistiks_transfers.vehicle_id,
            public.agg_acorn_last(acorn_lojistiks_transfers.id) AS transfer_id,
            public.agg_acorn_last(acorn_lojistiks_transfers.created_at_event_id) AS created_at,
            count(*) AS count
           FROM public.acorn_lojistiks_transfers
          WHERE (NOT (acorn_lojistiks_transfers.vehicle_id IS NULL))
          GROUP BY acorn_lojistiks_transfers.vehicle_id
          ORDER BY (public.agg_acorn_last(acorn_lojistiks_transfers.created_at_event_id)) DESC
         LIMIT 1) lasts
     JOIN public.acorn_lojistiks_transfers tr ON ((lasts.transfer_id = tr.id)));


--
-- Name: acorn_lojistiks_vehicle_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_vehicle_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_vehicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_vehicles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    vehicle_type_id uuid NOT NULL,
    registration character varying(1024) NOT NULL,
    image character varying(2048),
    initial_transfer_id uuid,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_warehouses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_warehouses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at uuid,
    created_by_user_id uuid,
    response text
);


--
-- Name: acorn_lojistiks_computer_products computer_products_pkey; Type: CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_computer_products
    ADD CONSTRAINT computer_products_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_electronic_products office_products_pkey; Type: CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_electronic_products
    ADD CONSTRAINT office_products_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_employees acorn_lojistiks_employees_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT acorn_lojistiks_employees_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_product_products acorn_lojistiks_product_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_products
    ADD CONSTRAINT acorn_lojistiks_product_products_pkey PRIMARY KEY (product_id, sub_product_id);


--
-- Name: acorn_lojistiks_warehouses acorn_lojistiks_warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_warehouses
    ADD CONSTRAINT acorn_lojistiks_warehouses_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_area_types area_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_area_types
    ADD CONSTRAINT area_types_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_containers containers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_containers
    ADD CONSTRAINT containers_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_drivers drivers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_drivers
    ADD CONSTRAINT drivers_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_gps gps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_gps
    ADD CONSTRAINT gps_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_locations location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT location_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_measurement_units measurement_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_measurement_units
    ADD CONSTRAINT measurement_units_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_offices office_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_offices
    ADD CONSTRAINT office_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_people person_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT person_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_product_attributes product_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_attributes
    ADD CONSTRAINT product_attributes_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_product_category_types product_category_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_category_types
    ADD CONSTRAINT product_category_types_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_product_instances product_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances
    ADD CONSTRAINT product_instances_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_products_product_categories products_product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories
    ADD CONSTRAINT products_product_categories_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_transfer_containers transfer_container_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_containers
    ADD CONSTRAINT transfer_container_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_transfer_container_product_instance transfer_container_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instance
    ADD CONSTRAINT transfer_container_products_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_product_instance_transfer transfer_product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT transfer_product_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_vehicle_types vehicle_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicle_types
    ADD CONSTRAINT vehicle_types_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id);


--
-- Name: dr_acorn_lojistiks_computer_products_replica_identity; Type: INDEX; Schema: product; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_computer_products_replica_identity ON product.acorn_lojistiks_computer_products USING btree (server_id, id);

ALTER TABLE ONLY product.acorn_lojistiks_computer_products REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_computer_products_replica_identity;


--
-- Name: dr_acorn_lojistiks_electronic_products_replica_identi; Type: INDEX; Schema: product; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_electronic_products_replica_identi ON product.acorn_lojistiks_electronic_products USING btree (server_id, id);

ALTER TABLE ONLY product.acorn_lojistiks_electronic_products REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_electronic_products_replica_identi;


--
-- Name: fki_server_id; Type: INDEX; Schema: product; Owner: -
--

CREATE INDEX fki_server_id ON product.acorn_lojistiks_computer_products USING btree (server_id);


--
-- Name: dr_acorn_lojistiks_addresses_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_addresses_replica_identity ON public.acorn_lojistiks_addresses USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_addresses REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_addresses_replica_identity;


--
-- Name: dr_acorn_lojistiks_area_types_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_area_types_replica_identity ON public.acorn_lojistiks_area_types USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_area_types REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_area_types_replica_identity;


--
-- Name: dr_acorn_lojistiks_areas_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_areas_replica_identity ON public.acorn_lojistiks_areas USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_areas REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_areas_replica_identity;


--
-- Name: dr_acorn_lojistiks_brands_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_brands_replica_identity ON public.acorn_lojistiks_brands USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_brands REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_brands_replica_identity;


--
-- Name: dr_acorn_lojistiks_containers_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_containers_replica_identity ON public.acorn_lojistiks_containers USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_containers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_containers_replica_identity;


--
-- Name: dr_acorn_lojistiks_drivers_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_drivers_replica_identity ON public.acorn_lojistiks_drivers USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_drivers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_drivers_replica_identity;


--
-- Name: dr_acorn_lojistiks_employees_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_employees_replica_identity ON public.acorn_lojistiks_employees USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_employees REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_employees_replica_identity;


--
-- Name: dr_acorn_lojistiks_gps_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_gps_replica_identity ON public.acorn_lojistiks_gps USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_gps REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_gps_replica_identity;


--
-- Name: dr_acorn_lojistiks_location_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_location_replica_identity ON public.acorn_lojistiks_locations USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_locations REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_location_replica_identity;


--
-- Name: dr_acorn_lojistiks_measurement_units_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_measurement_units_replica_identity ON public.acorn_lojistiks_measurement_units USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_measurement_units REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_measurement_units_replica_identity;


--
-- Name: dr_acorn_lojistiks_office_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_office_replica_identity ON public.acorn_lojistiks_offices USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_offices REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_office_replica_identity;


--
-- Name: dr_acorn_lojistiks_people_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_people_replica_identity ON public.acorn_lojistiks_people USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_people REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_people_replica_identity;


--
-- Name: dr_acorn_lojistiks_product_attributes_replica_identit; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_product_attributes_replica_identit ON public.acorn_lojistiks_product_attributes USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_product_attributes REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_attributes_replica_identit;


--
-- Name: dr_acorn_lojistiks_product_categories_replica_identit; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_product_categories_replica_identit ON public.acorn_lojistiks_product_categories USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_product_categories REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_categories_replica_identit;


--
-- Name: dr_acorn_lojistiks_product_category_types_replica_ide; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_product_category_types_replica_ide ON public.acorn_lojistiks_product_category_types USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_product_category_types REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_category_types_replica_ide;


--
-- Name: dr_acorn_lojistiks_product_instance_transfer_replica_; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_product_instance_transfer_replica_ ON public.acorn_lojistiks_product_instance_transfer USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_instance_transfer_replica_;


--
-- Name: dr_acorn_lojistiks_product_instances_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_product_instances_replica_identity ON public.acorn_lojistiks_product_instances USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_product_instances REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_instances_replica_identity;


--
-- Name: dr_acorn_lojistiks_product_products_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_product_products_replica_identity ON public.acorn_lojistiks_product_products USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_product_products REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_products_replica_identity;


--
-- Name: dr_acorn_lojistiks_products_product_categories_replic; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_products_product_categories_replic ON public.acorn_lojistiks_products_product_categories USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_products_product_categories_replic;


--
-- Name: dr_acorn_lojistiks_products_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_products_replica_identity ON public.acorn_lojistiks_products USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_products REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_products_replica_identity;


--
-- Name: dr_acorn_lojistiks_suppliers_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_suppliers_replica_identity ON public.acorn_lojistiks_suppliers USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_suppliers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_suppliers_replica_identity;


--
-- Name: dr_acorn_lojistiks_transfer_container_product_instanc; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_transfer_container_product_instanc ON public.acorn_lojistiks_transfer_container_product_instance USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instance REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_transfer_container_product_instanc;


--
-- Name: dr_acorn_lojistiks_transfer_container_replica_identit; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_transfer_container_replica_identit ON public.acorn_lojistiks_transfer_containers USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_transfer_containers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_transfer_container_replica_identit;


--
-- Name: dr_acorn_lojistiks_transfers_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_transfers_replica_identity ON public.acorn_lojistiks_transfers USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_transfers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_transfers_replica_identity;


--
-- Name: dr_acorn_lojistiks_vehicle_types_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_vehicle_types_replica_identity ON public.acorn_lojistiks_vehicle_types USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_vehicle_types REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_vehicle_types_replica_identity;


--
-- Name: dr_acorn_lojistiks_vehicles_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_vehicles_replica_identity ON public.acorn_lojistiks_vehicles USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_vehicles REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_vehicles_replica_identity;


--
-- Name: dr_acorn_lojistiks_warehouses_replica_identity; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX dr_acorn_lojistiks_warehouses_replica_identity ON public.acorn_lojistiks_warehouses USING btree (server_id, id);

ALTER TABLE ONLY public.acorn_lojistiks_warehouses REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_warehouses_replica_identity;


--
-- Name: fki_created_at_event_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_created_at_event_id ON public.acorn_lojistiks_transfer_container_product_instance USING btree (created_at_event_id);


--
-- Name: fki_initial_transfer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_initial_transfer_id ON public.acorn_lojistiks_vehicles USING btree (initial_transfer_id);


--
-- Name: fki_invoice_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_invoice_id ON public.acorn_lojistiks_transfer_invoice USING btree (invoice_id);


--
-- Name: fki_last_product_instance_destination_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_last_product_instance_destination_location_id ON public.acorn_lojistiks_people USING btree (last_product_instance_destination_location_id);


--
-- Name: fki_last_product_instance_source_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_last_product_instance_source_location_id ON public.acorn_lojistiks_people USING btree (last_product_instance_source_location_id);


--
-- Name: fki_last_transfer_destination_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_last_transfer_destination_location_id ON public.acorn_lojistiks_people USING btree (last_transfer_destination_location_id);


--
-- Name: fki_last_transfer_source_location_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_last_transfer_source_location_id ON public.acorn_lojistiks_people USING btree (last_transfer_source_location_id);


--
-- Name: fki_parent_product_category_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_parent_product_category_id ON public.acorn_lojistiks_product_categories USING btree (parent_product_category_id);


--
-- Name: fki_purchase_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_purchase_id ON public.acorn_lojistiks_transfer_purchase USING btree (purchase_id);


--
-- Name: fki_transfer_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_transfer_id ON public.acorn_lojistiks_transfer_invoice USING btree (transfer_id);


--
-- Name: acorn_lojistiks_computer_products tr_acorn_lojistiks_computer_products_new_replicated_r; Type: TRIGGER; Schema: product; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_computer_products_new_replicated_r BEFORE INSERT ON product.acorn_lojistiks_computer_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE product.acorn_lojistiks_computer_products ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_computer_products_new_replicated_r;


--
-- Name: acorn_lojistiks_computer_products tr_acorn_lojistiks_computer_products_server_id; Type: TRIGGER; Schema: product; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_computer_products_server_id BEFORE INSERT ON product.acorn_lojistiks_computer_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_electronic_products tr_acorn_lojistiks_electronic_products_new_replicated; Type: TRIGGER; Schema: product; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_electronic_products_new_replicated BEFORE INSERT ON product.acorn_lojistiks_electronic_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE product.acorn_lojistiks_electronic_products ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_electronic_products_new_replicated;


--
-- Name: acorn_lojistiks_electronic_products tr_acorn_lojistiks_electronic_products_server_id; Type: TRIGGER; Schema: product; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_electronic_products_server_id BEFORE INSERT ON product.acorn_lojistiks_electronic_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_addresses tr_acorn_lojistiks_addresses_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_addresses_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_addresses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_addresses ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_addresses_new_replicated_row;


--
-- Name: acorn_lojistiks_addresses tr_acorn_lojistiks_addresses_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_addresses_server_id BEFORE INSERT ON public.acorn_lojistiks_addresses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_area_types tr_acorn_lojistiks_area_types_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_area_types_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_area_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_area_types ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_area_types_new_replicated_row;


--
-- Name: acorn_lojistiks_area_types tr_acorn_lojistiks_area_types_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_area_types_server_id BEFORE INSERT ON public.acorn_lojistiks_area_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_areas tr_acorn_lojistiks_areas_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_areas_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_areas FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_areas ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_areas_new_replicated_row;


--
-- Name: acorn_lojistiks_areas tr_acorn_lojistiks_areas_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_areas_server_id BEFORE INSERT ON public.acorn_lojistiks_areas FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_brands tr_acorn_lojistiks_brands_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_brands_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_brands FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_brands ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_brands_new_replicated_row;


--
-- Name: acorn_lojistiks_brands tr_acorn_lojistiks_brands_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_brands_server_id BEFORE INSERT ON public.acorn_lojistiks_brands FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_containers tr_acorn_lojistiks_containers_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_containers_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_containers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_containers ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_containers_new_replicated_row;


--
-- Name: acorn_lojistiks_containers tr_acorn_lojistiks_containers_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_containers_server_id BEFORE INSERT ON public.acorn_lojistiks_containers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_drivers tr_acorn_lojistiks_drivers_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_drivers_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_drivers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_drivers ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_drivers_new_replicated_row;


--
-- Name: acorn_lojistiks_drivers tr_acorn_lojistiks_drivers_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_drivers_server_id BEFORE INSERT ON public.acorn_lojistiks_drivers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_employees tr_acorn_lojistiks_employees_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_employees_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_employees FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_employees ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_employees_new_replicated_row;


--
-- Name: acorn_lojistiks_employees tr_acorn_lojistiks_employees_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_employees_server_id BEFORE INSERT ON public.acorn_lojistiks_employees FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_gps tr_acorn_lojistiks_gps_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_gps_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_gps FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_gps ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_gps_new_replicated_row;


--
-- Name: acorn_lojistiks_gps tr_acorn_lojistiks_gps_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_gps_server_id BEFORE INSERT ON public.acorn_lojistiks_gps FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_locations tr_acorn_lojistiks_locations_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_locations_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_locations FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_locations ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_locations_new_replicated_row;


--
-- Name: acorn_lojistiks_locations tr_acorn_lojistiks_locations_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_locations_server_id BEFORE INSERT ON public.acorn_lojistiks_locations FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_measurement_units tr_acorn_lojistiks_measurement_units_new_replicated_r; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_measurement_units_new_replicated_r BEFORE INSERT ON public.acorn_lojistiks_measurement_units FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_measurement_units ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_measurement_units_new_replicated_r;


--
-- Name: acorn_lojistiks_measurement_units tr_acorn_lojistiks_measurement_units_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_measurement_units_server_id BEFORE INSERT ON public.acorn_lojistiks_measurement_units FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_offices tr_acorn_lojistiks_offices_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_offices_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_offices FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_offices ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_offices_new_replicated_row;


--
-- Name: acorn_lojistiks_offices tr_acorn_lojistiks_offices_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_offices_server_id BEFORE INSERT ON public.acorn_lojistiks_offices FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_people tr_acorn_lojistiks_people_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_people_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_people FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_people ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_people_new_replicated_row;


--
-- Name: acorn_lojistiks_people tr_acorn_lojistiks_people_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_people_server_id BEFORE INSERT ON public.acorn_lojistiks_people FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_product_attributes tr_acorn_lojistiks_product_attributes_new_replicated_; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_attributes_new_replicated_ BEFORE INSERT ON public.acorn_lojistiks_product_attributes FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_product_attributes ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_product_attributes_new_replicated_;


--
-- Name: acorn_lojistiks_product_attributes tr_acorn_lojistiks_product_attributes_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_attributes_server_id BEFORE INSERT ON public.acorn_lojistiks_product_attributes FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_product_categories tr_acorn_lojistiks_product_categories_new_replicated_; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_categories_new_replicated_ BEFORE INSERT ON public.acorn_lojistiks_product_categories FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_product_categories ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_product_categories_new_replicated_;


--
-- Name: acorn_lojistiks_product_categories tr_acorn_lojistiks_product_categories_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_categories_server_id BEFORE INSERT ON public.acorn_lojistiks_product_categories FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_product_category_types tr_acorn_lojistiks_product_category_types_new_replica; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_category_types_new_replica BEFORE INSERT ON public.acorn_lojistiks_product_category_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_product_category_types ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_product_category_types_new_replica;


--
-- Name: acorn_lojistiks_product_category_types tr_acorn_lojistiks_product_category_types_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_category_types_server_id BEFORE INSERT ON public.acorn_lojistiks_product_category_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_product_instance_transfer tr_acorn_lojistiks_product_instance_transfer_new_repl; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_instance_transfer_new_repl BEFORE INSERT ON public.acorn_lojistiks_product_instance_transfer FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_product_instance_transfer ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_product_instance_transfer_new_repl;


--
-- Name: acorn_lojistiks_product_instance_transfer tr_acorn_lojistiks_product_instance_transfer_server_i; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_instance_transfer_server_i BEFORE INSERT ON public.acorn_lojistiks_product_instance_transfer FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_product_instances tr_acorn_lojistiks_product_instances_new_replicated_r; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_instances_new_replicated_r BEFORE INSERT ON public.acorn_lojistiks_product_instances FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_product_instances ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_product_instances_new_replicated_r;


--
-- Name: acorn_lojistiks_product_instances tr_acorn_lojistiks_product_instances_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_instances_server_id BEFORE INSERT ON public.acorn_lojistiks_product_instances FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_product_products tr_acorn_lojistiks_product_products_new_replicated_ro; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_products_new_replicated_ro BEFORE INSERT ON public.acorn_lojistiks_product_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_product_products ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_product_products_new_replicated_ro;


--
-- Name: acorn_lojistiks_product_products tr_acorn_lojistiks_product_products_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_products_server_id BEFORE INSERT ON public.acorn_lojistiks_product_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_products tr_acorn_lojistiks_products_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_products_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_products ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_products_new_replicated_row;


--
-- Name: acorn_lojistiks_products_product_categories tr_acorn_lojistiks_products_product_categories_new_re; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_products_product_categories_new_re BEFORE INSERT ON public.acorn_lojistiks_products_product_categories FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_products_product_categories ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_products_product_categories_new_re;


--
-- Name: acorn_lojistiks_products_product_categories tr_acorn_lojistiks_products_product_categories_server; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_products_product_categories_server BEFORE INSERT ON public.acorn_lojistiks_products_product_categories FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_products tr_acorn_lojistiks_products_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_products_server_id BEFORE INSERT ON public.acorn_lojistiks_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_suppliers tr_acorn_lojistiks_suppliers_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_suppliers_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_suppliers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_suppliers ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_suppliers_new_replicated_row;


--
-- Name: acorn_lojistiks_suppliers tr_acorn_lojistiks_suppliers_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_suppliers_server_id BEFORE INSERT ON public.acorn_lojistiks_suppliers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_transfer_containers tr_acorn_lojistiks_transfer_container_new_replicated_; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfer_container_new_replicated_ BEFORE INSERT ON public.acorn_lojistiks_transfer_containers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_transfer_containers ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_transfer_container_new_replicated_;


--
-- Name: acorn_lojistiks_transfer_container_product_instance tr_acorn_lojistiks_transfer_container_product_instanc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfer_container_product_instanc BEFORE INSERT ON public.acorn_lojistiks_transfer_container_product_instance FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_transfer_container_product_instance ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_transfer_container_product_instanc;


--
-- Name: acorn_lojistiks_transfer_containers tr_acorn_lojistiks_transfer_container_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfer_container_server_id BEFORE INSERT ON public.acorn_lojistiks_transfer_containers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_transfers tr_acorn_lojistiks_transfers_delete_calendar; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfers_delete_calendar AFTER DELETE ON public.acorn_lojistiks_transfers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_transfers_delete_calendar();


--
-- Name: acorn_lojistiks_transfers tr_acorn_lojistiks_transfers_insert_calendar; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfers_insert_calendar BEFORE INSERT ON public.acorn_lojistiks_transfers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_transfers_insert_calendar();


--
-- Name: acorn_lojistiks_transfers tr_acorn_lojistiks_transfers_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfers_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_transfers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_transfers ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_transfers_new_replicated_row;


--
-- Name: acorn_lojistiks_transfers tr_acorn_lojistiks_transfers_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfers_server_id BEFORE INSERT ON public.acorn_lojistiks_transfers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_transfers tr_acorn_lojistiks_transfers_update_calendar; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfers_update_calendar BEFORE UPDATE ON public.acorn_lojistiks_transfers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_transfers_update_calendar();


--
-- Name: acorn_lojistiks_vehicle_types tr_acorn_lojistiks_vehicle_types_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_vehicle_types_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_vehicle_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_vehicle_types ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_vehicle_types_new_replicated_row;


--
-- Name: acorn_lojistiks_vehicle_types tr_acorn_lojistiks_vehicle_types_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_vehicle_types_server_id BEFORE INSERT ON public.acorn_lojistiks_vehicle_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_vehicles tr_acorn_lojistiks_vehicles_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_vehicles_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_vehicles FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_vehicles ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_vehicles_new_replicated_row;


--
-- Name: acorn_lojistiks_vehicles tr_acorn_lojistiks_vehicles_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_vehicles_server_id BEFORE INSERT ON public.acorn_lojistiks_vehicles FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_warehouses tr_acorn_lojistiks_warehouses_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_warehouses_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_warehouses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_warehouses ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_warehouses_new_replicated_row;


--
-- Name: acorn_lojistiks_warehouses tr_acorn_lojistiks_warehouses_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_warehouses_server_id BEFORE INSERT ON public.acorn_lojistiks_warehouses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_server_id();


--
-- Name: acorn_lojistiks_computer_products computer_products_created_by_user; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_computer_products
    ADD CONSTRAINT computer_products_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id);


--
-- Name: acorn_lojistiks_computer_products electronic_product_id; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_computer_products
    ADD CONSTRAINT electronic_product_id FOREIGN KEY (electronic_product_id) REFERENCES product.acorn_lojistiks_electronic_products(id) NOT VALID;


--
-- Name: acorn_lojistiks_electronic_products electronic_products_created_by_user; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_electronic_products
    ADD CONSTRAINT electronic_products_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id);


--
-- Name: acorn_lojistiks_electronic_products product_id; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_electronic_products
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_computer_products server_id; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_computer_products
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_electronic_products server_id; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_electronic_products
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_locations address_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT address_id FOREIGN KEY (address_id) REFERENCES public.acorn_lojistiks_addresses(id) NOT VALID;


--
-- Name: acorn_lojistiks_addresses addresses_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT addresses_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_addresses area_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT area_id FOREIGN KEY (area_id) REFERENCES public.acorn_lojistiks_areas(id);


--
-- Name: acorn_lojistiks_areas area_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT area_type_id FOREIGN KEY (area_type_id) REFERENCES public.acorn_lojistiks_area_types(id);


--
-- Name: acorn_lojistiks_area_types area_types_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_area_types
    ADD CONSTRAINT area_types_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_areas areas_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT areas_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products brand_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT brand_id FOREIGN KEY (brand_id) REFERENCES public.acorn_lojistiks_brands(id) NOT VALID;


--
-- Name: acorn_lojistiks_brands brands_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_brands
    ADD CONSTRAINT brands_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_containers container_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_containers
    ADD CONSTRAINT container_id FOREIGN KEY (container_id) REFERENCES public.acorn_lojistiks_containers(id);


--
-- Name: acorn_lojistiks_containers containers_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_containers
    ADD CONSTRAINT containers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_addresses created_at; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT created_at FOREIGN KEY (created_at_event_id) REFERENCES public.acorn_calendar_event(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfers created_at; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT created_at FOREIGN KEY (created_at_event_id) REFERENCES public.acorn_calendar_event(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_container_product_instance created_at_event_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instance
    ADD CONSTRAINT created_at_event_id FOREIGN KEY (created_at_event_id) REFERENCES public.acorn_calendar_event(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_containers created_at_event_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_containers
    ADD CONSTRAINT created_at_event_id FOREIGN KEY (created_at_event_id) REFERENCES public.acorn_calendar_event(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfers destination_location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT destination_location_id FOREIGN KEY (destination_location_id) REFERENCES public.acorn_lojistiks_locations(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfers driver_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT driver_id FOREIGN KEY (driver_id) REFERENCES public.acorn_lojistiks_drivers(id) NOT VALID;


--
-- Name: acorn_lojistiks_drivers drivers_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_drivers
    ADD CONSTRAINT drivers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_employees employees_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT employees_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_gps gps_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_gps
    ADD CONSTRAINT gps_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_areas gps_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT gps_id FOREIGN KEY (gps_id) REFERENCES public.acorn_lojistiks_gps(id);


--
-- Name: acorn_lojistiks_addresses gps_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT gps_id FOREIGN KEY (gps_id) REFERENCES public.acorn_lojistiks_gps(id);


--
-- Name: acorn_lojistiks_vehicles initial_transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles
    ADD CONSTRAINT initial_transfer_id FOREIGN KEY (initial_transfer_id) REFERENCES public.acorn_lojistiks_transfers(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_instances initial_transfer_product_instance_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances
    ADD CONSTRAINT initial_transfer_product_instance_id FOREIGN KEY (initial_product_instance_transfer_id) REFERENCES public.acorn_lojistiks_product_instance_transfer(id) NOT VALID;


--
-- Name: CONSTRAINT initial_transfer_product_instance_id ON acorn_lojistiks_product_instances; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT initial_transfer_product_instance_id ON public.acorn_lojistiks_product_instances IS 'type: 1to1
system: true';


--
-- Name: acorn_lojistiks_transfer_invoice invoice_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_invoice
    ADD CONSTRAINT invoice_id FOREIGN KEY (invoice_id) REFERENCES public.acorn_finance_invoices(id) NOT VALID;


--
-- Name: acorn_lojistiks_people last_product_instance_destination_location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT last_product_instance_destination_location_id FOREIGN KEY (last_product_instance_destination_location_id) REFERENCES public.acorn_lojistiks_locations(id) NOT VALID;


--
-- Name: acorn_lojistiks_people last_product_instance_source_location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT last_product_instance_source_location_id FOREIGN KEY (last_product_instance_source_location_id) REFERENCES public.acorn_lojistiks_locations(id) NOT VALID;


--
-- Name: acorn_lojistiks_people last_transfer_destination_location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT last_transfer_destination_location_id FOREIGN KEY (last_transfer_destination_location_id) REFERENCES public.acorn_location_locations(id) NOT VALID;


--
-- Name: acorn_lojistiks_people last_transfer_source_location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT last_transfer_source_location_id FOREIGN KEY (last_transfer_source_location_id) REFERENCES public.acorn_location_locations(id) NOT VALID;


--
-- Name: acorn_lojistiks_offices location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_offices
    ADD CONSTRAINT location_id FOREIGN KEY (location_id) REFERENCES public.acorn_lojistiks_locations(id);


--
-- Name: acorn_lojistiks_warehouses location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_warehouses
    ADD CONSTRAINT location_id FOREIGN KEY (location_id) REFERENCES public.acorn_lojistiks_locations(id);


--
-- Name: acorn_lojistiks_suppliers location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_suppliers
    ADD CONSTRAINT location_id FOREIGN KEY (location_id) REFERENCES public.acorn_lojistiks_locations(id) NOT VALID;


--
-- Name: acorn_lojistiks_employees location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT location_id FOREIGN KEY (location_id) REFERENCES public.acorn_lojistiks_locations(id);


--
-- Name: acorn_lojistiks_locations locations_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT locations_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products measurement_unit_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT measurement_unit_id FOREIGN KEY (measurement_unit_id) REFERENCES public.acorn_lojistiks_measurement_units(id);


--
-- Name: acorn_lojistiks_measurement_units measurement_units_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_measurement_units
    ADD CONSTRAINT measurement_units_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_offices offices_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_offices
    ADD CONSTRAINT offices_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_areas parent_area_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT parent_area_id FOREIGN KEY (parent_area_id) REFERENCES public.acorn_lojistiks_areas(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_categories parent_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT parent_product_category_id FOREIGN KEY (parent_product_category_id) REFERENCES public.acorn_lojistiks_product_categories(id) NOT VALID;


--
-- Name: acorn_lojistiks_people people_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT people_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_drivers person_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_drivers
    ADD CONSTRAINT person_id FOREIGN KEY (person_id) REFERENCES public.acorn_lojistiks_people(id);


--
-- Name: acorn_lojistiks_employees person_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT person_id FOREIGN KEY (person_id) REFERENCES public.acorn_lojistiks_people(id);


--
-- Name: acorn_lojistiks_product_attributes product_attributes_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_attributes
    ADD CONSTRAINT product_attributes_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_categories product_categories_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT product_categories_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products_product_categories product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories
    ADD CONSTRAINT product_category_id FOREIGN KEY (product_category_id) REFERENCES public.acorn_lojistiks_product_categories(id);


--
-- Name: acorn_lojistiks_product_categories product_category_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT product_category_type_id FOREIGN KEY (product_category_type_id) REFERENCES public.acorn_lojistiks_product_category_types(id);


--
-- Name: acorn_lojistiks_product_category_types product_category_types_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_category_types
    ADD CONSTRAINT product_category_types_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products_product_categories product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_product_instances product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_product_products product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_products
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_product_attributes product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_attributes
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_product_instance_transfer product_instance_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT product_instance_id FOREIGN KEY (product_instance_id) REFERENCES public.acorn_lojistiks_product_instances(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_container_product_instance product_instance_transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instance
    ADD CONSTRAINT product_instance_transfer_id FOREIGN KEY (product_instance_transfer_id) REFERENCES public.acorn_lojistiks_product_instance_transfer(id) NOT VALID;


--
-- Name: CONSTRAINT product_instance_transfer_id ON acorn_lojistiks_transfer_container_product_instance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT product_instance_transfer_id ON public.acorn_lojistiks_transfer_container_product_instance IS 'todo: true';


--
-- Name: acorn_lojistiks_product_instances product_instances_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances
    ADD CONSTRAINT product_instances_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_products product_products_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_products
    ADD CONSTRAINT product_products_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products products_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT products_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products_product_categories products_product_categories_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories
    ADD CONSTRAINT products_product_categories_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_purchase purchase_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_purchase
    ADD CONSTRAINT purchase_id FOREIGN KEY (purchase_id) REFERENCES public.acorn_finance_purchases(id) NOT VALID;


--
-- Name: acorn_lojistiks_area_types server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_area_types
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_gps server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_gps
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_areas server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_addresses server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_measurement_units server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_measurement_units
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_products server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_product_instance_transfer server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_people server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_vehicle_types server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicle_types
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_containers server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_containers
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_vehicles server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_drivers server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_drivers
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_transfer_containers server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_containers
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_transfer_container_product_instance server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instance
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_product_category_types server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_category_types
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_product_categories server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_products_product_categories server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_locations server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_transfers server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id);


--
-- Name: acorn_lojistiks_brands server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_brands
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_employees server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_offices server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_offices
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_attributes server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_attributes
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_instances server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_warehouses server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_warehouses
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_suppliers server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_suppliers
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_products server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_products
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfers source_location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT source_location_id FOREIGN KEY (source_location_id) REFERENCES public.acorn_lojistiks_locations(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_products sub_product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_products
    ADD CONSTRAINT sub_product_id FOREIGN KEY (sub_product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_suppliers suppliers_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_suppliers
    ADD CONSTRAINT suppliers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_containers transfer_container_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_containers
    ADD CONSTRAINT transfer_container_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_container_product_instance transfer_container_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instance
    ADD CONSTRAINT transfer_container_id FOREIGN KEY (transfer_container_id) REFERENCES public.acorn_lojistiks_transfer_containers(id);


--
-- Name: CONSTRAINT transfer_container_id ON acorn_lojistiks_transfer_container_product_instance; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON CONSTRAINT transfer_container_id ON public.acorn_lojistiks_transfer_container_product_instance IS 'type: Xto1';


--
-- Name: acorn_lojistiks_transfer_container_product_instance transfer_container_product_instances_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instance
    ADD CONSTRAINT transfer_container_product_instances_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_instance_transfer transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT transfer_id FOREIGN KEY (transfer_id) REFERENCES public.acorn_lojistiks_transfers(id);


--
-- Name: acorn_lojistiks_transfer_containers transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_containers
    ADD CONSTRAINT transfer_id FOREIGN KEY (transfer_id) REFERENCES public.acorn_lojistiks_transfers(id);


--
-- Name: acorn_lojistiks_transfer_invoice transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_invoice
    ADD CONSTRAINT transfer_id FOREIGN KEY (transfer_id) REFERENCES public.acorn_lojistiks_transfers(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_purchase transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_purchase
    ADD CONSTRAINT transfer_id FOREIGN KEY (transfer_id) REFERENCES public.acorn_lojistiks_transfers(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_instance_transfer transfer_product_instances_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT transfer_product_instances_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfers transfers_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT transfers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_locations user_group_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT user_group_id FOREIGN KEY (user_group_id) REFERENCES public.acorn_user_user_groups(id) NOT VALID;


--
-- Name: acorn_lojistiks_people user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_employees user_role_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT user_role_id FOREIGN KEY (user_role_id) REFERENCES public.acorn_user_roles(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfers vehicle_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT vehicle_id FOREIGN KEY (vehicle_id) REFERENCES public.acorn_lojistiks_vehicles(id) NOT VALID;


--
-- Name: acorn_lojistiks_drivers vehicle_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_drivers
    ADD CONSTRAINT vehicle_id FOREIGN KEY (vehicle_id) REFERENCES public.acorn_lojistiks_vehicles(id) NOT VALID;


--
-- Name: acorn_lojistiks_vehicles vehicle_type_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles
    ADD CONSTRAINT vehicle_type_id FOREIGN KEY (vehicle_type_id) REFERENCES public.acorn_lojistiks_vehicle_types(id);


--
-- Name: acorn_lojistiks_vehicle_types vehicle_types_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicle_types
    ADD CONSTRAINT vehicle_types_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_vehicles vehicles_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles
    ADD CONSTRAINT vehicles_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_warehouses warehouses_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_warehouses
    ADD CONSTRAINT warehouses_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.acorn_user_users(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

SET search_path TO public;
