import pandas as pd
from sqlalchemy import create_engine
import argparse

def alert(lookback_days: int=None, threshold: float = 0.5):
    """
    Print to console list of organizations with a balance change greater than the threshold
    :param lookback_days: number of days to look back (the dbt model is already limited to the last 6 months so further back will not be available)
    :param threshold: threshold of balance
    :return: None

    Note: If this was a production environment, the database credentilas would be stored in environment variables and loaded inside the fuction or passed to the function as arguments
    """
    engine=create_engine('postgresql://test_user:test_password@localhost:5432/deel_db') # in a production environment, use environment variables to store the database credentials
    query=f'SELECT * FROM public_qa.dod_account_balance WHERE dod_balance_change_usd_pct >= {threshold}'
    if lookback_days:
        query += f" AND date >= (SELECT MAX(date) - INTERVAL '{lookback_days} days' from public_qa.dod_account_balance)"
    df = pd.read_sql_query(query, engine)
    if df.empty:
        print("No alerts to send")
    else:
        print(f"Organizations with a balance change greater than {threshold*100}% for the past {lookback_days} days:")
        print(df[["organization_id", "date", "dod_balance_change_usd_pct"]])
    engine.dispose()

if __name__ == "__main__":
    """
    Keeping it as simple as possible
    """
    parser = argparse.ArgumentParser(description='Alert on organizations with a balance change greater than a threshold')
    parser.add_argument('--lookback_days', type=int, help='Number of days to look back', default=7)
    parser.add_argument('--threshold', type=float, help='Threshold of balance change', default=0.5)
    args = parser.parse_args()
    alert(args.lookback_days, args.threshold)