do $BODY$
declare pid uuid;
begin
	insert into public.acorn_calendar_event_type(name, colour, style) values('Location created', '#091386', 'color:#fff');
	insert into public.acorn_calendar_event_type(name, colour, style) values('Transfer started', '#091386', 'color:#fff');

	-- ------------------------------------------- TODO: Remove this location stuff (already in AA/Location)
	insert into public.acorn_lojistiks_area_types(name) values('Country');
	insert into public.acorn_lojistiks_area_types(name) values('Canton');
	insert into public.acorn_lojistiks_area_types(name) values('City');
	insert into public.acorn_lojistiks_area_types(name) values('Village');
	insert into public.acorn_lojistiks_area_types(name) values('Town');
	insert into public.acorn_lojistiks_area_types(name) values('Comune');

	insert into public.acorn_lojistiks_areas(name, area_type_id, parent_area_id)
		select 'Syria', id, NULL from public.acorn_lojistiks_area_types atp
		where atp.name = 'Country' returning id into pid;
	insert into public.acorn_lojistiks_areas(name, area_type_id, parent_area_id)
		select 'Cezîra', id, pid
		from public.acorn_lojistiks_area_types atp
		where atp.name = 'Canton';
	insert into public.acorn_lojistiks_gps(longitude, latitude)
		values(37.0343936,41.2146239) returning id into pid;
	insert into public.acorn_lojistiks_areas(name, area_type_id, parent_area_id, gps_id)
		select 'Qamişlo', id, (select id from public.acorn_lojistiks_areas where name='Cezîra' limit 1),
				pid
		from public.acorn_lojistiks_area_types atp
		where atp.name = 'City';
	insert into public.acorn_lojistiks_gps(longitude, latitude)
		values(36.5166478,40.7416334) returning id into pid;
	insert into public.acorn_lojistiks_areas(name, area_type_id, parent_area_id, gps_id)
		select 'Al Hêseke', id, (select id from public.acorn_lojistiks_areas where name='Cezîra' limit 1),
				pid
		from public.acorn_lojistiks_area_types atp
		where atp.name = 'City';

	insert into public.acorn_lojistiks_brands(name) values('Lenovo');
	insert into public.acorn_lojistiks_brands(name) values('Samsung');
	insert into public.acorn_lojistiks_brands(name) values('Acer');

	insert into public.acorn_lojistiks_measurement_units(name, short_name, uses_quantity) values('Units', '', false);
	insert into public.acorn_lojistiks_measurement_units(name, short_name, uses_quantity) values('Litres', 'l', true);
	insert into public.acorn_lojistiks_measurement_units(name, short_name, uses_quantity) values('Kilograms', 'kg', true);

	insert into public.acorn_lojistiks_vehicle_types(name) values('Car');
	insert into public.acorn_lojistiks_vehicle_types(name) values('Lorry');

	insert into system_settings(item, "value")
		values('backend_brand_settings', '{"app_name":"Winter CMS","app_tagline":"Getting back to basics","primary_color":"#34495e","secondary_color":"#e67e22","accent_color":"#3498db","default_colors":[{"color":"#1abc9c"},{"color":"#16a085"},{"color":"#2ecc71"},{"color":"#27ae60"},{"color":"#3498db"},{"color":"#2980b9"},{"color":"#9b59b6"},{"color":"#8e44ad"},{"color":"#34495e"},{"color":"#2b3e50"},{"color":"#f1c40f"},{"color":"#f39c12"},{"color":"#e67e22"},{"color":"#d35400"},{"color":"#e74c3c"},{"color":"#c0392b"},{"color":"#ecf0f1"},{"color":"#bdc3c7"},{"color":"#95a5a6"},{"color":"#7f8c8d"}],"menu_mode":"inline","auth_layout":"split","menu_location":"top","icon_location":"inline","custom_css":""}');
end
$BODY$;
