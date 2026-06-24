import requests
import pandas as pd

def fetch_nav_history_HDFC_100():
    url_live = " https://api.mfapi.in/mf/125497"

    print("Fetching the NAV history data from the API...")
    response = requests.get(url_live).json()
    print("Data fetched successfully!")

    data = response['data']

    # print(type(response))
    # print(type(data))
    # print(type(data[0]))

    df = pd.DataFrame(data)
    print("Saving the NAV history data to CSV file...")
    df.to_csv('data/processed/125497_sbi_small_cap_nav_history.csv', index=False)
    print("Data saved successfully!")

schemes = {
    "sbi_bluechip": 119551,
    "icici_bluechip": 120503,
    "nippon_large_cap": 118632,
    "axis_bluechip": 119092,
    "kotak_bluechip": 120841
}

for name, code in schemes.items():
    url = f"https://api.mfapi.in/mf/{code}"
    print(f"Fetching the NAV history data for {name} from the API...")
    response = requests.get(url).json()
    print("Data fetched successfully!")

    data = response['data']
    df = pd.DataFrame(data)
    print(f"Saving the NAV history data for {name} to CSV file...")
    df.to_csv(f'data/processed/{code}_{name}_nav_history.csv', index=False)
    print("Data saved successfully!")