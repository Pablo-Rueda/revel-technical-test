SELECT 
	custom_car_manufacturer as manufacturer
    , ROUND(SUM(CASE WHEN weight<=1000 THEN trip_distance ELSE 0 END),2) as "W_<1000"
    , ROUND(SUM(CASE WHEN weight>1000 AND weight<=2000  THEN trip_distance ELSE 0 END),2) as "W_1000-2000"
	, ROUND(SUM(CASE WHEN weight>2000 AND weight<=3000  THEN trip_distance ELSE 0 END),2) as "W_2000-3000"
	, ROUND(SUM(CASE WHEN weight>3000 AND weight<=4000  THEN trip_distance ELSE 0 END),2) as "W_3000-4000"
	, ROUND(SUM(CASE WHEN weight>4000 AND weight<=5000  THEN trip_distance ELSE 0 END),2) as "W_4000-5000"
	, ROUND(SUM(CASE WHEN weight>5000 THEN trip_distance ELSE 0 END),2) as "W_>5000"
FROM  revel_test.p_cars_fleet CF
LEFT JOIN revel_test.p_cars_trips CT 
	ON CT.car_id = CF.id
GROUP BY custom_car_manufacturer
ORDER BY custom_car_manufacturer ASC