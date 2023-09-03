# 🚗 Uber Data Engineering Project

Table of Content



## Objective

In this project, I designed and implemented an end-to-end data pipeline that consists of several stages:
1. Extracted data from NYC Trip Record Data website and loaded into Google Cloud Storage for further processing.
3. Transformed and modeled the data using fact and dimensional data modeling concepts using Python on Jupyter Notebook.
4. Using ETL concept, I orchestrated the data pipeline on Mage AI and loaded the transformed data into Google BigQuery.
5. Developed a dashboard on Looker Studio.

As this is a data engineering project, my emphasis is primarily on the engineering aspect with a lesser emphasis on analytics and dashboard development.

The sections below will explain additional details on the technologies and files utilized.

## Dataset

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
- Step 0: Cleaning and transformation - [Uber Data Engineering.ipynb](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Uber%20Data%20Engineering.ipynb)
- Step 1: Storage
- Step 2: ETL, Orchestration - Mage: [Extract](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_load_data.py), [Transform](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_transformation.py), [Load](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Mage/uber_gbq_load.py)
- Step 3: Analytics - [SQL script](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/sql_script.sql)
- Step 4: [Dashboard](https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/Uber_Dashboard.pdf)

### Data Modeling

Dataset is modeled based on the fact and dim data modeling concepts. 
![Data Model](https://user-images.githubusercontent.com/81607668/236725688-995b6049-26c1-440f-b523-7c6c10d507ba.png)

I used Python to create the new tables from the original CSV file.



### Running VM Instance

Start the SSH instance. Run the following commands to install necessary libraries.

```python
# Install Python and pip 
sudo apt-get install update

sudo apt-get install python3-distutils

sudo apt-get install python3-apt

sudo apt-get install wget

wget https://bootstrap.pypa.io/get-pip.py

sudo python3 get-pip.py

# Install Pandas
sudo pip3 install pandas
```

<img width="1436" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/3ce67bf1-b965-428e-8412-1efd3ce0c95f">

<img width="1438" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/ae8acb39-c66e-41f6-b81b-d1179121c0a4">

```python 
# Install Mage library
sudo pip3 install mage-ai

# Create new project
mage start demo_project
```

Source: [https://github.com/mage-ai/mage-ai#using-pip-or-conda](https://github.com/mage-ai/mage-ai#using-pip-or-conda)

<img width="901" alt="Screenshot 2023-09-03 at 3 43 27 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/2cfbdda6-4998-4dff-8c09-2f76c9b8a977">


Conduct orchestration in Mage
Extract, transform, load


Download credentials from API & Credentials
<img width="1438" alt="image" src="https://github.com/katiehuangx/data-engineering/assets/81607668/a1c0eb10-9969-4afd-8af7-cae9fb8d9a3a">

Run the pipelines in Mage AI

Fact and dim tables are created in Google BigQuery
<img width="1438" alt="Screenshot 2023-09-03 at 3 41 57 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/81106f7c-f912-462a-ba74-4b1e22120dc6">

## Analysis

<img width="1436" alt="Screenshot 2023-09-03 at 3 46 17 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/87fef0c1-f849-4b0e-8f2d-db68a989a06d">

<img width="1436" alt="Screenshot 2023-09-03 at 3 47 48 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/5f563142-9d18-4019-8499-7d9958b7ec05">

<img width="1436" alt="Screenshot 2023-09-03 at 3 48 52 PM" src="https://github.com/katiehuangx/data-engineering/assets/81607668/bf8d4dea-0915-48fb-a673-e5b3d3f37e3f">





## Dashboard

View the dashboard: https://lookerstudio.google.com/s/s2Cv9HZiz_I

![Dashoard Pg 1](https://user-images.githubusercontent.com/81607668/236729944-0a66f699-689e-4cbb-a12a-860abdef2cf4.png)

![Dashboard Pg 2](https://user-images.githubusercontent.com/81607668/236729954-cecba4a6-fc90-4944-b27f-cfb9473422bf.png)

***
