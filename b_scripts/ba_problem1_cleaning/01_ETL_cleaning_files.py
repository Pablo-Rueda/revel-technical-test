# 1. Import packages and load data:
import pandas as pd

cars_trips = pd.read_csv("../../a_data/aa_raw_data/cars_trips.csv")
cars_country = pd.read_csv("../../a_data/aa_raw_data/cars_country.csv")
cars_fleet = pd.read_csv("../../a_data/aa_raw_data/cars_fleet.csv")
cars_price  = pd.read_csv("../../a_data/aa_raw_data/cars_price.csv")

# 2. Transformations
#  cars_fleet - Get the cars manufacturer:
## get manufacturer by splitting the data:
cars_fleet["custom_car_manufacturer"] = cars_fleet["car_name"].str.split(" ", n = 1, expand = True)[0]
## Clean manufacturer:
cars_fleet["custom_car_manufacturer"] = cars_fleet["custom_car_manufacturer"].replace(
    [ "chevroelt", "maxda", "mercedes","toyouta", "vokswagen","vw"],
    [ "chevrolet", "mazda", "mercedes-benz", "toyota", "volkswagen","volkswagen"]
)

#  cars_trips - getting trip minutes:

cars_trips['start_time'] = pd.to_datetime(cars_trips['start_time']) # transform dates to date-time format
cars_trips['end_time'] = pd.to_datetime(cars_trips['end_time'])
## get the difference in the variables
cars_trips['custom_trip_minutes'] = (cars_trips['end_time'] - cars_trips['start_time']).astype('timedelta64[s]')/60

## Remove unnecesary cols:
cars_trips = cars_trips.drop(['start_time','end_time','start_longitude','start_latitude','end_longitude','end_latitude','store_and_fwd_fl'], axis=1)

# 3. save data:
cars_fleet.to_csv('../../a_data/ab_processed_data/p_cars_fleet.csv')  
cars_trips.to_csv(cars_fleet'../../a_data/ab_processed_data/p_cars_trips.csv')
