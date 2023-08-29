# 🐶 Dog Adoption Project

## Objective

This project creates and builds data models and deploy database for the dog adoption data. 

## Technologies
- Database: PostgreSQL
- Language: Python

## Data Architecture

<img width="591" alt="image" src="https://user-images.githubusercontent.com/81607668/237030996-a92947af-5e9b-42be-8a34-9b4073f6e7ef.png">

1. Data is extracted from [Kaggle](https://www.kaggle.com/datasets/whenamancodes/dog-adoption) and saved locally.
2. The [dog_adoption.ipynb script](https://github.com/katiehuangx/data-engineering/blob/main/Dog%20Adoption/dog_adoption_clean.ipynb) initiates a connection to PostgreSQL and creates the database with auto-commit being run. 
3. Tables are created with the appropriate columns and data types. 
4. Data is fed into the newly created tables.


