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
    date_out TEXT NOT NULL, 
    client_type_id BIGINT NOT NULL 
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
( -
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
