-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_addresses_created_at()
--
-- PostgreSQL database dump
--

-- Create a function that always returns the first non-NULL value:
CREATE OR REPLACE FUNCTION public.fn_acorn_lojistiks_first_agg (anyelement, anyelement)
  RETURNS anyelement
  LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE AS
'SELECT $1';

-- Then wrap an aggregate around it:
CREATE OR REPLACE AGGREGATE public.agg_acorn_lojistiks_first (anyelement) (
  SFUNC    = public.fn_acorn_lojistiks_first_agg
, STYPE    = anyelement
, PARALLEL = safe
);

-- Create a function that always returns the last non-NULL value:
CREATE OR REPLACE FUNCTION public.fn_acorn_lojistiks_last_agg (anyelement, anyelement)
  RETURNS anyelement
  LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE AS
'SELECT $2';

-- Then wrap an aggregate around it:
CREATE OR REPLACE AGGREGATE public.agg_acorn_lojistiks_last (anyelement) (
  SFUNC    = public.fn_acorn_lojistiks_last_agg
, STYPE    = anyelement
, PARALLEL = safe
);

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_addresses_created_at();
--
-- Name: fn_acorn_lojistiks_addresses_created_at(); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_addresses_created_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	event_id integer;
	description text;
begin
	-- We do not trigger on replicated rows
	-- that already have a value set
	if new.created_at is null then
		-- Use the Calendar system
		description := concat(new.name, ' Address created');
		insert into public.acorn_calendar_event(calendar_id, owner_user_id, owner_user_group_id) 
			values(1,1,1);
		event_id = currval('acorn_calendar_event_id_seq'::regclass);
		insert into public.acorn_calendar_event_part(event_id, "name", description, "start", "end", type_id) 
			values(event_id, description, description, now(), now(), 1);
		new.created_at = event_id;
	end if;
	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_addresses_version()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_addresses_version();
--
-- Name: fn_acorn_lojistiks_addresses_version(); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_addresses_version() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
	-- For adding versioning columns to the table
	-- alter table IF EXISTS public.acorn_lojistiks_addresses add column "version" bigint default 1 not null;
	-- alter table IF EXISTS public.acorn_lojistiks_addresses add column is_current_version bool default true not null;
	-- alter table IF EXISTS public.acorn_lojistiks_addresses ADD COLUMN created_at timestamp with time zone default now();
	-- Change the primary key to include version
	-- ALTER TABLE IF EXISTS public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS addresses_pkey;
	-- ALTER TABLE IF EXISTS public.acorn_lojistiks_addresses ADD PRIMARY KEY (id, version);

	-- TODO: Translation
	if old.id != new.id then raise exception 'Cannot change id directly'; end if;
	if old.version != new.version then raise exception 'Cannot change version directly'; end if;
	if old.is_current_version != new.is_current_version then raise exception 'Cannot change is_current_version directly'; end if;
	if not old.is_current_version then raise exception 'Can only change the current version'; end if;

	if old.number is null and not new.number is null then
		-- We do not make new versions for completion of null fields
	else
		-- Insert the new record instead
		-- TODO: Can we insert the row object directly here?
		insert into public.acorn_calendar_event(calendar_id, owner_user_id, owner_user_group_id)
			values(1,1,1); -- We make a NEW event for each created_at
		new.version := new.version + 1;
		new.created_at = currval('acorn_calendar_event_id_seq'::regclass);
		insert into public.acorn_lojistiks_addresses
			("id", "name", "number", "area_id", "gps_id", "version", is_current_version, created_at)
			values(new.id, new.name, new.number, new.area_id, new.gps_id, new.version, new.is_current_version, new.created_at);

		-- Switch, so we keep the old record
		new := old;
		new.is_current_version := false;
	end if;

	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_created_at()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_created_at();
--
-- Name: fn_acorn_lojistiks_created_at(); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_created_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	event_id uuid;
begin
	-- We do not trigger on replicated rows
	-- that already have a value already set
	if new.created_at is null then
		insert into public.acorn_calendar_event(calendar_id, owner_user_id, owner_user_group_id) 
			values(1,1,1);
		event_id = currval('acorn_calendar_event_id_seq'::regclass);
		insert into public.acorn_calendar_event_part(event_id, "name", description, "start", "end", type_id) 
			values(event_id, 'Address created', now(), now(), 1);
		new.created_at = event_id;
	end if;

	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_distance(integer, integer)
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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
-- Name: fn_acorn_lojistiks_distance(integer, integer); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_distance(source_location_id uuid, destination_location_id uuid) RETURNS double precision
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

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

create or replace function public.fn_acorn_lojistiks_is_date(s character varying, d timestamp with time zone) RETURNS timestamp with time zone
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

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_new_replicated_row()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_new_replicated_row();
--
-- Name: fn_acorn_lojistiks_new_replicated_row(); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_new_replicated_row() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	domain varchar(1024);
	plugin_path varchar(1024);
	action varchar(2048);
	params varchar(2048);
	url varchar(2048);
	res public.http_response;
begin
	-- https://www.postgresql.org/docs/current/plpgsql-trigger.html
	domain = 'acorn-lojistiks.laptop';
	plugin_path = '/api';
	action = '/newrow';
	params = concat('TG_NAME=', TG_NAME, '&TG_OP=', TG_OP, '&TG_TABLE_SCHEMA=', TG_TABLE_SCHEMA, '&TG_TABLE_NAME=', TG_TABLE_NAME, '&ID=', new.id);
	url = concat('http://', domain, plugin_path, action, '?', params);

	res = public.http_get(url);
	new.response = concat(res.status, ' ', res.content);

	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--


