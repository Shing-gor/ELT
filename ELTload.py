# load_to_bigquery.py

import os
import pandas as pd
from google.cloud import bigquery

# an absolute path for the credentials

os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/Users/cheneason/Desktop/coding/ELT/elt-2025-30791e2bd7d5.json'

PROJECT_ID = 'elt-2025'
DATASET_ID = 'raw_olist'
DATA_PATH = 'data/' # kaggle dataset: olistbr/brazilian-ecommerce


def main():
    
    client = bigquery.Client(project=PROJECT_ID)
    print("Connected to BigQuery.")

    # 1. Create dataset in bigquery
    dataset_ref = f"{PROJECT_ID}.{DATASET_ID}"
    try:
        client.get_dataset(dataset_ref)
        print(f"Dataset {DATASET_ID} already exists.")
    except Exception:
        print(f"Dataset {DATASET_ID} not found, creating it...")

        dataset = bigquery.Dataset(dataset_ref)
        dataset.location = "australia-southeast1" 
        client.create_dataset(dataset, timeout=30)
        print(f"Created dataset {DATASET_ID}. \n {'='*20} \n")

    # 2. Find all CSV files, and load each to a BigQuery table
    csv_files = [f for f in os.listdir(DATA_PATH) if f.endswith('.csv')]
    for file_name in csv_files:

        df = pd.read_csv(os.path.join(DATA_PATH, file_name))

        table_id = file_name.replace('olist_', '').replace('_dataset.csv', '').replace('.', '')
        table_ref = f"{PROJECT_ID}.{DATASET_ID}.{table_id}"

        # Configure the load
        job_config = bigquery.LoadJobConfig(
            autodetect=True,
            write_disposition="WRITE_TRUNCATE", # Overwrite the table if it exists
        )
        
        # Load
        job = client.load_table_from_dataframe(df, table_ref, job_config=job_config)
        job.result()

        print(f"Successfully loaded {table_ref}.")
    
    print("All files loaded successfully.")

if __name__ == '__main__':
    main()