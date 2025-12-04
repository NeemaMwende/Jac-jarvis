import csv
import requests

def get_email_from_contacts(name: str) -> str:
    csv_url = "https://docs.google.com/spreadsheets/d/e/2PACX-1vTQgbznsuqeyHxSntiPhP9CQNnk35ny8JU-kL8pC_-8PSDp5xNF9K6FFlL2YP1e_Jv-NwBPdDrGUhz7/pub?gid=0&single=true&output=csv"

    response = requests.get(csv_url)
    response.raise_for_status()

    decoded = response.content.decode("utf-8", errors="replace").splitlines()
    reader = csv.reader(decoded)
    next(reader)  # skip header

    name = name.strip().lower()
    for row in reader:
        first_name = row[0].strip().lower()
        email = row[3].strip()
        if first_name == name:
            return email

    return f"No email found for {name}"

if __name__ == "__main__":
    print(get_email_from_contacts("catherine"))