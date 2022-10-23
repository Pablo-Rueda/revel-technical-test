SELECT 
	custom_car_manufacturer as manufacturer
    , count(*) as n_trips
    , round(sum(trip_distance),2) as total_distance_traveled
    , round(avg(trip_distance),2) as average_distance_traveled
    , round(avg(custom_trip_minutes),2) as average_trip_duration
FROM revel_test.p_cars_trips CT
LEFT JOIN revel_test.p_cars_fleet CF
	ON CT.car_id = CF.id
GROUP BY custom_car_manufacturer
