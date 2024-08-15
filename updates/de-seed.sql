-- Transfers & PIs
update public.acorn_lojistiks_product_instances set initial_transfer_product_instance_id = NULL;
delete from public.acorn_lojistiks_product_instance_transfer;
delete from public.acorn_lojistiks_transfer_container_product_instances;
delete from public.acorn_lojistiks_transfer_container;
delete from public.acorn_lojistiks_containers;
delete from public.acorn_lojistiks_transfers;
delete from public.acorn_lojistiks_product_instances;

-- Products
delete from public.acorn_lojistiks_products_product_categories;
delete from public.acorn_lojistiks_product_categories;
delete from public.acorn_lojistiks_product_attributes;
delete from product.acorn_lojistiks_computer_products;
delete from product.acorn_lojistiks_electronic_products;
delete from product.acorn_oil_oil_products;
delete from public.acorn_lojistiks_products;
-- delete from public.acorn_lojistiks_brands;
-- delete from public.acorn_lojistiks_measurement_units;

-- Locations
delete from public.acorn_oil_oil_depots;
delete from public.acorn_oil_refineries;
delete from public.acorn_oil_gas_stations;

delete from public.acorn_lojistiks_offices;
delete from public.acorn_lojistiks_suppliers;
delete from public.acorn_lojistiks_warehouses;
delete from public.acorn_lojistiks_locations;
delete from public.acorn_lojistiks_addresses;
delete from public.acorn_lojistiks_gps;
-- delete from public.acorn_lojistiks_areas;
-- delete from public.acorn_lojistiks_area_types;

-- Vehicles & People
delete from public.acorn_lojistiks_drivers;
delete from public.acorn_lojistiks_vehicles;
-- delete from public.acorn_lojistiks_vehicle_types;
delete from public.acorn_lojistiks_employees;
delete from public.acorn_lojistiks_people;