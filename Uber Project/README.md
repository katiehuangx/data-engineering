# 🚗 Uber Data Engineering Project

## Objective

In this project, I designed and implemented an end-to-end data pipeline that consists of several stages:
1. Extracted data from NYC Trip Record Data website and loaded it into **Google Cloud Storage** for further processing.
2. Transformed the data using **Python** in **Jupyter Notebook**.
3. Modeled the data using fact and dimensional data modeling concepts.
4. Orchestrated the data pipeline on **Mage** and loaded the transformed data into **Google BigQuery**.
5. Developed a dashboard on **Looker Studio**.

## Technologies

To implement this data pipeline, I leveraged a range of technologies, including:
- Programming language: Python, SQL
- Extraction and transformation: Jupyter Notebook, Google BigQuery
- Storage: Google Storage
- Orchestration: [Mage](https://www.mage.ai)
- Dashboard: [Looker Studio](https://lookerstudio.google.com)

## Dataset Used

TLC Trip Record Data Yellow and green taxi trip records include fields capturing pick-up and drop-off dates/times, pick-up and drop-off locations, trip distances, itemized fares, rate types, payment types, and driver-reported passenger counts.

More info about dataset can be found here:
- Website: https://www.nyc.gov/site/tlc/about/tlc-trip-record-data.page
- Data Dictionary: https://www.nyc.gov/assets/tlc/downloads/pdf/data_dictionary_trip_records_yellow.pdf
- Raw Data: https://github.com/katiehuangx/data-engineering/blob/main/Uber%20Project/uber_data.csv

## Data Pipeline

<img width="897" alt="Screenshot 2023-05-08 at 11 49 09 AM" src="https://user-images.githubusercontent.com/81607668/236729698-65e193bc-75ee-4ea6-9040-f33f5f2958cb.png">

## Data Modelling

![Data Model](https://user-images.githubusercontent.com/81607668/236725688-995b6049-26c1-440f-b523-7c6c10d507ba.png)

## Dashboard

<img width="479" alt="Screenshot 2023-05-08 at 11 50 55 AM" src="https://user-images.githubusercontent.com/81607668/236729944-0a66f699-689e-4cbb-a12a-860abdef2cf4.png">

<img width="477" alt="Screenshot 2023-05-08 at 11 51 05 AM" src="https://user-images.githubusercontent.com/81607668/236729954-cecba4a6-fc90-4944-b27f-cfb9473422bf.png">

***