-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_replication_update_seq()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_replication_update_seq();
--
-- Name: fn_acorn_lojistiks_replication_update_seq(); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_replication_update_seq() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	seq_name varchar(1024);
begin
	-- Get the associated sequence name
	SELECT into seq_name concat(PGT.schemaname, '.', S.relname)
		FROM pg_class AS S
			inner join pg_depend AS D on S.oid = D.objid
			inner join pg_class AS T on D.refobjid = T.oid
			inner join pg_attribute AS C on D.refobjid = C.attrelid and D.refobjsubid = C.attnum
			inner join pg_tables AS PGT on T.relname = PGT.tablename
		WHERE S.relkind = 'S'
			AND T.relname = TG_TABLE_NAME
			AND PGT.schemaname = TG_TABLE_SCHEMA;
	if new.id > pg_sequence_last_value(seq_name) then
		perform setval(seq_name, new.id);
	end if;
	
	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_reset_sequences(character varying)
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_reset_sequences(_schema character varying);
--
-- Name: fn_acorn_lojistiks_reset_sequences(character varying); Type: FUNCTION; Schema: public; Owner: -
--

-- drop function fn_acorn_lojistiks_reset_sequences(_schema varchar(1024));

CREATE OR REPLACE FUNCTION public.fn_acorn_lojistiks_reset_sequences(schema_like varchar(1024), table_like varchar(1024))
  RETURNS void
  LANGUAGE plpgsql AS
$BODY$
declare
	reset_query varchar(32596);
