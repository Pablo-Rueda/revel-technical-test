# Analytics Engineer - Technical Test

## 1. BACKGROUND
###  1.1 What will you find here:
In this repository you can find my answers to the Analytics Engineer technical test at Revel. You can also find any document or script I have generated on the process.

This README document will provide a summary of my script, problems and answers. Here you will find the information linked, just in case you want to take a deeper look in my thought process.

###   1.2. Folders schema:
The folders in this repository follows the next schema:

- **a_data** - *store all the data*  
    - **aa_raw_data** - *store the raw data we received as input*  
    - **ab_processed_data** - *store the processed data for calculations*  
- **b_scripts** -  *store the scripts I have used* 
    - **ba_problem1_cleaning** - *store the first part cleaning scripts* 
    - **bb_problem2_operations_requests** - *store the second part answering scripts* 
    - **bc_problem3_marketing_requests** - *store the third part answering scripts* 
- **c_problems_answers** - *documents to support the problems answers* 

Now I will proceed with the answers.

## 2. DATA PREPARATION

The first task was to prepare the data for further analysis and provide the data model. 

First I checked the data in a [jupyter notebook](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/ba_problem1_cleaning/00_data_checks.ipynb). In the [DATA_PREP document](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/DATA_PREP.md) you can find the long process I followed and all my thoughts.
  
Here you can find a summary of what I have done and extracted:  
1. **General stats for checks**: 

I got the variables types, nº null values, distinct values, min values, max values and averages when possible for each table.

2. **Null values**: 

I  researched deeper on the causes of the null values, see if I can find an alternative way of getting the data and, if possible, ask the data source provider if it could be filled.

