# 🚗 Uber Data Engineering Project

## Objective

In this project, I designed and implemented an end-to-end data pipeline that consists of several stages:
1. Extracted data from NYC Trip Record Data website and loaded into Google Cloud Storage for further processing.
3. Transformed and modeled the data using fact and dimensional data modeling concepts using Python on Jupyter Notebook.
4. Using ETL concept, I orchestrated the data pipeline on Mage AI and loaded the transformed data into Google BigQuery.
5. Developed a dashboard on Looker Studio.

As this is a data engineering project, my emphasis is primarily on the engineering aspect with a lesser emphasis on analytics and dashboard development.

The sections below will explain additional details on the technologies and files utilized.

## Table of Content



## Dataset Used

This project uses the TLC Trip Record Data which include fields capturing pick-up and drop-off dates/times, pick-up and drop-off locations, trip distances, itemized fares, rate types, payment types, and driver-reported passenger counts.

More info about dataset can be found in the following links:
- Website: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- Data Dictionary: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
- Raw Data (CSV): https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/uber_data.csv

## Technologies

The following technologies are used to build this project:
- Language: Python, SQL
- Extraction and transformation: Jupyter Notebook, Google BigQuery
- Storage: Google Cloud Storage
- Orchestration: [Mage AI](https://www.mage.ai)
- Dashboard: [Looker Studio](https://lookerstudio.google.com)

## Data Pipeline Architecture

<img width="897" alt="Screenshot 2023-05-08 at 11 49 09 AM" src="https://user-images.githubusercontent.com/81607668/236729698-65e193bc-75ee-4ea6-9040-f33f5f2958cb.png">

Files in the following stages:
- Step 1: Cleaning and transformation - [Uber Data Engineering.ipynb](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Uber%20Data%20Engineering.ipynb)
- Step 2: Storage
- Step 3: ETL, Orchestration - Mage: [Extract](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_load_data.py), [Transform](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_transformation.py), [Load](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_gbq_load.py)
- Step 4: Analytics - [SQL script](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/sql_script.sql)
- Step 5: [Dashboard](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Uber_Dashboard.pdf)

## Data Modeling

Dataset is modeled based on the fact and dim data modeling concepts. 
![Data Model](https://user-images.githubusercontent.com/81607668/236725688-995b6049-26c1-440f-b523-7c6c10d507ba.png)

used Python to create the new tables from the original CSV file.

## Step 1: Cleaning and Transformation

In this step, I load the CSV file into Jupyter Notebook and performed cleaning and transformation of data before modeling them into fact and dim tables.

These are the cleaning and transformation tasks conducted:
1. Convert tpep_pickup_datetime and tpep_dropoff_datetime into datetime type
2. Remove duplicate and reset index

<img width="1436" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/83438f14-cae0-4278-8a33-5b536b487d90">


Once above is done, I create the following fact and dim tables.

<img width="1436" alt="Screenshot 2023-09-03 at 4 05 21 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/d1f961f5-dd28-4a5f-bfc9-1d739b85012c">

<img width="1436" alt="Screenshot 2023-09-03 at 4 05 29 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/3265a206-132f-457f-8323-2c6f681fbf60">

<img width="1436" alt="Screenshot 2023-09-03 at 4 05 35 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/a0555798-32a7-4c84-ac19-6336868dbf70">

<img width="1436" alt="Screenshot 2023-09-03 at 4 05 40 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/f7483917-b5eb-400f-a9ea-8ca138db6604">

<img width="1436" alt="Screenshot 2023-09-03 at 4 05 44 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/31fc871f-bdd3-4d2b-a0b5-04227188ec66">

<img width="1436" alt="Screenshot 2023-09-03 at 4 05 53 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/ec020455-bb23-4be5-b3f9-92200ccebaae">

## Step 2: Storage

<img width="1436" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/b776b804-a871-4a72-b1e5-b38b6d194bf3">

## Step 3: ETL / Orchestration

1. First, I start the SSH instance and run the following commands below to install the necessary libraries.

<img width="1436" alt="Screenshot 2023-09-03 at 4 10 39 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/1bd9af4c-61aa-4ea5-a485-81b6a6b5d446">

```python
# Install python and pip 
sudo apt-get install update

sudo apt-get install python3-distutils

sudo apt-get install python3-apt

sudo apt-get install wget

wget https://bootstrap.pypa.io/get-pip.py

sudo python3 get-pip.py

# Install Google Cloud Library
sudo pip3 install google-cloud

sudo pip3 install google-cloud-bigquery

# Install Pandas
sudo pip3 install pandas
```

<img width="1436" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/3ce67bf1-b965-428e-8412-1efd3ce0c95f">

2. Once completed, I run the commands below to install Mage AI library from the [Mage AI GitHub](https://github.com/mage-ai/mage-ai#using-pip-or-conda). Then, I create a new project named "uber_de_project".

```python 
# Install Mage library
sudo pip3 install mage-ai

# Create new project
mage start demo_project
```

<img width="901" alt="Screenshot 2023-09-03 at 3 43 27 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/2cfbdda6-4998-4dff-8c09-2f76c9b8a977">

3. Now, it's time to conduct the orchestration in Mage by accessing the external IP address in a new table. Link format is: `<external IP address>:<port number>`.

Then, I create a new pipeline:
- Extract: [load_uber_data](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_load_data.py)
- Transform: [transform_uber](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_transformation.py)
- Load: [load_gbq](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_load_data.py)

<img width="1438" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/ae8acb39-c66e-41f6-b81b-d1179121c0a4">

Before running the Load pipeline, I download credentials from API & Credentials and update them in the `io_config.yaml` file in the same pipeline to authorize access for data to be loaded into Google BigQuery.

## Step 4: Analytics

Upon running the **Load** pipeline in Mage AI, the fact and dim tables are created in Google BigQuery.

<img width="1438" alt="Screenshot 2023-09-03 at 3 41 57 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/81106f7c-f912-462a-ba74-4b1e22120dc6">

These are the further analysis I ran:
1. Find the top 10 pickup locations based on the number of trips
<img width="1436" alt="Screenshot 2023-09-03 at 3 46 17 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/87fef0c1-f849-4b0e-8f2d-db68a989a06d">

2. Find the total number of trips by passenger count:
<img width="1436" alt="Screenshot 2023-09-03 at 3 47 48 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/5f563142-9d18-4019-8499-7d9958b7ec05">

3. Find the average fare amount by hour of the day:
<img width="1436" alt="Screenshot 2023-09-03 at 3 48 52 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/bf8d4dea-0915-48fb-a673-e5b3d3f37e3f">

## Step 5: Dashboard

Once the analysis are completed, I load the relevant tables into Looker Studio and developed a dashboard, which you can view [here](https://lookerstudio.google.com/s/s2Cv9HZiz_I).

![Dashoard Pg 1](https://user-images.githubusercontent.com/81607668/236729944-0a66f699-689e-4cbb-a12a-860abdef2cf4.png)

![Dashboard Pg 2](https://user-images.githubusercontent.com/81607668/236729954-cecba4a6-fc90-4944-b27f-cfb9473422bf.png)

***
