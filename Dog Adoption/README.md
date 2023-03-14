# Dog Adoption Project

## Objective



## Tools & Technologies
- Database: PostgreSQL
- Language: Python

## Architecture

<img width="819" alt="image" src="https://user-images.githubusercontent.com/81607668/224919216-85d6aaed-4247-4943-9700-2d198187385f.png">

Data flow
1. Data is extracted from [Kaggle](https://www.kaggle.com/datasets/whenamancodes/dog-adoption) and saved locally.
2. On [dog_adoption.ipynb script](https://github.com/katiehuangx/data-engineering/blob/main/Dog%20Adoption/dog_adoption.ipynb), connection to PostgreSQL is initiated and database is created with auto-commit being run. 
3. Tables are created with the appropriate columns and data types. 
4. Data is fed into the newly created tables.


