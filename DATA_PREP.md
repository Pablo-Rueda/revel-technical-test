# TECHNICAL TEST - DATA PREPARATION
***Cleaning:** Console: Jupyter Notebook | Language: Python | Packages: pandas*

In this document, you can find extended the process of my thoughts and things I realised when cleaning the data. You can find the scripts and test I did on the [jupyter notebook](.\b_scripts\ba_problem1_cleaning\00_data_checks.ipynb).

# STATS AND METADATA

First, I always like to take a look of the first rows of the tables I will work with. I looked at the head of the tables and created a function to extract some general statistics and metadata. I created the function to have an ouput that I could easily translate to markdown.

```
def getMetaTable(df):
    for col in df.columns:
        a = df[col].dtypes
        b = df[col].isna().sum()
        c = len(df[col].unique())
        if a=='int64' or a =='float64':
            d = round(df[col].min(),2)
            e = round(df[col].max(),2)
            f = round(df[col].mean(),2)
        else:
            d = ' -- '
            e = ' -- '
            f = ' -- ' 
        print( '| ', col,' |', a, ' | ' , b, '|' , c,' | ' ,d,' | ' ,e, ' | ', f, '|')
    return  
```

Then I went throught each table looking at the output of the function and analysing it a bit. In some cases, I take a deeper look since I thought it could be possible to solve some lack of data in some cases. Then I prepared the table data for future use.

## 1. cars_fleet table
- **Table**  

| Var  | Var_type | NULL_Values  | Distincts_Values | Min_Values | Max_Values | Average | 
|---|---|---|---|---|---|---|
|  id  | int64  |  0 | 398  |  1  |  398  |  199.5 |
|  mpg  | float64  |  0 | 129  |  9.0  |  46.6  |  23.51 |
|  cylinders  | int64  |  0 | 5  |  3  |  8  |  5.45 |
|  displacement  | float64  |  0 | 82  |  68.0  |  455.0  |  193.43 |
|  horsepower  | float64  |  6 | 94  |  46.0  |  230.0  |  104.47 |
|  weight  | int64  |  0 | 351  |  1613  |  5140  |  2970.42 |
|  acceleration  | float64  |  0 | 95  |  8.0  |  24.8  |  15.57 |
|  model  | int64  |  0 | 13  |  70  |  82  |  76.01 |
|  origin  | int64  |  0 | 3  |  1  |  3  |  1.57 |
|  car_name  | object  |  0 | 305  |   --   |   --   |   --  |

- **Insights**

