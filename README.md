End-to-End E-commerce ELT Pipeline with BigQuery, dbt, and Python
This project demonstrates a complete, modern ELT (Extract, Load, Transform) pipeline built to process e-commerce data. Raw data from the Olist Brazilian E-commerce dataset is extracted and loaded into Google BigQuery, transformed into an analysis-ready star schema using dbt, and is ready for consumption by BI tools like Looker Studio.

Tech Stack
Data Ingestion: Python (Pandas, google-cloud-bigquery)

Data Warehouse: Google BigQuery

Data Transformation: dbt (data build tool)

Virtualization: Python venv

Version Control: Git & GitHub

Project Architecture
The pipeline follows a modern ELT paradigm. Raw data is first loaded into the data warehouse with minimal changes, and all complex transformations are then performed in-database using dbt.

Extract & Load: A Python script (load_to_bigquery.py) reads raw .csv files from a local data/ directory. It connects to Google BigQuery, creates a raw_olist dataset, and uploads the data into corresponding tables. This process is designed to be idempotent and repeatable.

Transform: dbt connects to the BigQuery warehouse and runs a series of SQL-based models to clean, structure, and aggregate the raw data.

Staging: Raw tables are lightly cleaned, columns are renamed, and data types are cast.

Marts: The staging models are joined and aggregated to build a final star schema consisting of a central fact table (fct_orders) and several dimension tables (dim_customers, dim_products).

Testing & Documentation: dbt's built-in features are used to test the data for quality (e.g., checking for nulls, unique keys, and referential integrity) and to automatically generate documentation for the entire project.

Getting Started
Prerequisites
Python 3.8+ and pip

A Google Cloud Platform (GCP) account with billing enabled.

The gcloud CLI installed and authenticated (optional, but recommended).

dbt Core installed (pip install dbt-bigquery).

Setup
Clone the Repository:

git clone [https://github.com/Shing-gor/ELT.git](https://github.com/Shing-gor/ELT.git)
cd ELT

Download the Data:
This project uses the Brazilian E-Commerce Public Dataset by Olist.

Download it from the official Kaggle page.

Unzip the archive.

Create a folder named data/ in the root of this project.

Place all the olist_..._dataset.csv files inside this data/ folder.

Set Up Python Environment:

python3 -m venv venv
source venv/bin/activate
# Consider creating a requirements.txt file with necessary packages
pip install pandas google-cloud-bigquery "dbt-bigquery>=1.1.0"

Google Cloud Setup:

Create a new GCP Project.

Enable the BigQuery API.

Create a Service Account with the "BigQuery Admin" role.

Download the JSON key for the service account and place it in the root of this project folder.

Important: Update the os.environ['GOOGLE_APPLICATION_CREDENTIALS'] path in load_to_bigquery.py to point to your JSON key file.

Configure dbt:

Navigate to your home directory's .dbt/ folder and configure your profiles.yml to connect to your BigQuery project. Use the service_account method and provide the path to your JSON key.

# Example profiles.yml configuration
olist_dbt:
  target: dev
  outputs:
    dev:
      type: bigquery
      method: service_account
      project: your-gcp-project-id
      dataset: analytics_olist # This is the target dataset for your models
      threads: 4
      keyfile: /path/to/your/service-account-key.json
      location: australia-southeast1

How to Run the Pipeline
Execute these commands from the root of the project directory.

Load the Raw Data:
This script will create the raw_olist dataset in BigQuery and upload all the CSV files from the /data directory.

python3 load_to_bigquery.py

Run the dbt Transformations:
Navigate into the dbt project folder and run the models. This will build the staging and mart tables in your analytics_olist dataset.

cd olist_dbt
dbt run

Test the Data Quality:
Execute the data tests defined in the schema.yml files.

dbt test

Project Structure
.
├── .gitignore
├── README.md
├── data/
│   └── olist_..._dataset.csv (raw data files)
├── load_to_bigquery.py
└── olist_dbt/
    ├── dbt_project.yml
    ├── packages.yml
    └── models/
        ├── marts/
        │   ├── dim_customers.sql
        │   ├── dim_products.sql
        │   └── fct_orders.sql
        └── staging/
            ├── schema.yml
            ├── stg_customers.sql
            └── ... (other staging models)
