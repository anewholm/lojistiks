--
-- PostgreSQL database dump
--

-- Dumped from database version 14.12 (Ubuntu 14.12-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.3 (Ubuntu 16.3-1.pgdg22.04+1)

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

SET default_table_access_method = heap;

--
-- Name: acorn_lojistiks_addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_addresses (
    id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    area_id bigint NOT NULL,
    gps_id bigint,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    number character varying(1024)
);


--
-- Name: acorn_lojistiks_area_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_area_types (
    id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_areas; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_areas (
    id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    area_type_id bigint NOT NULL,
    parent_area_id bigint,
    gps_id bigint,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_brands; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_brands (
    id bigint NOT NULL,
    name character varying(2048) NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_computer_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_computer_products (
    id bigint NOT NULL,
    electronic_product_id bigint NOT NULL,
    memory bigint,
    "HDD_size" bigint,
    processor_type character varying(1024),
    processor_version double precision,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_containers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_containers (
    id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    name character varying(1024)
);


--
-- Name: acorn_lojistiks_depots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_depots (
    id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_drivers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_drivers (
    id bigint NOT NULL,
    person_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    vehicle_id bigint
);


--
-- Name: acorn_lojistiks_electronic_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_electronic_products (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    voltage double precision
);


--
-- Name: acorn_lojistiks_employees; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_employees (
    location_id bigint NOT NULL,
    person_id bigint NOT NULL,
    user_role_id integer NOT NULL
);


--
-- Name: acorn_lojistiks_gps; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_gps (
    id bigint NOT NULL,
    longitude character varying(1024) DEFAULT NULL::character varying,
    latitude character varying(1024) DEFAULT NULL::character varying,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_locations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_locations (
    id bigint NOT NULL,
    address_id bigint NOT NULL,
    name character varying(2048) DEFAULT 'office'::character varying NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    address_version integer DEFAULT 1 NOT NULL
);


--
-- Name: acorn_lojistiks_measurement_units; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_measurement_units (
    id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    uses_quantity boolean DEFAULT true NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_product_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_instances (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    quantity bigint DEFAULT 1 NOT NULL,
    external_identifier character varying(2048),
    initial_transfer_product_instance_id bigint,
    asset_class "char" DEFAULT 'C'::"char" NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_transfer_product_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_product_instances (
    id bigint NOT NULL,
    transfer_id bigint NOT NULL,
    product_instance_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_transfers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfers (
    id bigint NOT NULL,
    source_location_id bigint NOT NULL,
    destination_location_id bigint NOT NULL,
    sent_at timestamp with time zone DEFAULT now(),
    arrived_at timestamp with time zone,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    vehicle_id bigint
);


--
-- Name: acorn_lojistiks_movements; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.acorn_lojistiks_movements AS
 SELECT tr.destination_location_id AS location_id,
    tr.destination_location_id,
    tr.source_location_id,
    trp.product_instance_id,
    pi.quantity
   FROM ((public.acorn_lojistiks_transfers tr
     JOIN public.acorn_lojistiks_transfer_product_instances trp ON ((tr.id = trp.transfer_id)))
     JOIN public.acorn_lojistiks_product_instances pi ON ((pi.id = trp.product_instance_id)))
UNION ALL
 SELECT tr.source_location_id AS location_id,
    tr.destination_location_id,
    tr.source_location_id,
    trp.product_instance_id,
    ((- (1)::numeric) * (pi.quantity)::numeric) AS quantity
   FROM ((public.acorn_lojistiks_transfers tr
     JOIN public.acorn_lojistiks_transfer_product_instances trp ON ((tr.id = trp.transfer_id)))
     JOIN public.acorn_lojistiks_product_instances pi ON ((pi.id = trp.product_instance_id)));


--
-- Name: acorn_lojistiks_offices; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_offices (
    id bigint NOT NULL,
    location_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_oil_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_oil_products (
    id bigint NOT NULL,
    purity integer NOT NULL,
    octain_content integer NOT NULL,
    product_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_people; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_people (
    id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    user_id integer NOT NULL
);


--
-- Name: acorn_lojistiks_product_attributes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_attributes (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    value character varying(1024) NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_categories (
    id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    product_category_type_id bigint NOT NULL,
    parent_product_category_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_product_category_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_category_types (
    id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_product_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_product_products (
    product_id bigint NOT NULL,
    sub_product_id bigint NOT NULL,
    quantity bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_products; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_products (
    id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    measurement_unit_id bigint NOT NULL,
    brand_id bigint NOT NULL,
    model character varying(2048),
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
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
-- Name: acorn_lojistiks_products_product_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_products_product_categories (
    id bigint NOT NULL,
    product_id bigint NOT NULL,
    product_category_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_refineries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_refineries (
    id bigint NOT NULL,
    location_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_servers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_servers (
    id bigint NOT NULL,
    hostname character varying(1024) NOT NULL
);


--
-- Name: acorn_lojistiks_stocks; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.acorn_lojistiks_stocks AS
 SELECT alm.location_id,
    alm.product_instance_id,
    sum(alm.quantity) AS quantity
   FROM public.acorn_lojistiks_movements alm
  GROUP BY alm.location_id, alm.product_instance_id
 HAVING (sum(alm.quantity) > (0)::numeric);


--
-- Name: acorn_lojistiks_stock_products; Type: VIEW; Schema: public; Owner: -
--

CREATE VIEW public.acorn_lojistiks_stock_products AS
 SELECT als.location_id,
    alpi.product_id,
    sum(als.quantity) AS quantity
   FROM ((public.acorn_lojistiks_stocks als
     JOIN public.acorn_lojistiks_product_instances alpi ON ((als.product_instance_id = alpi.id)))
     JOIN public.acorn_lojistiks_products alp ON ((alpi.product_id = alp.id)))
  GROUP BY als.location_id, alpi.product_id;


--
-- Name: acorn_lojistiks_suppliers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_suppliers (
    id bigint NOT NULL,
    location_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_transfer_container; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_container (
    id bigint NOT NULL,
    transfer_id bigint NOT NULL,
    container_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_transfer_container_product_instances; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_transfer_container_product_instances (
    id bigint NOT NULL,
    transfer_container_id bigint NOT NULL,
    transfer_product_instance_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_vehicle_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_vehicle_types (
    id bigint NOT NULL,
    name character varying(1024) NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_vehicles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_vehicles (
    id bigint NOT NULL,
    vehicle_type_id bigint NOT NULL,
    registration character varying(1024) NOT NULL,
    initial_transfer_id bigint,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: acorn_lojistiks_warehouses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.acorn_lojistiks_warehouses (
    id bigint NOT NULL,
    location_id bigint NOT NULL,
    server_id bigint,
    version integer DEFAULT 1 NOT NULL,
    is_current_version boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.acorn_lojistiks_addresses.id;


--
-- Name: area_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.area_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: area_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.area_types_id_seq OWNED BY public.acorn_lojistiks_area_types.id;


--
-- Name: areas_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.areas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: areas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.areas_id_seq OWNED BY public.acorn_lojistiks_areas.id;


--
-- Name: brands_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.brands_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: brands_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.brands_id_seq OWNED BY public.acorn_lojistiks_brands.id;


--
-- Name: computer_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.computer_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: computer_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.computer_products_id_seq OWNED BY public.acorn_lojistiks_computer_products.id;


--
-- Name: containers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.containers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: containers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.containers_id_seq OWNED BY public.acorn_lojistiks_containers.id;


--
-- Name: depots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.depots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: depots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.depots_id_seq OWNED BY public.acorn_lojistiks_depots.id;


--
-- Name: drivers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.drivers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: drivers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.drivers_id_seq OWNED BY public.acorn_lojistiks_drivers.id;


--
-- Name: electronic_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.electronic_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: electronic_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.electronic_products_id_seq OWNED BY public.acorn_lojistiks_electronic_products.id;


--
-- Name: gps_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.gps_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: gps_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.gps_id_seq OWNED BY public.acorn_lojistiks_gps.id;


--
-- Name: jobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.jobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.location_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: location_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.location_id_seq OWNED BY public.acorn_lojistiks_locations.id;


--
-- Name: measurement_units_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.measurement_units_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: measurement_units_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.measurement_units_id_seq OWNED BY public.acorn_lojistiks_measurement_units.id;


--
-- Name: office_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.office_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: office_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.office_id_seq OWNED BY public.acorn_lojistiks_offices.id;


--
-- Name: office_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.office_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: office_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.office_products_id_seq OWNED BY public.acorn_lojistiks_electronic_products.id;


--
-- Name: person_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.person_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: person_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.person_id_seq OWNED BY public.acorn_lojistiks_people.id;


--
-- Name: product_attributes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_attributes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_attributes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_attributes_id_seq OWNED BY public.acorn_lojistiks_product_attributes.id;


--
-- Name: product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_categories_id_seq OWNED BY public.acorn_lojistiks_product_categories.id;


--
-- Name: product_category_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_category_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_category_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_category_types_id_seq OWNED BY public.acorn_lojistiks_product_category_types.id;


--
-- Name: product_instances_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_instances_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_instances_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_instances_id_seq OWNED BY public.acorn_lojistiks_product_instances.id;


--
-- Name: product_oil_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.product_oil_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_oil_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.product_oil_id_seq OWNED BY public.acorn_lojistiks_oil_products.id;


--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_id_seq OWNED BY public.acorn_lojistiks_products.id;


--
-- Name: products_product_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.products_product_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: products_product_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.products_product_categories_id_seq OWNED BY public.acorn_lojistiks_products_product_categories.id;


--
-- Name: refineries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.refineries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: refineries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.refineries_id_seq OWNED BY public.acorn_lojistiks_refineries.id;


--
-- Name: servers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.servers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: servers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.servers_id_seq OWNED BY public.acorn_lojistiks_servers.id;


--
-- Name: suppliers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.suppliers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: suppliers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.suppliers_id_seq OWNED BY public.acorn_lojistiks_suppliers.id;


--
-- Name: transfer_container_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transfer_container_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_container_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transfer_container_id_seq OWNED BY public.acorn_lojistiks_transfer_container.id;


--
-- Name: transfer_container_products_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transfer_container_products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_container_products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transfer_container_products_id_seq OWNED BY public.acorn_lojistiks_transfer_container_product_instances.id;


--
-- Name: transfer_product_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transfer_product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfer_product_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transfer_product_id_seq OWNED BY public.acorn_lojistiks_transfer_product_instances.id;


--
-- Name: transfers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transfers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transfers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transfers_id_seq OWNED BY public.acorn_lojistiks_transfers.id;


--
-- Name: vehicle_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vehicle_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicle_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vehicle_types_id_seq OWNED BY public.acorn_lojistiks_vehicle_types.id;


--
-- Name: vehicles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.vehicles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: vehicles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.vehicles_id_seq OWNED BY public.acorn_lojistiks_vehicles.id;


--
-- Name: warehouse_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.warehouse_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: warehouse_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.warehouse_id_seq OWNED BY public.acorn_lojistiks_warehouses.id;


--
-- Name: acorn_lojistiks_addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: acorn_lojistiks_area_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_area_types ALTER COLUMN id SET DEFAULT nextval('public.area_types_id_seq'::regclass);


--
-- Name: acorn_lojistiks_areas id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_areas ALTER COLUMN id SET DEFAULT nextval('public.areas_id_seq'::regclass);


--
-- Name: acorn_lojistiks_brands id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_brands ALTER COLUMN id SET DEFAULT nextval('public.brands_id_seq'::regclass);


--
-- Name: acorn_lojistiks_computer_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_computer_products ALTER COLUMN id SET DEFAULT nextval('public.computer_products_id_seq'::regclass);


--
-- Name: acorn_lojistiks_containers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_containers ALTER COLUMN id SET DEFAULT nextval('public.containers_id_seq'::regclass);


--
-- Name: acorn_lojistiks_depots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_depots ALTER COLUMN id SET DEFAULT nextval('public.depots_id_seq'::regclass);


--
-- Name: acorn_lojistiks_drivers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_drivers ALTER COLUMN id SET DEFAULT nextval('public.drivers_id_seq'::regclass);


--
-- Name: acorn_lojistiks_electronic_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_electronic_products ALTER COLUMN id SET DEFAULT nextval('public.office_products_id_seq'::regclass);


--
-- Name: acorn_lojistiks_gps id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_gps ALTER COLUMN id SET DEFAULT nextval('public.gps_id_seq'::regclass);


--
-- Name: acorn_lojistiks_locations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations ALTER COLUMN id SET DEFAULT nextval('public.location_id_seq'::regclass);


--
-- Name: acorn_lojistiks_measurement_units id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_measurement_units ALTER COLUMN id SET DEFAULT nextval('public.measurement_units_id_seq'::regclass);


--
-- Name: acorn_lojistiks_offices id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_offices ALTER COLUMN id SET DEFAULT nextval('public.office_id_seq'::regclass);


--
-- Name: acorn_lojistiks_oil_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_oil_products ALTER COLUMN id SET DEFAULT nextval('public.product_oil_id_seq'::regclass);


--
-- Name: acorn_lojistiks_people id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_people ALTER COLUMN id SET DEFAULT nextval('public.person_id_seq'::regclass);


--
-- Name: acorn_lojistiks_product_attributes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_attributes ALTER COLUMN id SET DEFAULT nextval('public.product_attributes_id_seq'::regclass);


--
-- Name: acorn_lojistiks_product_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_categories ALTER COLUMN id SET DEFAULT nextval('public.product_categories_id_seq'::regclass);


--
-- Name: acorn_lojistiks_product_category_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_category_types ALTER COLUMN id SET DEFAULT nextval('public.product_category_types_id_seq'::regclass);


--
-- Name: acorn_lojistiks_product_instances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_instances ALTER COLUMN id SET DEFAULT nextval('public.product_instances_id_seq'::regclass);


--
-- Name: acorn_lojistiks_products id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products ALTER COLUMN id SET DEFAULT nextval('public.products_id_seq'::regclass);


--
-- Name: acorn_lojistiks_products_product_categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products_product_categories ALTER COLUMN id SET DEFAULT nextval('public.products_product_categories_id_seq'::regclass);


--
-- Name: acorn_lojistiks_refineries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_refineries ALTER COLUMN id SET DEFAULT nextval('public.refineries_id_seq'::regclass);


--
-- Name: acorn_lojistiks_servers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_servers ALTER COLUMN id SET DEFAULT nextval('public.servers_id_seq'::regclass);


--
-- Name: acorn_lojistiks_suppliers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_suppliers ALTER COLUMN id SET DEFAULT nextval('public.suppliers_id_seq'::regclass);


--
-- Name: acorn_lojistiks_transfer_container id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container ALTER COLUMN id SET DEFAULT nextval('public.transfer_container_id_seq'::regclass);


--
-- Name: acorn_lojistiks_transfer_container_product_instances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances ALTER COLUMN id SET DEFAULT nextval('public.transfer_container_products_id_seq'::regclass);


--
-- Name: acorn_lojistiks_transfer_product_instances id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_product_instances ALTER COLUMN id SET DEFAULT nextval('public.transfer_product_id_seq'::regclass);


--
-- Name: acorn_lojistiks_transfers id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers ALTER COLUMN id SET DEFAULT nextval('public.transfers_id_seq'::regclass);


--
-- Name: acorn_lojistiks_vehicle_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicle_types ALTER COLUMN id SET DEFAULT nextval('public.vehicle_types_id_seq'::regclass);


--
-- Name: acorn_lojistiks_vehicles id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_vehicles ALTER COLUMN id SET DEFAULT nextval('public.vehicles_id_seq'::regclass);


--
-- Name: acorn_lojistiks_warehouses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_warehouses ALTER COLUMN id SET DEFAULT nextval('public.warehouse_id_seq'::regclass);


--
-- Name: acorn_lojistiks_employees acorn_lojistiks_location_people_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_employees
    ADD CONSTRAINT acorn_lojistiks_location_people_pkey PRIMARY KEY (location_id, person_id);


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
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id, version);


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
-- Name: acorn_lojistiks_computer_products computer_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_computer_products
    ADD CONSTRAINT computer_products_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_containers containers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_containers
    ADD CONSTRAINT containers_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_depots depots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_depots
    ADD CONSTRAINT depots_pkey PRIMARY KEY (id);


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
-- Name: acorn_lojistiks_electronic_products office_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_electronic_products
    ADD CONSTRAINT office_products_pkey PRIMARY KEY (id);


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
-- Name: acorn_lojistiks_oil_products product_oil_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_oil_products
    ADD CONSTRAINT product_oil_pkey PRIMARY KEY (id);


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
-- Name: acorn_lojistiks_refineries refineries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_refineries
    ADD CONSTRAINT refineries_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_servers servers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_servers
    ADD CONSTRAINT servers_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_suppliers suppliers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_suppliers
    ADD CONSTRAINT suppliers_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_transfer_container transfer_container_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container
    ADD CONSTRAINT transfer_container_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_transfer_container_product_instances transfer_container_products_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances
    ADD CONSTRAINT transfer_container_products_pkey PRIMARY KEY (id);


--
-- Name: acorn_lojistiks_transfer_product_instances transfer_product_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_product_instances
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
-- Name: fki_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_address_id ON public.acorn_lojistiks_locations USING btree (address_id, address_version);


--
-- Name: fki_backend_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_backend_user_id ON public.acorn_lojistiks_people USING btree (user_id);


--
-- Name: fki_vehicle_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX fki_vehicle_id ON public.acorn_lojistiks_transfers USING btree (vehicle_id);


--
-- Name: acorn_lojistiks_addresses tr_acorn_lojistiks_addresses_version; Type: TRIGGER; Schema: public; Owner: -
--

-- FUNCTION: public.fn_acorn_lojistiks_addresses_version()

-- DROP FUNCTION IF EXISTS public.fn_acorn_lojistiks_addresses_version();

CREATE OR REPLACE FUNCTION public.fn_acorn_lojistiks_addresses_version()
    RETURNS trigger
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE NOT LEAKPROOF
AS $BODY$
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
	if old.is_current_version != new.is_current_version then raise exception 'Cannot change is_current_version irectly'; end if;
	if not old.is_current_version then raise exception 'Can only change the current version'; end if;

	if old.number is null and not new.number is null then
		-- We do not make new versions for completion of null fields
	else
		-- Insert the new record instead
		-- TODO: Can we insert the row object directly here?
		new.version := new.version + 1;
		new.created_at = now();
		insert into public.acorn_lojistiks_addresses
			("id", "name", "number", "area_id", "gps_id", "version", is_current_version, created_at)
			values(new.id, new.name, new.number, new.area_id, new.gps_id, new.version, new.is_current_version, new.created_at);

		-- Switch, so we keep the old record
		new := old;
		new.is_current_version := false;
	end if;

	return new;
end;
$BODY$;

CREATE TRIGGER tr_acorn_lojistiks_addresses_version BEFORE UPDATE ON public.acorn_lojistiks_addresses FOR EACH ROW EXECUTE FUNCTION public.fn_acorn_lojistiks_addresses_version();


--
-- Name: acorn_lojistiks_locations address_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_locations
    ADD CONSTRAINT address_id FOREIGN KEY (address_id, address_version) REFERENCES public.acorn_lojistiks_addresses(id, version) NOT VALID;


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
-- Name: acorn_lojistiks_transfer_container container_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container
    ADD CONSTRAINT container_id FOREIGN KEY (container_id) REFERENCES public.acorn_lojistiks_containers(id);


--
-- Name: acorn_lojistiks_transfers destination_location_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfers
    ADD CONSTRAINT destination_location_id FOREIGN KEY (destination_location_id) REFERENCES public.acorn_lojistiks_locations(id) NOT VALID;


--
-- Name: acorn_lojistiks_computer_products electronic_product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_computer_products
    ADD CONSTRAINT electronic_product_id FOREIGN KEY (electronic_product_id) REFERENCES public.acorn_lojistiks_electronic_products(id) NOT VALID;


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
    ADD CONSTRAINT initial_transfer_product_instance_id FOREIGN KEY (initial_transfer_product_instance_id) REFERENCES public.acorn_lojistiks_transfer_product_instances(id) NOT VALID;


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
-- Name: acorn_lojistiks_products measurement_unit_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_products
    ADD CONSTRAINT measurement_unit_id FOREIGN KEY (measurement_unit_id) REFERENCES public.acorn_lojistiks_measurement_units(id);


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
-- Name: acorn_lojistiks_oil_products product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_oil_products
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_electronic_products product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_electronic_products
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_product_attributes product_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_product_attributes
    ADD CONSTRAINT product_id FOREIGN KEY (product_id) REFERENCES public.acorn_lojistiks_products(id);


--
-- Name: acorn_lojistiks_transfer_product_instances product_instance_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_product_instances
    ADD CONSTRAINT product_instance_id FOREIGN KEY (product_instance_id) REFERENCES public.acorn_lojistiks_product_instances(id) NOT VALID;


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
-- Name: acorn_lojistiks_transfer_product_instances server_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_product_instances
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
-- Name: acorn_lojistiks_transfer_container_product_instances transfer_container_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_container_product_instances
    ADD CONSTRAINT transfer_container_id FOREIGN KEY (transfer_container_id) REFERENCES public.acorn_lojistiks_transfer_container(id);


--
-- Name: acorn_lojistiks_transfer_product_instances transfer_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.acorn_lojistiks_transfer_product_instances
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
    ADD CONSTRAINT transfer_product_instance_id FOREIGN KEY (transfer_product_instance_id) REFERENCES public.acorn_lojistiks_transfer_product_instances(id) NOT VALID;


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


-- FUNCTION: public.fn_random_data_entry(integer)

-- DROP FUNCTION IF EXISTS public.fn_random_data_entry(integer);

CREATE OR REPLACE FUNCTION public.fn_random_data_entry(
	rows_number integer)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
		begin
			delete from acorn_lojistiks_transfers;
			delete from acorn_lojistiks_addresses;
			delete from acorn_lojistiks_areas;
			delete from acorn_lojistiks_area_types;
			delete from acorn_lojistiks_gps;

			if (select count(*) from acorn_lojistiks_gps) = 0 then
				perform setval('public.gps_id_seq', (SELECT MAX(id) FROM acorn_lojistiks_gps) + 1, 'true');
				for i in 1..rows_number loop
					insert into acorn_lojistiks_gps(longitude, latitude)
					values(random() * 999 + 1, random() * 999 + 1);
				end loop;
			end if;

			if (select count(*) from acorn_lojistiks_area_types) = 0 then
				perform setval('public.area_types_id_seq', (SELECT MAX(id) FROM acorn_lojistiks_area_types) + 1, 'true');
				for i in 1..rows_number loop
					insert into acorn_lojistiks_area_types(name)
					values(concat('type', i));
				end loop;
			end if;

			if (select count(*) from acorn_lojistiks_areas) = 0 then
				perform setval('public.areas_id_seq', (SELECT MAX(id) FROM acorn_lojistiks_areas) + 1, 'true');
				for i in 1..rows_number loop
					insert into acorn_lojistiks_areas(name, area_type_id, parent_area_id, gps_id)
					values(concat('area', i), random() * 999 + 1, random() * 999 + 1, random() * 999 + 1);
				end loop;
			end if;

			if (select count(*) from acorn_lojistiks_addresses) = 0 then
				perform setval('public.addresses_id_seq', (SELECT MAX(id) FROM acorn_lojistiks_addresses) + 1, 'true');
				for i in 1..rows_number loop
					insert into acorn_lojistiks_addresses(street, area_id, gps_id)
					values(concat('address', i), random() * 999 + 1, random() * 999 + 1);
				end loop;
			end if;

			-- if (select count(*) from acorn_lojistiks_transfers) = 0 then
			-- 	perform setval('public.transfers_id_seq', (SELECT MAX(id) FROM acorn_lojistiks_transfers) + 1, 'true');
			-- 	for i in 1..rows_number loop
			-- 		insert into acorn_lojistiks_transfers(source_address_id, destination_address_id)
			-- 		values(random() * 999 + 1, random() * 999 + 1);
			-- 	end loop;
			-- end if;

			return 0;
		end

$BODY$;


--
-- PostgreSQL database dump complete
--

