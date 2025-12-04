import csv
import requests

def get_contacts_public_csv(csv_url: str):
    response = requests.get(csv_url)
    response.raise_for_status()

    decoded = response.content.decode("utf-8").splitlines()
    reader = csv.reader(decoded)

    next(reader)  # skip header

    contacts = {}
    for row in reader:
        first_name = row[0].lower()
        email = row[3]
        contacts[first_name] = email 

    return contacts


if __name__ == "__main__":
    csv_url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vTQgbznsuqeyHxSntiPhP9CQNnk35ny8JU-kL8pC_-8PSDp5xNF9K6FFlL2YP1e_Jv-NwBPdDrGUhz7/pub?gid=0&single=true&output=csv"
    print(get_contacts_public_csv(csv_url))