For example, I have tried to calculate the trip distance based on the latitude and longitude locations ([stackoverflow reference](https://stackoverflow.com/questions/19412462/getting-distance-between-two-points-based-on-latitude-longitude)). But after some difficulties in the calculations and since there were not many null values, I moved forward to avoid getting my time consumed on this task. On a work enviroment, I would double check with my colleages if I should keep researching on this formulas.  

3. **Extracting the car manufacturer from the *car_name***: 

Since in further analysis I would have to extract the car manufacturer, I have splitted it from the *car_name* variable in the *cars_fleet* table. Then I replaced some manufacturer names with miss-spells.  

You can find the transformation in the [jupyter notebook](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/ba_problem1_cleaning/00_data_checks.ipynb) or in the data cleaning [python script](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/ba_problem1_cleaning/01_ETL_cleaning_files.py).

4. **Extracting the trips time in minutes**: 

Since for further analysis I would need the trips time in minutes, I extracted it from the cars_trip table using the start_time and end_time variables. I also droped columns that I weren't going to use if further analysis.  

Again, this can be find in the [jupyter notebook](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/ba_problem1_cleaning/00_data_checks.ipynb) or in the data cleaning [python script](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/ba_problem1_cleaning/01_ETL_cleaning_files.py).

5. **Loading data to MySQL**: 
I loaded most of the tables to MySQL using it import functionality. Since the *cars_trips* table have too many rows (over 1 million), I loaded it with a [SQL query](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/ba_problem1_cleaning/02_SQL_Load_cars_trips.sql). to optimize the loading speed.


6. **Final data model**: 
I created the final data model in MySQL workbench with the clean tables.
<p align="center">
  <img src=".\c_problems_answers\1_final_model.png">
</p>

## 3. OPERATIONS REQUEST

The operations teams asked for:
- *Number of trips done by car manufacturer*
- *Total distance travelled and average trip distance travelled by car manufacturer*
- *Average trip duration in minutes by car manufacturer*

These request can be summarized in a single [SQL query](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/bb_problem2_operations_requests/SQL_operations_script.sql) would be similar to the below [table](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/c_problems_answers/2_Operations_requests.xml):

| manufacturer | n_trips | total_distance_traveled | average_distance_traveled | average_trip_duration |
|---|---|---|---|---|
| fiat  | 30449 | 100802,98 | 3,31 | 202,5 |
| chevrolet  | 167298 | 540760,99 | 3,23 | 212,07 |
| plymouth  | 117514 | 384031,97 | 3,27 | 211,77 |
| oldsmobile  | 38234 | 124161,46 | 3,25 | 205,57 |
| ford  | 195055 | 630859,39 | 3,23 | 212,94 |
| ...  | ... | ... | ... | ... |

## 4. MARKETING REQUESTS

Each of the marketing request needed its own query. The answers to them would be:

- ***TOP 3 models by manufacturer and time travelled (over 12.000 KM):***
Here I had to divide the problem in smaller steps: 
1. Aggregate the data by manufacturer and model, calculating on the group clause the total_distance and total_minutes. 
2. Filter the total_distance by KM (>12.000), part the table by manufacturer, order the table withing the partition by total_minutes and get the rows number (which now would represent the positio non the top by total_minutes).
3. Filter the data by rows withing the manufacturer partition (<=3).

You can find this process in the [SQL script](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/bc_problem3_marketing_requests/31_top_models_by_manufacturer_time_and_distance.sql). Below, you can see the [output](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/c_problems_answers/31_top_models.xml) table.

| top | manufacturer | model | total_minutes |
|---|---|---|---|
| 1 | amc  | 73 | 3055356,25 |
| 2 | amc  | 70 | 2973360,63 |
| 3 | amc  | 71 | 2542771,73 |
| 1 | audi  | 80 | 1566002,63 |
| 2 | audi  | 78 | 909047,12 |
| ... | ...  | ... | ... |

- ***Total distance travelled and average trip distance travelled by car manufacturer:***

As for the Operations requests, the [SQL query](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/bc_problem3_marketing_requests/32_car_price_by_manufacturer_and_cylinders.sql) here was an straight fordward query. I had to join the *cars_fleet* data to *cars_price* and *cars_origin*.

Here you can find the [output](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/c_problems_answers/32_price.xml).

| manufacturer | cylinders | max_price | min_price | avg_price | 
| --- | --- | --- | --- | --- |
| audi  | 4 | 40000 | 16577.46 | 31317.1 | 
| audi  | 5 | 44494,54 | 43261.83 | 43878.19 |
| bmw  | 4 | 23927,44 | 15047.99 | 19487.72 |
| fiat  | 4 | 37496 | 8068.23 | 26249.98 | 
| mercedes-benz   | 4 | 20000 | 20000 | 20000 |
| ...  | ... | ... | ... | ... |


- ***Trip distance by manufacturer and weight category:***

Here the request was to pivot the data by manufacturer and the weight category provided by the marketing team.  

For what I know, some SQL enviroments allows to pivot the data directly in the query. Any way, with MySQL it is not possible so I had to write the [SQL script](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/b_scripts/bc_problem3_marketing_requests/33_manufacturer_weight_matrix.sql) calculating the columns manually. 

Below is the [output](https://github.com/Pablo-Rueda/revel-technical-test/blob/main/c_problems_answers/33_manufacturer_weight_tripKM_matrix.xml) of the  query:

| manufacturer | 	W_<1000	 | W_1000-2000 | 	W_2000-3000	 | W_3000-4000	 | W_4000-5000 | 	W_>5000 | 
| --- | --- | --- | --- | --- | --- | --- |
| amc | 0	 |0	 |111384,63	 |223366,38	 |13042,97 |	0 |
| audi  |	0	 | 0 |	85730,49 |	0 |	0 |	0 |
| bmw  |	0 |	0 |	25259,03 |	0 |	0 |	0 |
| buick  |	0 |	0 |	49796,93 |	100452,61 |	61610,61 |	0 |
| cadillac  |	0 |	0 |	0 |	11865,23 |	11718,84 |	0 |

Another option would have been to create a single varaible with the weights, group by the weights and manufacturer, download the data and pivot it in an Excel spreadsheet.