# 🚗 Uber Data Engineering End-to-End Project

## Objective

In this project, I designed and implemented an end-to-end data pipeline that consists of several stages:
1. Extracted data from NYC Trip Record Data website and loaded into Google Cloud Storage for further processing.
3. Transformed and modeled the data using fact and dimensional data modeling concepts using Python on Jupyter Notebook.
4. Using ETL concept, I orchestrated the data pipeline on Mage AI and loaded the transformed data into Google BigQuery.
5. Developed a dashboard on Looker Studio.

As this is a data engineering project, my emphasis is primarily on the engineering aspect with a lesser emphasis on analytics and dashboard development.

The sections below will explain additional details on the technologies and files utilized.

## Table of Content

- [Dataset Used](#dataset-used)
- [Technologies](technologies)
- [Data Pipeline Architecture](#data-pipeline-architecture)
- [Date Modeling](#data-modeling)
- [Step 1: Cleaning and Transformation](#step-1-cleaning-and-transformation)
- [Step 2: Storage](#step-2-storage)
- [Step 3: ETL / Orchestration](#step-3-etl--orchestration)
- [Step 4: Analytics](#step-4-analytics)
- [Step 5: Dashboard](#step-5-dashboard)

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

The datasets are designed using the principles of fact and dim data modeling concepts. 

![Data Model](https://user-images.githubusercontent.com/81607668/236725688-995b6049-26c1-440f-b523-7c6c10d507ba.png)

## Step 1: Cleaning and Transformation

In this step, I loaded the CSV file into Jupyter Notebook and carried out data cleaning and transformation activities prior to organizing them into fact and dim tables.

Here's the specific cleaning and transformation tasks that were performed:
1. Converted `tpep_pickup_datetime` and `tpep_dropoff_datetime` columns into datetime format.
2. Removed duplicates and reset the index.

Link to the script: [https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Uber%20Data%20Engineering.ipynb](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Uber%20Data%20Engineering.ipynb)

<img width="1436" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/83438f14-cae0-4278-8a33-5b536b487d90">

After completing the above steps, I created the following fact and dimension tables below:

<img width="1436" alt="Screenshot 2023-09-03 at 4 05 21 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/d1f961f5-dd28-4a5f-bfc9-1d739b85012c">


<img width="1436" alt="Screenshot 2023-09-03 at 4 05 29 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/3265a206-132f-457f-8323-2c6f681fbf60">


<img width="1436" alt="Screenshot 2023-09-03 at 4 05 35 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/a0555798-32a7-4c84-ac19-6336868dbf70">


<img width="1436" alt="Screenshot 2023-09-03 at 4 05 40 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/f7483917-b5eb-400f-a9ea-8ca138db6604">


<img width="1436" alt="Screenshot 2023-09-03 at 4 05 44 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/31fc871f-bdd3-4d2b-a0b5-04227188ec66">


<img width="1436" alt="Screenshot 2023-09-03 at 4 05 53 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/ec020455-bb23-4be5-b3f9-92200ccebaae">

## Step 2: Storage

<img width="1436" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/b776b804-a871-4a72-b1e5-b38b6d194bf3">

## Step 3: ETL / Orchestration

1. Begin by launching the SSH instance and running the following commands below to install the required libraries.

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

2. After that, I install the Mage AI library from the [Mage AI GitHub](https://github.com/mage-ai/mage-ai#using-pip-or-conda). Then, I create a new project called "uber_de_project".

```python 
# Install Mage library
sudo pip3 install mage-ai

# Create new project
mage start demo_project
```

<img width="901" alt="Screenshot 2023-09-03 at 3 43 27 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/2cfbdda6-4998-4dff-8c09-2f76c9b8a977">

3. Next, I conduct orchestration in Mage by accessing the external IP address through a new tab. The link format is: `<external IP address>:<port number>`.

After that, I create a new pipeline with the following stages:
- Extract: [load_uber_data](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_load_data.py)
- Transform: [transform_uber](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_transformation.py)
- Load: [load_gbq](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_load_data.py)

<img width="1438" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/ae8acb39-c66e-41f6-b81b-d1179121c0a4">

Before executing the Load pipeline, I download credentials from Google API & Credentials and then update them accordingly in the `io_config.yaml` file within the same pipeline. This step is essential for granting authorization to access and load data into Google BigQuery.

## Step 4: Analytics

After running the Load pipeline in Mage, the fact and dim tables are generated in Google BigQuery.

<img width="1438" alt="Screenshot 2023-09-03 at 3 41 57 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/81106f7c-f912-462a-ba74-4b1e22120dc6">

Here's the additional analyses I performed:
1. Find the top 10 pickup locations based on the number of trips
<img width="1436" alt="Screenshot 2023-09-03 at 3 46 17 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/87fef0c1-f849-4b0e-8f2d-db68a989a06d">

2. Find the total number of trips by passenger count:
<img width="1436" alt="Screenshot 2023-09-03 at 3 47 48 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/5f563142-9d18-4019-8499-7d9958b7ec05">

3. Find the average fare amount by hour of the day:
<img width="1436" alt="Screenshot 2023-09-03 at 3 48 52 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/bf8d4dea-0915-48fb-a673-e5b3d3f37e3f">

## Step 5: Dashboard

After completing the analysis, I loaded the relevant tables into Looker Studio and created a dashboard, which you can view [here](https://lookerstudio.google.com/s/s2Cv9HZiz_I).

![Dashoard Pg 1](https://user-images.githubusercontent.com/81607668/236729944-0a66f699-689e-4cbb-a12a-860abdef2cf4.png)

![Dashboard Pg 2](https://user-images.githubusercontent.com/81607668/236729954-cecba4a6-fc90-4944-b27f-cfb9473422bf.png)

***
