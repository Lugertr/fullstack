CREATE TABLE users
(
    id            serial       not null unique,
    name          varchar(255) not null,
    username      varchar(255) not null unique,
    password_hash varchar(255) not null
);

CREATE TABLE client_table 
( 
    client_id   SERIAL    NOT NULL UNIQUE, 
    client_name TEXT NOT NULL, 
    family_name TEXT NOT NULL, 
    surname TEXT NOT NULL, 
    passport TEXT NOT NULL, 
    gender TEXT NOT NULL,
    app_id BIGINT NOT NULL, 
    date_in TEXT NOT NULL, 
    date_out TEXT NOT NULL
);

CREATE TABLE app_table 
( 
    app_id SERIAL    NOT NULL UNIQUE, 
    rooms BIGINT NOT NULL, 
    app_type_id BIGINT NOT NULL, 
    app_status BIGINT NOT NULL,
    app_price DOUBLE PRECISION NOT NULL 
);

CREATE TABLE app_type_table 
( 
    app_type_id SERIAL    NOT NULL UNIQUE, 
    app_type_name TEXT NOT NULL 
);

CREATE TABLE service_table 
( 
    service_id SERIAL    NOT NULL UNIQUE, 
    client_id BIGINT NOT NULL, 
    service_type_id BIGINT NOT NULL, 
    days_count BIGINT NOT NULL 
);

CREATE TABLE service_type_table ( 
    service_type_id SERIAL    NOT NULL UNIQUE,  
    service_type_name TEXT NOT NULL, 
    price DOUBLE PRECISION NOT NULL 
);

CREATE TABLE old_client_table 
( 
    client_id   SERIAL    NOT NULL UNIQUE, 
    client_name TEXT NOT NULL, 
    family_name TEXT NOT NULL, 
    surname TEXT NOT NULL, 
    passport TEXT NOT NULL, 
    gender TEXT NOT NULL,
    app_id BIGINT NOT NULL, 
    date_in TEXT NOT NULL, 
    date_out TEXT NOT NULL
);

CREATE TABLE old_services_table 
( 
    service_id SERIAL    NOT NULL UNIQUE, 
    client_id BIGINT NOT NULL, 
    service_type_id BIGINT NOT NULL, 
    days_count BIGINT NOT NULL 
);

CREATE OR REPLACE FUNCTION client_deletion_trigger_function()
  RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO old_client_table (
    client_id,
    client_name,
    family_name,
    surname,
    passport,
    gender,
    app_id,
    date_in,
    date_out
  )
  VALUES (
    OLD.client_id,
    OLD.client_name,
    OLD.family_name,
    OLD.surname,
    OLD.passport,
    OLD.gender,
    OLD.app_id,
    OLD.date_in,
    OLD.date_out
  );
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER client_deletion_trigger
AFTER DELETE ON client_table
FOR EACH ROW
EXECUTE FUNCTION client_deletion_trigger_function();