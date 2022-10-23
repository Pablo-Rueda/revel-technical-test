
CREATE TABLE if not exists revel_test.p_cars_trips (
    car_id INT,
    trip_distance DOUBLE,
    rate_code_id INT,
    custom_trip_minutes DOUBLE
    );

LOAD DATA LOCAL INFILE 'PATH/revel-technical-test/a_data/ab_processed_data/p_cars_trips.csv' IGNORE
    INTO TABLE revel_test.p_cars_trips
    FIELDS TERMINATED BY ',';
    
