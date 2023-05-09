# 🚗 Uber Data Engineering Project

## Objective

In this project, I designed and implemented an end-to-end data pipeline that consists of several stages:
1. Extracted data from NYC Trip Record Data website and loaded it into Google Cloud Storage for further processing.
3. Transformed and modeled the data using fact and dimensional data modeling concepts using Python on Jupyter Notebook.
4. Using ETL, I orchestrated the data pipeline on Mage and loaded the transformed data into Google BigQuery.
5. Developed a dashboard on Looker Studio.

## Technologies

The following technologies are used to build this project:
- Language: Python, SQL
- Extraction and transformation: Jupyter Notebook, Google BigQuery
- Storage: Google Cloud Storage
- Orchestration: [Mage](https://www.mage.ai)
- Dashboard: [Looker Studio](https://lookerstudio.google.com)

## Dataset Used

This project uses the TLC Trip Record Data which include fields capturing pick-up and drop-off dates/times, pick-up and drop-off locations, trip distances, itemized fares, rate types, payment types, and driver-reported passenger counts.

More info about dataset can be found here:
- Website: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- Data Dictionary: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
- Raw Data: https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/uber_data.csv

## Data Pipeline Architecture

<img width="897" alt="Screenshot 2023-05-08 at 11 49 09 AM" src="https://user-images.githubusercontent.com/81607668/236729698-65e193bc-75ee-4ea6-9040-f33f5f2958cb.png">

## Data Modelling

![Data Model](https://user-images.githubusercontent.com/81607668/236725688-995b6049-26c1-440f-b523-7c6c10d507ba.png)

## Dashboard

View the dashboard: https://lookerstudio.google.com/s/s2Cv9HZiz_I

![Dashoard Pg 1](https://user-images.githubusercontent.com/81607668/236729944-0a66f699-689e-4cbb-a12a-860abdef2cf4.png)

![Dashboard Pg 2](https://user-images.githubusercontent.com/81607668/236729954-cecba4a6-fc90-4944-b27f-cfb9473422bf.png)

***
