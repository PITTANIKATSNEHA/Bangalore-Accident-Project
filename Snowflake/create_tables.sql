CREATE TABLE RAW_DATA.city_crashes (
    year INT, fatal_crashes INT, killed INT, non_fatal_crashes INT, total_crashes INT, injured INT
);

CREATE TABLE RAW_DATA.station_crashes (
    year INT, station VARCHAR, zone VARCHAR, fatal_crashes INT, total_crashes INT, killed INT, non_fatal_crashes INT, injured INT
);

CREATE TABLE RAW_DATA.blackspots (
    station VARCHAR, latitude FLOAT, longitude FLOAT, severity VARCHAR
);
