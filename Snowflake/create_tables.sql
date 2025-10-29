-- Create a new database for your project
CREATE DATABASE BTP_ANALYTICS;

-- Use the database
USE DATABASE BTP_ANALYTICS;

-- Create schema for raw data
CREATE SCHEMA RAW_DATA;

-- Create schema for analytics
CREATE SCHEMA ANALYTICS;
-- create tables 
CREATE TABLE RAW_DATA.city_crashes (
    year INT, fatal_crashes INT, killed INT, non_fatal_crashes INT, total_crashes INT, injured INT
);

CREATE TABLE RAW_DATA.station_crashes (
    year INT, station VARCHAR, zone VARCHAR, fatal_crashes INT, total_crashes INT, killed INT, non_fatal_crashes INT, injured INT
);

CREATE TABLE RAW_DATA.blackspots (
    station VARCHAR, latitude FLOAT, longitude FLOAT, severity VARCHAR
);