Some quick insights about the data preparation or for further analytical researh (we'll extend more in analysis in further points):
1. Data prep: we have 6 vehicles with null values in *horsepower*.
2. Data prep: from the heads, we can see the car_name. Based on it, we might be able to extract the manufacturer:
3. Analytical: We have almost 1 car with a pretty low milles per gallon (MPG) performance (9 mpg).
4. Analytical: The fleet is underperforming by a bit the average of milles per gallon (average compared to: https://afdc.energy.gov/data/10310).

- **Preparation**

1. Horsepower null values:

As mentioned above, there are 6 null values in the *horsepower* column.
My first inquiry (just for curiosity), would be *"which vehicles are?"*. I would take a look into some cases to see if I get an idea of why this is happening:
```
nan_rows  = cars_fleet[cars_fleet.isna().any(axis=1)]
print(nan_rows)
```
The null value cases are the cars with ID: 33, 127, 331, 337, 355 and 375. I don't find anything relatable about these cases on this first look.  

Given that, I would ask myself *"should it be possible to have this var empty?"* (ie. the cara might be at the repair shop). I would look into the database documentation or check if I can ask people who should fill this data.

For further analysis using the horsepower we could: drop the null rows or imputate them (by average, machine learnign models, etc.).

2. Get the cars manufacturer:

We can get the car brand or sub-brand by splitting the data. Then, grouping it we can check if there is any anomaly:

```
# get manufacturer by splitting the data:
cars_fleet["car_manufacturer_raw"] = cars_fleet["car_name"].str.split(" ", n = 1, expand = True)[0]

# Check the output manufacturer:
print(cars_fleet.groupby('car_manufacturer_raw').id.nunique())

```
From the manufacturer output we can see that there are some misspellings (*chevroelt, maxda*). There are also some sub-brands which are part of the same manufacturer (*buick, cadillac*)

Ideally, if there is someone with the ownership of storing this information, I would flag the issue to them. 
Anyway, since the other departments should wait much for their answer, I would ask for a model to relate the output with the manufacturers.

```
cars_fleet["car_manufacturer_clean"] = cars_fleet["car_manufacturer_raw"].replace(
    [ "chevroelt", "maxda", "mercedes","toyouta", "vokswagen","vw"],
    [ "chevrolet", "mazda", "mercedes-benz", "toyota", "volkswagen","volkswagen"]
)
```

Once replaced, we can save this data.

```
Note: When cleaning the data, I found that many of the names from the split where divisions of a major manufacturer. For example, Chevrolet is part of the General Motors. Since the questions refeer to Chevrolet as a manufacturer, I understood that I should use the divisions instead of the conglomerate*
```

## **2. cars_price:** 

- **Table**  

| Var  | Var_type | NULL_Values  | Distincts_Values | Min_Values | Max_Values | Average | 
|---|---|---|---|---|---|---|
|  id  | int64  |  0 | 398  |  1  |  398  |  199.5 |
|  price  | float64  |  0 | 224  |  1598.07  |  53745.94  |  29684.47 |

- **Insights**

In this case, we see that there is no null data. Besides that, I only see as interesting that there are 224 distinct price values, which means that many cars have the same price.

## **3. cars_country:** 
Looking at the head, we can see that this table only has two columns and three rows. It seems a metadata table to relate to relate with cars_fleet. I will display directly the data:

- **Table** 
 
| origin  | country | 
|---|---|
| 1  | USA |
| 2 | Europe |
| 3 | Japan |

## **4. cars_trips:** 

- **Table**

| Var  | Var_type | NULL_Values  | Distincts_Values | Min_Values | Max_Values | Average | 
|---|---|---|---|---|---|---|
|  car_id  | int64  |  0 | 397  |  1  |  397  |  199.07 |
|  start_time  | object  |  4994 | 1065457  |   --   |   --   |   --  |
|  end_time  | object  |  0 | 1070573  |   --   |   --   |   --  |
|  start_longitude  | float64  |  0 | 31387  |  -115.28  |  0.0  |  -73.82 |
|  start_latitude  | float64  |  0 | 69947  |  0.0  |  42.32  |  40.68 |
|  end_longitude  | float64  |  0 | 40476  |  -115.33  |  0.0  |  -73.83 |
|  end_latitude  | float64  |  0 | 80296  |  0.0  |  42.32  |  40.68 |
|  trip_distance  | float64  |  9968 | 7754  |  0.0  |  235.5  |  3.28 |
|  store_and_fwd_fl  | object  |  0 | 2  |   --   |   --   |   --  |
|  rate_code_id  | int64  |  0 | 7  |  1  |  99  |  1.09 |

- **Insights**

This table seems to have some anomalies in it data that should be revised:
1. Data prep: we have null values in the start_time variable, but not in end_time.
2. Data prep: the min value for longitude/latitude variables is 0.
3. Data prep: we have a big amount of null values in trip_distance

- **Preparation**

1. Null data in start time:

First, I check if I can see some patterns in the data about the null values with the below code (I compare it with a similar output for the full database).

```
cars_trips['custom_end_day'] = cars_trips['end_time'].str.slice(0, 10)
cars_trips['custom_start_longitude'] = round(cars_trips['start_longitude'])
cars_trips['custom_start_latitude'] = round(cars_trips['start_latitude'])

nan_rows  =  cars_trips[cars_trips['start_time'].isnull()]

print(nan_rows.groupby('custom_end_day').car_id.nunique())
print(nan_rows.groupby('custom_start_longitude').agg('count').car_id)
print(nan_rows.groupby('custom_start_latitude').agg('count').car_id)
```
We can see that:
- *end_day:* there is data from 2016-02-01 to 2016-03-04, while in the general set there is data from 2016-02-01 to 2016-03-12.
- *start_longitude* and *start_latitude:* We have 4981 null values when longitude is -74 (9 in different longitude) and 4985 with 41 latitude. Most of the records in the complete dataset are in this longitude and latitude, so I wouldn't relate it with the null values.

In this scenario, I would flag this problem to the team in charge of the app to confirm that everything is working correctly.

2. Longitude/latitude with 0 values:

We can see that there are values with 0 Longitude and Latitude. When revising the head of the data and some general stats, I can't find any relatable trend. I would flag it to devs to see if this is an error in the software or there are cases when we can't get this kind of information (ie. due to privacy of data gathering).

3. trip_distance null values:

Since we have the Longitude and latitude start and end points data, I thought about calculating the trip distance for the missing rows. I researched a bit and found some functions that could be useful for this purpose in [stackoverflow](https://stackoverflow.com/questions/19412462/getting-distance-between-two-points-based-on-latitude-longitude).

I switched the functions to numpy to be able to work with the dataframe and created the function:

```
def calcDistance(lat1, lat2, lon1, lon2):
    R = 6373
    lat1 = radians(lat1)
    lon1 = radians(lat2)
    lat2 = radians(lon1)
    lon2 = radians(lon2)
    dlat = lat2 - lat1
    dlon = lon2 - lon1
    a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
    c = 2 * arctan2(sqrt(a), sqrt(1 - a))
    return  R * c
```
But, when running the script the distances available in *trip_distance* were different to the distances calculated for the same rows. I researched more, but I weren't to find an efficient way of getting the trip_distance.

Given that, since there are 9968 null values in a 1510722 rows set, I think it won't be a big bias. I would mention it to the teams and keep calculating what they need without these rows.

- **Final transformations**
  Later, we will see how the teams need the time duration data. For this purpose we will transform the start and end time to date_time, since it is loaded as object. Then, we will calculate the differences, get the time as seconds and transform it to minutes (to keep the most of the information available in the date).
```
cars_trips['start_time'] = pd.to_datetime(cars_trips['start_time'])
cars_trips['end_time'] = pd.to_datetime(cars_trips['end_time'])
cars_trips['date_diff'] = (cars_trips['end_time'] - cars_trips['start_time']).astype('timedelta64[s]')/60
```
