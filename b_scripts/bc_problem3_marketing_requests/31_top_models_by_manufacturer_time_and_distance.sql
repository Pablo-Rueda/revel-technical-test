/* create a temp table getting the total distance and minutes info */
with gmm as ( /* gmm = Grouped by Manufacturer, Model*/
	SELECT 
		custom_car_manufacturer as manufacturer
		, model
		, sum(trip_distance) as total_distance
        , sum(custom_trip_minutes) as total_minutes
	FROM revel_test.p_cars_trips CT
	LEFT JOIN revel_test.p_cars_fleet CF
		ON CT.car_id = CF.id
	GROUP BY custom_car_manufacturer, model
),
gmm_rn as (  /* gmm_rn = Grouped by Manufacturer, Model _ Row Number*/
SELECT 
	manufacturer
	, model
    , round(total_minutes,2) as total_minutes
    /* Get the row number expected in the manufacturer grouping, when ordering by total_minutes*/
	, ROW_NUMBER() OVER (	PARTITION BY  manufacturer
							ORDER BY total_minutes DESC
						) AS rn
FROM gmm
WHERE total_distance>12000
)
SELECT '|' as "b|" /* bars to be able to get the answer in markdown format easily */
		, rn as top
        , '|' as "b2|"
        ,manufacturer
        , '|' as "b3|"
        , model
        , '|' as "b4|"
		, total_minutes
        , '|' as "b5|"
FROM gmm_rn 
WHERE rn <= 3 /*just show top 3 rows (since is order des total_minutes, it will be the top by min)*/