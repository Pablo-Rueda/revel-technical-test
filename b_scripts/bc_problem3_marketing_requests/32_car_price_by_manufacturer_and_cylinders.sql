SELECT 	custom_car_manufacturer as manufacturer
		, cylinders
        , round(max(price),2) as max_price
        , round(min(price),2) as min_price
        , round(avg(price),2) as avg_price
	FROM revel_test.p_cars_fleet CF
	LEFT JOIN revel_test.cars_price CP
		ON  CF.id = CP.id
	LEFT JOIN revel_test.cars_country CC
		ON CF.origin = CC.origin
	WHERE country='Europe'
	GROUP BY custom_car_manufacturer, cylinders
    ORDER BY custom_car_manufacturer ASC, cylinders ASC

    
