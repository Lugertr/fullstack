CREATE TABLE users
(
    id            serial       not null unique,
    name          varchar(255) not null,
    username      varchar(255) not null unique,
    password_hash varchar(255) not null,
    acc_status boolean
);

CREATE TABLE app_type_table 
( 
    app_type_id SERIAL    NOT NULL UNIQUE, 
    app_type_name TEXT NOT NULL 
);

CREATE TABLE app_table 
( 
    app_id SERIAL    NOT NULL UNIQUE, 
    rooms BIGINT NOT NULL, 
    app_type_id BIGINT NOT NULL REFERENCES app_type_table (app_type_id), 
    app_status BIGINT NOT NULL,
    app_price DOUBLE PRECISION NOT NULL 
);

CREATE TABLE client_table 
( 
    client_id   SERIAL    NOT NULL UNIQUE, 
    client_name TEXT NOT NULL, 
    family_name TEXT NOT NULL, 
    surname TEXT NOT NULL, 
    passport TEXT NOT NULL, 
    gender TEXT NOT NULL,
    app_id SERIAL NOT NULL REFERENCES app_table (app_id), 
    date_in TEXT NOT NULL, 
    date_out TEXT NOT NULL
);

CREATE TABLE service_type_table ( 
    service_type_id SERIAL    NOT NULL UNIQUE,  
    service_type_name TEXT NOT NULL, 
    price DOUBLE PRECISION NOT NULL 
);

CREATE TABLE service_table 
( 
    service_id SERIAL    NOT NULL UNIQUE, 
    client_id SERIAL NOT NULL REFERENCES client_table (client_id), 
    service_type_id SERIAL NOT NULL REFERENCES service_type_table (service_type_id), 
    days_count BIGINT NOT NULL 
);

CREATE TABLE old_client_table 
( 
    client_id   SERIAL    NOT NULL UNIQUE, 
    client_name TEXT NOT NULL, 
    family_name TEXT NOT NULL, 
    surname TEXT NOT NULL, 
    passport TEXT NOT NULL, 
    gender TEXT NOT NULL,
    app_id SERIAL NOT NULL, 
    date_in TEXT NOT NULL, 
    date_out TEXT NOT NULL
);

CREATE TABLE old_services_table 
( 
    service_id SERIAL    NOT NULL UNIQUE, 
    client_id SERIAL NOT NULL, 
    service_type_id SERIAL NOT NULL, 
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


INSERT INTO users (name, username, password_hash,acc_status) VALUES ('admin', 'admin', '686a7172686a7177313234363137616a6668616a738c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918','true');

INSERT INTO app_type_table (app_type_name) VALUES ('Обычная'), ('Люкс'), ('ПолуЛюкс');

INSERT INTO app_table (rooms, app_type_id, app_status, app_price) VALUES (1, 1, 1, 5000), (2, 2, 1, 7500), (4, 3, 1, 12000);

INSERT INTO client_table (client_name, family_name, surname, passport, gender, app_id, date_in, date_out) VALUES ('John', 'Doe', 'Smith', '123456789', 'Male', 1, '2021-10-01', '2021-10-05');

INSERT INTO service_type_table (service_type_name, price) VALUES ('Breakfast', 10.00), ('Lunch', 15.00), ('Dinner', 20.00);

INSERT INTO service_table (client_id, service_type_id, days_count) VALUES (1, 1, 4);