BEGIN
  	reset_query = (SELECT string_agg(
		  		concat('SELECT SETVAL(''',
				PGT.schemaname, '.', S.relname,
				''', COALESCE(MAX(', C.attname, '), 1) ) FROM ',
				PGT.schemaname, '.', T.relname, ';'),
			'')
		FROM pg_class AS S,
			pg_depend AS D,
			pg_class AS T,
			pg_attribute AS C,
			pg_tables AS PGT
		WHERE S.relkind = 'S'
			AND S.oid = D.objid
			AND D.refobjid = T.oid
			AND D.refobjid = C.attrelid
			AND D.refobjsubid = C.attnum
			AND T.relname = PGT.tablename
			AND PGT.schemaname like(schema_like)
			AND T.relname like(table_like)
	);
	if not reset_query is null then
		execute reset_query;
	end if;
END
$BODY$;

--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_server_id()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_server_id();
--
-- Name: fn_acorn_lojistiks_server_id(); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_server_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	declare pid uuid;
begin
	if new.server_id is null then
		select "id" into pid from acorn_lojistiks_servers where hostname = hostname();
		if pid is null then
			insert into acorn_lojistiks_servers(hostname) values(hostname()) returning id into pid;
		end if;
		new.server_id = pid;
	end if;
	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_table_counts(character varying)
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_table_counts(_schema character varying);
--
-- Name: fn_acorn_lojistiks_table_counts(character varying); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_table_counts(_schema character varying) RETURNS TABLE("table" text, count bigint)
    LANGUAGE plpgsql
    AS $$
BEGIN
	-- SELECT * FROM information_schema.tables;
  	return query execute (select concat(
		'select "table", "count" from (', 
		(
			SELECT string_agg(
				concat('select ''', table_name, ''' as "table", count(*) as "count" from ', table_name),
				' union all '
			) 
			FROM information_schema.tables 
			where table_catalog = current_database()
			and table_schema = _schema
		), 
		') data order by "count" desc, "table" asc'
	));
END
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_transfers_created_at()
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_transfers_created_at();
--
-- Name: fn_acorn_lojistiks_transfers_created_at(); Type: FUNCTION; Schema: public; Owner: -
--

create or replace function public.fn_acorn_lojistiks_transfers_created_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare
	event_id integer;
	description text;
	external_url varchar(2048);
begin
	-- We do not trigger on replicated rows
	-- that already have a value set
	if new.created_at is null then
		-- Use the Calendar system
		description  := 'Transfer created';
		external_url := concat('/backend/acorn/lojistiks/transfer/update/', new.id);
		insert into public.acorn_calendar_event(calendar_id, owner_user_id, owner_user_group_id, external_url) 
			values(1,1,1, external_url);
		event_id = currval('acorn_calendar_event_id_seq'::regclass);
		insert into public.acorn_calendar_event_part(event_id, "name", description, "start", "end", type_id) 
			values(event_id, description, description, now(), now(), 2);
		new.created_at = event_id;
	end if;
	
	return new;
end;
$$;


--
-- PostgreSQL database dump complete
--

-- MANUAL FUNCTION DUMP fn_acorn_lojistiks_truncate_database(character varying)
--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_truncate_database(_schema character varying);
--
-- Name: fn_acorn_lojistiks_truncate_database(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE OR REPLACE FUNCTION public.fn_acorn_lojistiks_truncate_database(schema_like varchar(1024), table_like varchar(1024))
  RETURNS void
  LANGUAGE plpgsql AS
$BODY$
declare
	reset_query varchar(32596);
BEGIN
	reset_query = (SELECT 'TRUNCATE TABLE '
	       || string_agg(format('%I.%I', schemaname, tablename), ', ')
	       || ' CASCADE'
	   	FROM   pg_tables
	   	WHERE  schemaname like(schema_like)
		   AND tablename like(table_like)
   	);
	if not reset_query is null then
		execute reset_query;
	end if;
END
$BODY$;



--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_people DROP CONSTRAINT IF EXISTS user_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS transfers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instance_transfer DROP CONSTRAINT IF EXISTS transfer_product_instances_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instances DROP CONSTRAINT IF EXISTS transfer_product_instance_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container DROP CONSTRAINT IF EXISTS transfer_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instance_transfer DROP CONSTRAINT IF EXISTS transfer_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instances DROP CONSTRAINT IF EXISTS transfer_container_product_instances_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instances DROP CONSTRAINT IF EXISTS transfer_container_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container DROP CONSTRAINT IF EXISTS transfer_container_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_suppliers DROP CONSTRAINT IF EXISTS suppliers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_products DROP CONSTRAINT IF EXISTS sub_product_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS source_location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_servers DROP CONSTRAINT IF EXISTS servers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_locations DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products_product_categories DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_categories DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_category_types DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instances DROP CONSTRAINT IF EXISTS server_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container DROP CONSTRAINT IF EXISTS server_id;
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
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products_product_categories DROP CONSTRAINT IF EXISTS products_product_categories_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products DROP CONSTRAINT IF EXISTS products_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_products DROP CONSTRAINT IF EXISTS product_products_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instances DROP CONSTRAINT IF EXISTS product_instances_created_by_user;
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
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instances DROP CONSTRAINT IF EXISTS initial_transfer_product_instance_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS gps_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS gps_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_gps DROP CONSTRAINT IF EXISTS gps_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS employees_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_drivers DROP CONSTRAINT IF EXISTS drivers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS driver_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS destination_location_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS created_at;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS created_at;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_containers DROP CONSTRAINT IF EXISTS containers_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container DROP CONSTRAINT IF EXISTS container_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_brands DROP CONSTRAINT IF EXISTS brands_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_products DROP CONSTRAINT IF EXISTS brand_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS backend_user_role_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS areas_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_area_types DROP CONSTRAINT IF EXISTS area_types_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_areas DROP CONSTRAINT IF EXISTS area_type_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS area_id;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_addresses DROP CONSTRAINT IF EXISTS addresses_created_by_user;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_locations DROP CONSTRAINT IF EXISTS address_id;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_electronic_products DROP CONSTRAINT IF EXISTS product_id;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_electronic_products DROP CONSTRAINT IF EXISTS electronic_products_created_by_user;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_computer_products DROP CONSTRAINT IF EXISTS electronic_product_id;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_computer_products DROP CONSTRAINT IF EXISTS computer_products_created_by_user;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_warehouses_server_id ON public.acorn_lojistiks_warehouses;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_vehicles_server_id ON public.acorn_lojistiks_vehicles;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_vehicle_types_server_id ON public.acorn_lojistiks_vehicle_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfers_server_id ON public.acorn_lojistiks_transfers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfers_created_at ON public.acorn_lojistiks_transfers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfer_product_instances_server_id ON public.acorn_lojistiks_product_instance_transfer;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfer_container_server_id ON public.acorn_lojistiks_transfer_container;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_transfer_container_product_instanc ON public.acorn_lojistiks_transfer_container_product_instances;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_suppliers_server_id ON public.acorn_lojistiks_suppliers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_replication_update_brands_seq ON public.acorn_lojistiks_brands;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_products_server_id ON public.acorn_lojistiks_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_products_product_categories_server ON public.acorn_lojistiks_products_product_categories;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_products_server_id ON public.acorn_lojistiks_product_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_instances_server_id ON public.acorn_lojistiks_product_instances;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_category_types_server_id ON public.acorn_lojistiks_product_category_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_categories_server_id ON public.acorn_lojistiks_product_categories;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_product_attributes_server_id ON public.acorn_lojistiks_product_attributes;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_people_server_id ON public.acorn_lojistiks_people;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_offices_server_id ON public.acorn_lojistiks_offices;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_measurement_units_server_id ON public.acorn_lojistiks_measurement_units;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_locations_server_id ON public.acorn_lojistiks_locations;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_gps_server_id ON public.acorn_lojistiks_gps;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_employees_server_id ON public.acorn_lojistiks_employees;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_drivers_server_id ON public.acorn_lojistiks_drivers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_containers_server_id ON public.acorn_lojistiks_containers;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_brands_server_id ON public.acorn_lojistiks_brands;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_brands_new_replicated_row ON public.acorn_lojistiks_brands;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_areas_server_id ON public.acorn_lojistiks_areas;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_area_types_server_id ON public.acorn_lojistiks_area_types;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_addresses_version ON public.acorn_lojistiks_addresses;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_addresses_server_id ON public.acorn_lojistiks_addresses;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_addresses_created_at ON public.acorn_lojistiks_addresses;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_electronic_products_server_id ON product.acorn_lojistiks_electronic_products;
DROP TRIGGER IF EXISTS tr_acorn_lojistiks_computer_products_server_id ON product.acorn_lojistiks_computer_products;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicles DROP CONSTRAINT IF EXISTS vehicles_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_vehicle_types DROP CONSTRAINT IF EXISTS vehicle_types_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfers DROP CONSTRAINT IF EXISTS transfers_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_product_instance_transfer DROP CONSTRAINT IF EXISTS transfer_product_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container_product_instances DROP CONSTRAINT IF EXISTS transfer_container_products_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_transfer_container DROP CONSTRAINT IF EXISTS transfer_container_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_suppliers DROP CONSTRAINT IF EXISTS suppliers_pkey;
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_servers DROP CONSTRAINT IF EXISTS servers_pkey;
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
ALTER TABLE IF EXISTS ONLY public.acorn_lojistiks_employees DROP CONSTRAINT IF EXISTS acorn_lojistiks_location_people_pkey;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_electronic_products DROP CONSTRAINT IF EXISTS office_products_pkey;
ALTER TABLE IF EXISTS ONLY product.acorn_lojistiks_computer_products DROP CONSTRAINT IF EXISTS computer_products_pkey;
ALTER TABLE IF EXISTS public.acorn_lojistiks_warehouses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_vehicles ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_vehicle_types ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_transfers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_transfer_container_product_instances ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_transfer_container ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_suppliers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_products_product_categories ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_products ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_product_instances ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_product_instance_transfer ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_product_category_types ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_product_categories ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_product_attributes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_people ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_offices ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_measurement_units ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_locations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_gps ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_drivers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_containers ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_brands ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_areas ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_area_types ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.acorn_lojistiks_addresses ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS product.acorn_lojistiks_electronic_products ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS product.acorn_lojistiks_computer_products ALTER COLUMN id DROP DEFAULT;

DROP VIEW IF EXISTS public.acorn_lojistiks_stock_products;
DROP VIEW IF EXISTS public.acorn_lojistiks_stocks;
DROP VIEW IF EXISTS public.acorn_lojistiks_movements;
DROP VIEW IF EXISTS public.acorn_lojistiks_vehicle_lasts;

DROP TABLE IF EXISTS public.acorn_lojistiks_warehouses;

DROP TABLE IF EXISTS public.acorn_lojistiks_vehicles;

DROP TABLE IF EXISTS public.acorn_lojistiks_vehicle_types;



DROP TABLE IF EXISTS public.acorn_lojistiks_transfer_container_product_instances;

DROP TABLE IF EXISTS public.acorn_lojistiks_transfer_container;

DROP TABLE IF EXISTS public.acorn_lojistiks_suppliers;
DROP TABLE IF EXISTS public.acorn_lojistiks_servers;


DROP TABLE IF EXISTS public.acorn_lojistiks_products_product_categories;

DROP TABLE IF EXISTS public.acorn_lojistiks_products;
DROP TABLE IF EXISTS public.acorn_lojistiks_product_products;


DROP TABLE IF EXISTS public.acorn_lojistiks_product_category_types;

DROP TABLE IF EXISTS public.acorn_lojistiks_product_categories;

DROP TABLE IF EXISTS public.acorn_lojistiks_product_attributes;

DROP TABLE IF EXISTS public.acorn_lojistiks_people;

DROP TABLE IF EXISTS public.acorn_lojistiks_offices;
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
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer,
    processor_type integer
);


--
-- Name: acorn_lojistiks_computer_product_id_seq; Type: SEQUENCE; Schema: product; Owner: -
--









--
-- Name: acorn_lojistiks_computer_product_id_seq; Type: SEQUENCE OWNED BY; Schema: product; Owner: -
--




--
-- Name: acorn_lojistiks_electronic_products; Type: TABLE; Schema: product; Owner: -
--

CREATE TABLE product.acorn_lojistiks_electronic_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    voltage double precision,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_electronic_products_id_seq; Type: SEQUENCE; Schema: product; Owner: -
--









--
-- Name: acorn_lojistiks_electronic_products_id_seq; Type: SEQUENCE OWNED BY; Schema: product; Owner: -
--




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
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_by_user_id integer,
    created_at integer
);


--
-- Name: acorn_lojistiks_addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_area_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_area_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_area_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_area_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




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
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_brands (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(2048) NOT NULL,
    image character varying(2048),
    response text,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_brands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_containers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name character varying(1024),
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_containers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_containers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_drivers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_drivers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    person_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    vehicle_id uuid,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_drivers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_drivers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_employees_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_employees (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    person_id uuid NOT NULL,
    user_role_id integer NOT NULL,

    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_gps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_gps (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    longitude double precision,
    latitude  double precision,

    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_gps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_gps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_locations (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    address_id uuid NOT NULL,
    name character varying(2048) NOT NULL,
    image character varying(2048),

    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_location_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_measurement_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_measurement_units (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    short_name character varying(1024),
    uses_quantity boolean DEFAULT true NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_measurement_units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_measurement_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_instance_transfer; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_instance_transfer (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transfer_id uuid NOT NULL,
    product_instance_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_product_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_instances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    quantity integer DEFAULT 1 NOT NULL,
    external_identifier character varying(2048),
    initial_transfer_product_instance_id uuid,
    asset_class "char" DEFAULT 'C'::"char" NOT NULL,
    image character varying(2048),
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


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
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    vehicle_id uuid,
    created_by_user_id integer,
    created_at integer NOT NULL
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
     JOIN public.acorn_lojistiks_product_instances pi ON ((pi.id = trp.product_instance_id)));


--
-- Name: acorn_lojistiks_offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_offices (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_office_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_office_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_people (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id integer, -- backend_users
    image character varying(2048),
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_people_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_people_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_attributes (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    name character varying(1024) NOT NULL,
    value character varying(1024) NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_product_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_product_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_categories (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    product_category_type_id uuid NOT NULL,
    parent_product_category_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_category_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_category_types (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(1024) NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_product_category_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_product_category_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_instances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_product_instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_products (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    product_id uuid NOT NULL,
    sub_product_id uuid NOT NULL,
    quantity integer NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
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
    model character varying(2048),
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: TABLE acorn_lojistiks_products; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.acorn_lojistiks_products IS 'versioning: normal
default ordering: name';


--
-- Name: COLUMN acorn_lojistiks_products.measurement_unit_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.acorn_lojistiks_products.measurement_unit_id IS 'field: select_with_create_link';


--
-- Name: COLUMN acorn_lojistiks_products.brand_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.acorn_lojistiks_products.brand_id IS 'field: create_or_select';


--
-- Name: acorn_lojistiks_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_products_product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_products_product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_servers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_servers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_servers (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    hostname character varying(1024) DEFAULT public.hostname() NOT NULL,
    created_by_user_id integer
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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_transfer_container; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_container (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transfer_id uuid NOT NULL,
    container_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_transfer_container_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_transfer_container_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_transfer_container_product_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_container_product_instances (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    transfer_container_id uuid NOT NULL,
    transfer_product_instance_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_transfer_container_product_instances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_transfer_container_product_instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_transfer_product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_transfer_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_vehicle_lasts; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.acorn_lojistiks_vehicle_lasts AS
 SELECT tr.vehicle_id AS id,
    tr.vehicle_id,
    lasts.transfer_id,
        CASE
            WHEN (tr.arrived_at IS NULL) THEN NULL
            ELSE tr.destination_location_id
        END AS location_id
   FROM ((SELECT acorn_lojistiks_transfers.vehicle_id,
            public.agg_acorn_lojistiks_last(acorn_lojistiks_transfers.id) AS transfer_id,
            public.agg_acorn_lojistiks_last(acorn_lojistiks_transfers.created_at) AS created_at,
            count(*) AS count
           FROM public.acorn_lojistiks_transfers
          WHERE (NOT (acorn_lojistiks_transfers.vehicle_id IS NULL))
          GROUP BY acorn_lojistiks_transfers.vehicle_id
		  ORDER BY created_at DESC
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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_vehicle_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_vehicle_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




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
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_warehouses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_warehouses (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    location_id uuid NOT NULL,
    server_id uuid NOT NULL,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by_user_id integer
);


--
-- Name: acorn_lojistiks_warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--









--
-- Name: acorn_lojistiks_warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_computer_products id; Type: DEFAULT; Schema: product; Owner: -
--




--
-- Name: acorn_lojistiks_electronic_products id; Type: DEFAULT; Schema: product; Owner: -
--




--
-- Name: acorn_lojistiks_addresses id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_area_types id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_areas id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_brands id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_containers id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_drivers id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_gps id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_locations id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_measurement_units id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_offices id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_people id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_attributes id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_categories id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_category_types id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_instance_transfer id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_product_instances id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_products id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_products_product_categories id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_suppliers id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_transfer_container id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_transfer_container_product_instances id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_transfers id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_vehicle_types id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_vehicles id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_warehouses id; Type: DEFAULT; Schema: public; Owner: -
--




--
-- Name: acorn_lojistiks_computer_products computer_products_pkey; Type: CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_computer_products
    ADD CONSTRAINT computer_products_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_computer_products_replica_identity on product.acorn_lojistiks_computer_products(server_id, id); ALTER TABLE ONLY product.acorn_lojistiks_computer_products REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_computer_products_replica_identity;


--
-- Name: acorn_lojistiks_electronic_products office_products_pkey; Type: CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_electronic_products
    ADD CONSTRAINT office_products_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_electronic_products_replica_identity on product.acorn_lojistiks_electronic_products(server_id, id); ALTER TABLE ONLY product.acorn_lojistiks_electronic_products REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_electronic_products_replica_identity;


--
-- Name: acorn_lojistiks_employees acorn_lojistiks_location_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT acorn_lojistiks_employees_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_employees_replica_identity on public.acorn_lojistiks_employees(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_employees REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_employees_replica_identity;


--
-- Name: acorn_lojistiks_product_products acorn_lojistiks_product_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_products
    ADD CONSTRAINT acorn_lojistiks_product_products_pkey PRIMARY KEY (product_id, sub_product_id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_product_products_replica_identity on public.acorn_lojistiks_product_products(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_product_products REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_products_replica_identity;


--
-- Name: acorn_lojistiks_warehouses acorn_lojistiks_warehouses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_warehouses
    ADD CONSTRAINT acorn_lojistiks_warehouses_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_warehouses_replica_identity on public.acorn_lojistiks_warehouses(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_warehouses REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_warehouses_replica_identity;


--
-- Name: acorn_lojistiks_addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_addresses_replica_identity on public.acorn_lojistiks_addresses(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_addresses REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_addresses_replica_identity;


--
-- Name: acorn_lojistiks_area_types area_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_area_types
    ADD CONSTRAINT area_types_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_area_types_replica_identity on public.acorn_lojistiks_area_types(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_area_types REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_area_types_replica_identity;


--
-- Name: acorn_lojistiks_areas areas_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT areas_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_areas_replica_identity on public.acorn_lojistiks_areas(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_areas REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_areas_replica_identity;


--
-- Name: acorn_lojistiks_brands brands_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_brands
    ADD CONSTRAINT brands_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_brands_replica_identity on public.acorn_lojistiks_brands(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_brands REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_brands_replica_identity;


--
-- Name: acorn_lojistiks_containers containers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_containers
    ADD CONSTRAINT containers_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_containers_replica_identity on public.acorn_lojistiks_containers(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_containers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_containers_replica_identity;


--
-- Name: acorn_lojistiks_drivers drivers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_drivers
    ADD CONSTRAINT drivers_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_drivers_replica_identity on public.acorn_lojistiks_drivers(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_drivers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_drivers_replica_identity;


--
-- Name: acorn_lojistiks_gps gps_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_gps
    ADD CONSTRAINT gps_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_gps_replica_identity on public.acorn_lojistiks_gps(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_gps REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_gps_replica_identity;


--
-- Name: acorn_lojistiks_locations location_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT location_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_location_replica_identity on public.acorn_lojistiks_locations(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_locations REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_location_replica_identity;


--
-- Name: acorn_lojistiks_measurement_units measurement_units_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_measurement_units
    ADD CONSTRAINT measurement_units_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_measurement_units_replica_identity on public.acorn_lojistiks_measurement_units(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_measurement_units REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_measurement_units_replica_identity;


--
-- Name: acorn_lojistiks_offices office_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_offices
    ADD CONSTRAINT office_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_office_replica_identity on public.acorn_lojistiks_offices(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_offices REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_office_replica_identity;


--
-- Name: acorn_lojistiks_people person_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT person_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_people_replica_identity on public.acorn_lojistiks_people(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_people REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_people_replica_identity;


--
-- Name: acorn_lojistiks_product_attributes product_attributes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_attributes
    ADD CONSTRAINT product_attributes_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_product_attributes_replica_identity on public.acorn_lojistiks_product_attributes(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_product_attributes REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_attributes_replica_identity;


--
-- Name: acorn_lojistiks_product_categories product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT product_categories_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_product_categories_replica_identity on public.acorn_lojistiks_product_categories(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_product_categories REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_categories_replica_identity;


--
-- Name: acorn_lojistiks_product_category_types product_category_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_category_types
    ADD CONSTRAINT product_category_types_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_product_category_types_replica_identity on public.acorn_lojistiks_product_category_types(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_product_category_types REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_category_types_replica_identity;


--
-- Name: acorn_lojistiks_product_instances product_instances_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances
    ADD CONSTRAINT product_instances_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_product_instances_replica_identity on public.acorn_lojistiks_product_instances(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_product_instances REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_instances_replica_identity;


--
-- Name: acorn_lojistiks_products products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_products_replica_identity on public.acorn_lojistiks_products(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_products REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_products_replica_identity;


--
-- Name: acorn_lojistiks_products_product_categories products_product_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories
    ADD CONSTRAINT products_product_categories_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_products_product_categories_replica_identity on public.acorn_lojistiks_products_product_categories(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_products_product_categories_replica_identity;


--
-- Name: acorn_lojistiks_servers servers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_servers
    ADD CONSTRAINT servers_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_servers_replica_identity on public.acorn_lojistiks_servers(id); ALTER TABLE ONLY public.acorn_lojistiks_servers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_servers_replica_identity;


--
-- Name: acorn_lojistiks_suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_suppliers_replica_identity on public.acorn_lojistiks_suppliers(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_suppliers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_suppliers_replica_identity;


--
-- Name: acorn_lojistiks_transfer_container transfer_container_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container
    ADD CONSTRAINT transfer_container_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_transfer_container_replica_identity on public.acorn_lojistiks_transfer_container(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_transfer_container REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_transfer_container_replica_identity;


--
-- Name: acorn_lojistiks_transfer_container_product_instances transfer_container_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances
    ADD CONSTRAINT transfer_container_products_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_transfer_container_product_instances_replica_identity on public.acorn_lojistiks_transfer_container_product_instances(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_transfer_container_product_instances_replica_identity;


--
-- Name: acorn_lojistiks_product_instance_transfer transfer_product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT transfer_product_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_product_instance_transfer_replica_identity on public.acorn_lojistiks_product_instance_transfer(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_product_instance_transfer_replica_identity;


--
-- Name: acorn_lojistiks_transfers transfers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT transfers_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_transfers_replica_identity on public.acorn_lojistiks_transfers(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_transfers REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_transfers_replica_identity;


--
-- Name: acorn_lojistiks_vehicle_types vehicle_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicle_types
    ADD CONSTRAINT vehicle_types_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_vehicle_types_replica_identity on public.acorn_lojistiks_vehicle_types(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_vehicle_types REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_vehicle_types_replica_identity;


--
-- Name: acorn_lojistiks_vehicles vehicles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles
    ADD CONSTRAINT vehicles_pkey PRIMARY KEY (id); CREATE UNIQUE INDEX IF NOT EXISTS dr_acorn_lojistiks_vehicles_replica_identity on public.acorn_lojistiks_vehicles(server_id, id); ALTER TABLE ONLY public.acorn_lojistiks_vehicles REPLICA IDENTITY USING INDEX dr_acorn_lojistiks_vehicles_replica_identity;


--
-- Name: fki_address_id; Type: INDEX; Schema: public; Owner: -
--
--
-- Name: acorn_lojistiks_computer_products tr_acorn_lojistiks_computer_products_server_id; Type: TRIGGER; Schema: product; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_computer_products_server_id BEFORE INSERT ON product.acorn_lojistiks_computer_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_electronic_products tr_acorn_lojistiks_electronic_products_server_id; Type: TRIGGER; Schema: product; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_electronic_products_server_id BEFORE INSERT ON product.acorn_lojistiks_electronic_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_addresses tr_acorn_lojistiks_addresses_created_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_addresses_created_at BEFORE INSERT ON public.acorn_lojistiks_addresses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_addresses_created_at();


--
-- Name: acorn_lojistiks_addresses tr_acorn_lojistiks_addresses_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_addresses_server_id BEFORE INSERT ON public.acorn_lojistiks_addresses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_addresses tr_acorn_lojistiks_addresses_version; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_addresses_version BEFORE UPDATE ON public.acorn_lojistiks_addresses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_addresses_version();

ALTER TABLE public.acorn_lojistiks_addresses DISABLE TRIGGER tr_acorn_lojistiks_addresses_version;


--
-- Name: acorn_lojistiks_area_types tr_acorn_lojistiks_area_types_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_area_types_server_id BEFORE INSERT ON public.acorn_lojistiks_area_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_areas tr_acorn_lojistiks_areas_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_areas_server_id BEFORE INSERT ON public.acorn_lojistiks_areas FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_brands tr_acorn_lojistiks_brands_new_replicated_row; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_brands_new_replicated_row BEFORE INSERT ON public.acorn_lojistiks_brands FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_new_replicated_row();

ALTER TABLE public.acorn_lojistiks_brands ENABLE ALWAYS TRIGGER tr_acorn_lojistiks_brands_new_replicated_row;


--
-- Name: acorn_lojistiks_brands tr_acorn_lojistiks_brands_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_brands_server_id BEFORE INSERT ON public.acorn_lojistiks_brands FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_containers tr_acorn_lojistiks_containers_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_containers_server_id BEFORE INSERT ON public.acorn_lojistiks_containers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_drivers tr_acorn_lojistiks_drivers_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_drivers_server_id BEFORE INSERT ON public.acorn_lojistiks_drivers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_employees tr_acorn_lojistiks_employees_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_employees_server_id BEFORE INSERT ON public.acorn_lojistiks_employees FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_gps tr_acorn_lojistiks_gps_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_gps_server_id BEFORE INSERT ON public.acorn_lojistiks_gps FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_locations tr_acorn_lojistiks_locations_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_locations_server_id BEFORE INSERT ON public.acorn_lojistiks_locations FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_measurement_units tr_acorn_lojistiks_measurement_units_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_measurement_units_server_id BEFORE INSERT ON public.acorn_lojistiks_measurement_units FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_offices tr_acorn_lojistiks_offices_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_offices_server_id BEFORE INSERT ON public.acorn_lojistiks_offices FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_people tr_acorn_lojistiks_people_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_people_server_id BEFORE INSERT ON public.acorn_lojistiks_people FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_product_attributes tr_acorn_lojistiks_product_attributes_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_attributes_server_id BEFORE INSERT ON public.acorn_lojistiks_product_attributes FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_product_categories tr_acorn_lojistiks_product_categories_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_categories_server_id BEFORE INSERT ON public.acorn_lojistiks_product_categories FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_product_category_types tr_acorn_lojistiks_product_category_types_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_category_types_server_id BEFORE INSERT ON public.acorn_lojistiks_product_category_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_product_instances tr_acorn_lojistiks_product_instances_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_instances_server_id BEFORE INSERT ON public.acorn_lojistiks_product_instances FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_product_products tr_acorn_lojistiks_product_products_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_products_server_id BEFORE INSERT ON public.acorn_lojistiks_product_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_products_product_categories tr_acorn_lojistiks_products_product_categories_server; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_products_product_categories_server BEFORE INSERT ON public.acorn_lojistiks_products_product_categories FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_products tr_acorn_lojistiks_products_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_products_server_id BEFORE INSERT ON public.acorn_lojistiks_products FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_brands tr_acorn_lojistiks_replication_update_brands_seq; Type: TRIGGER; Schema: public; Owner: -
--


--
-- Name: acorn_lojistiks_suppliers tr_acorn_lojistiks_suppliers_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_suppliers_server_id BEFORE INSERT ON public.acorn_lojistiks_suppliers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_transfer_container_product_instances tr_acorn_lojistiks_transfer_container_product_instanc; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfer_container_product_instanc BEFORE INSERT ON public.acorn_lojistiks_transfer_container_product_instances FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_transfer_container tr_acorn_lojistiks_transfer_container_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfer_container_server_id BEFORE INSERT ON public.acorn_lojistiks_transfer_container FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_product_instance_transfer tr_acorn_lojistiks_transfer_product_instances_server_; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_product_instance_transfer_server_id BEFORE INSERT ON public.acorn_lojistiks_product_instance_transfer FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_transfers tr_acorn_lojistiks_transfers_created_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfers_created_at BEFORE INSERT ON public.acorn_lojistiks_transfers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_transfers_created_at();


--
-- Name: acorn_lojistiks_transfers tr_acorn_lojistiks_transfers_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_transfers_server_id BEFORE INSERT ON public.acorn_lojistiks_transfers FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_vehicle_types tr_acorn_lojistiks_vehicle_types_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_vehicle_types_server_id BEFORE INSERT ON public.acorn_lojistiks_vehicle_types FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_vehicles tr_acorn_lojistiks_vehicles_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_vehicles_server_id BEFORE INSERT ON public.acorn_lojistiks_vehicles FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_warehouses tr_acorn_lojistiks_warehouses_server_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER tr_acorn_lojistiks_warehouses_server_id BEFORE INSERT ON public.acorn_lojistiks_warehouses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_server_id();


--
-- Name: acorn_lojistiks_computer_products computer_products_created_by_user; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_computer_products
    ADD CONSTRAINT computer_products_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id);


--
-- Name: acorn_lojistiks_computer_products electronic_product_id; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_computer_products
    ADD CONSTRAINT electronic_product_id FOREIGN KEY (electronic_product_id) REFERENCES product.acorn_lojistiks_electronic_products(id) NOT VALID;


--
-- Name: acorn_lojistiks_electronic_products electronic_products_created_by_user; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_electronic_products
    ADD CONSTRAINT electronic_products_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id);


--
-- Name: acorn_lojistiks_electronic_products product_id; Type: FK CONSTRAINT; Schema: product; Owner: -
--

ALTER TABLE ONLY product.acorn_lojistiks_electronic_products
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_locations address_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT address_id FOREIGN KEY (address_id) REFERENCES public.acorn_lojistiks_addresses(id) NOT VALID;


--
-- Name: acorn_lojistiks_addresses addresses_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT addresses_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


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
    ADD CONSTRAINT area_types_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_areas areas_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT areas_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_employees backend_user_role_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT backend_user_role_id FOREIGN KEY (user_role_id) REFERENCES public.backend_user_roles(id) NOT VALID;


--
-- Name: acorn_lojistiks_products brand_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT brand_id FOREIGN KEY (brand_id) REFERENCES public.acorn_lojistiks_brands(id) NOT VALID;


--
-- Name: acorn_lojistiks_brands brands_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_brands
    ADD CONSTRAINT brands_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_container container_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container
    ADD CONSTRAINT container_id FOREIGN KEY (container_id) REFERENCES public.acorn_lojistiks_containers(id);


--
-- Name: acorn_lojistiks_containers containers_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_containers
    ADD CONSTRAINT containers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_addresses created_at; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT created_at FOREIGN KEY (created_at) REFERENCES public.acorn_calendar_event(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfers created_at; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT created_at FOREIGN KEY (created_at) REFERENCES public.acorn_calendar_event(id) NOT VALID;


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
    ADD CONSTRAINT drivers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_employees employees_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT employees_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_gps gps_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_gps
    ADD CONSTRAINT gps_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


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
-- Name: acorn_lojistiks_product_instances initial_transfer_product_instance_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances
    ADD CONSTRAINT initial_transfer_product_instance_id FOREIGN KEY (initial_transfer_product_instance_id) REFERENCES public.acorn_lojistiks_product_instance_transfer(id) NOT VALID;


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
    ADD CONSTRAINT locations_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products measurement_unit_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT measurement_unit_id FOREIGN KEY (measurement_unit_id) REFERENCES public.acorn_lojistiks_measurement_units(id);


--
-- Name: acorn_lojistiks_measurement_units measurement_units_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_measurement_units
    ADD CONSTRAINT measurement_units_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_offices offices_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_offices
    ADD CONSTRAINT offices_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_areas parent_area_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT parent_area_id FOREIGN KEY (parent_area_id) REFERENCES public.acorn_lojistiks_areas(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_categories parent_product_category_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT parent_product_category_id FOREIGN KEY (parent_product_category_id) REFERENCES public.acorn_lojistiks_product_category_types(id);


--
-- Name: acorn_lojistiks_people people_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT people_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


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
    ADD CONSTRAINT product_attributes_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_categories product_categories_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT product_categories_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


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
    ADD CONSTRAINT product_category_types_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


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
-- Name: acorn_lojistiks_product_instances product_instances_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances
    ADD CONSTRAINT product_instances_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_products product_products_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_products
    ADD CONSTRAINT product_products_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products products_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT products_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_products_product_categories products_product_categories_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories
    ADD CONSTRAINT products_product_categories_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_area_types server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_area_types
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_gps server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_gps
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_areas server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_addresses server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_measurement_units server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_measurement_units
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_products server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_product_instance_transfer server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_people server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_vehicle_types server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicle_types
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_containers server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_containers
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_vehicles server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_drivers server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_drivers
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_transfer_container server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_transfer_container_product_instances server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_product_category_types server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_category_types
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_product_categories server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_products_product_categories server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_locations server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id);


--
-- Name: acorn_lojistiks_transfers server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT server_id FOREIGN KEY (server_id) REFERENCES public.acorn_lojistiks_servers(id) NOT VALID;


--
-- Name: acorn_lojistiks_servers servers_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_servers
    ADD CONSTRAINT servers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


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
    ADD CONSTRAINT suppliers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_container transfer_container_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container
    ADD CONSTRAINT transfer_container_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfer_container_product_instances transfer_container_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances
    ADD CONSTRAINT transfer_container_id FOREIGN KEY (transfer_container_id) REFERENCES public.acorn_lojistiks_transfer_container(id);


--
-- Name: acorn_lojistiks_transfer_container_product_instances transfer_container_product_instances_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances
    ADD CONSTRAINT transfer_container_product_instances_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_instance_transfer transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT transfer_id FOREIGN KEY (transfer_id) REFERENCES public.acorn_lojistiks_transfers(id);


--
-- Name: acorn_lojistiks_transfer_container transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container
    ADD CONSTRAINT transfer_id FOREIGN KEY (transfer_id) REFERENCES public.acorn_lojistiks_transfers(id);


--
-- Name: acorn_lojistiks_transfer_container_product_instances transfer_product_instance_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances
    ADD CONSTRAINT transfer_product_instance_id FOREIGN KEY (transfer_product_instance_id) REFERENCES public.acorn_lojistiks_product_instance_transfer(id) NOT VALID;


--
-- Name: acorn_lojistiks_product_instance_transfer transfer_product_instances_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instance_transfer
    ADD CONSTRAINT transfer_product_instances_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_transfers transfers_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT transfers_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_people user_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people
    ADD CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES public.backend_users(id) NOT VALID;


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
    ADD CONSTRAINT vehicle_types_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_vehicles vehicles_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles
    ADD CONSTRAINT vehicles_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- Name: acorn_lojistiks_warehouses warehouses_created_by_user; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_warehouses
    ADD CONSTRAINT warehouses_created_by_user FOREIGN KEY (created_by_user_id) REFERENCES public.backend_users(id) NOT VALID;


--
-- PostgreSQL database dump complete
--

SET search_path TO public;
