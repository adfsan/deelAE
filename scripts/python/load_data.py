# Scrappy script to load data from a csv file into a database
import pandas as pd
from sqlalchemy import create_engine

engine=create_engine('postgresql://test_user:test_password@localhost:5432/deel_db') # in a production environment, use environment variables to store the database credentials
print("Loading raw invoices into the database")
invoices_df = pd.read_csv('./raw_data/invoices.csv')
invoices_df.columns = [col.lower() for col in invoices_df.columns]
invoices_df.to_sql('raw_invoices', engine, schema='raw', index=False, if_exists='replace')
print("Loading raw organizations into the database")
organizations_df = pd.read_csv('./raw_data/organizations.csv')
organizations_df.columns = [col.lower() for col in organizations_df.columns]
organizations_df.to_sql('raw_organizations', engine, schema = 'raw', index=False, if_exists='replace')
print("Data loaded successfully, shutting off connection")
engine.dispose()