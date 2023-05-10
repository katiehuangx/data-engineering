-- Create analytics_table
CREATE OR REPLACE TABLE `uber-project-385706.uber_data_engineering.analytics_table` AS (
SELECT 
  f.trip_id,
  f.VendorID,
  d.tpep_pickup_datetime,
  d.tpep_dropoff_datetime,
  p.passenger_count,
  t.trip_distance,
  r.rate_code_name,
  pick.pickup_latitude,
  pick.pickup_longitude,
  drop.dropoff_latitude,
  drop.dropoff_longitude,
  pay.payment_type_name,
  f.fare_amount,
  f.extra,
  f.mta_tax,
  f.tip_amount,
  f.tolls_amount,
  f.improvement_surcharge,
  f.total_amount
FROM `uber-project-385706.uber_data_engineering.fact_table` AS f
INNER JOIN `uber-project-385706.uber_data_engineering.datetime_dim` AS d  
  ON f.datetime_id = d.datetime_id
INNER JOIN `uber-project-385706.uber_data_engineering.passenger_count_dim` AS p
  ON p.passenger_count_id = f.passenger_count_id  
INNER JOIN `uber-project-385706.uber_data_engineering.trip_distance_dim` AS t
  ON t.trip_distance_id = f.trip_distance_id  
INNER JOIN `uber-project-385706.uber_data_engineering.rate_code_dim` AS r 
  ON r.rate_code_id = f.rate_code_id  
INNER JOIN `uber-project-385706.uber_data_engineering.pickup_location_dim` AS pick
 ON pick.pickup_location_id = f.pickup_location_id
INNER JOIN `uber-project-385706.uber_data_engineering.dropoff_location_dim` AS drop
  ON drop.dropoff_location_id = f.dropoff_location_id
INNER JOIN `uber-project-385706.uber_data_engineering.payment_type_dim` AS pay
  ON pay.payment_type_id = f.payment_type_id
);

-- ASSIGNMENT QUESTIONS
-- Find the top 10 pickup location based on the number of trips
SELECT 
  pickup_latitude, 
  pickup_longitude, 
  COUNT(*) AS pickup_location_count
FROM `uber-project-385706.uber_data_engineering.analytics_table`
GROUP BY pickup_latitude, pickup_longitude
ORDER BY pickup_location_count DESC
LIMIT 10;

-- Find the total number of trips by passenger count
SELECT 
  p.passenger_count, 
  COUNT(f.trip_id) AS trip_count
FROM `uber-project-385706.uber_data_engineering.fact_table` AS f
LEFT JOIN `uber-project-385706.uber_data_engineering.passenger_count_dim` AS p
  ON f.passenger_count_id = p.passenger_count_id
GROUP BY p.passenger_count
ORDER BY trip_count DESC;

-- Find the average fare amount by hour of the day
SELECT 
  d.pickup_hour, 
  AVG(f.fare_amount) AS avg_fare
FROM `uber-project-385706.uber_data_engineering.fact_table` AS f
LEFT JOIN `uber-project-385706.uber_data_engineering.datetime_dim` AS d
  ON f.datetime_id = d.datetime_id
GROUP BY d.pickup_hour
ORDER BY d.pickup_hour ASC;
