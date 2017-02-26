# This script will scrape data from the http://uselectionatlas.org/ website.
# It produces a .csv for each state and is then merged using unix commands.
# It is then cleaned with the Format_Election_Data_19**.ipynb notebook under the Python-Notebooks directory
# Resulting in datasets on dataworld for:
# PresidentialElectionResults1992.csv & PresidentialElectionResults1996.csv

# import modules
import requests
from bs4 import BeautifulSoup
import pandas as pd
import csv

# 'main' function, call each applicable page and scrape necessary data
def run_script(url):

    print("Scraping from..." + url)
    # Scrape the HTML at the url
    r = requests.get(url)

    # Turn the HTML into a Beautiful Soup object
    soup = BeautifulSoup(r.text, 'lxml')

    # Create an object of the second object that is class=grid listing table
    div = soup.findAll(class_='info')

    county_name = []
    candidate = []
    candidate_pct = []
    votes = []

    for table in div[0].find_all('table'):
        for row in table.find_all('tr'):
            col = row.find_all('td')
            if len(col) == 5:
                # print(col[0].text.strip())
                county_name.append(col[0].text.strip())
                candidate.append(col[1].text.strip())
                candidate_pct.append(col[2].text.strip())
                votes.append(col[3].text.strip())
            else:
                candidate.append(col[0].text.strip())
                candidate_pct.append(col[1].text.strip())
                votes.append(col[2].text.strip())

    # Create a variable of the value of the columns
    columns = {'candidate': candidate, 'candidate_pct': candidate_pct, 'votes': votes}

    df = pd.DataFrame(columns)
    # this makes it easier when I screw something up :)
    df2 = df

    # create a loop to apply counties to the correct rows, a county per 4 rows
    # initialize vars for counts
    x = 0
    n = 3
    county = 0

    # this could have been done better...I'm feeling lazy
    while county < (len(df2)) / 4:
        df2.ix[x:n, 'County'] = county_name[county]
        x = x + 4
        n = n + 4
        county = county + 1

    # Pull state name from page header
    state = soup.findAll(class_='header')
    header = state[0].text.strip()
    stateName = header[(header.find("-") + 2):]

    print("State Name is..." + stateName)

    # import states dict and convert to a dictionary
    df3 = pd.read_csv("StatesTable.csv")
    states = df3.set_index('StateName').T.to_dict('list')

    # get the matching value on StateAbbr join key
    stateAbbr = states[stateName]

    # funky way to convert dict value to string
    stateAbbrStr, = stateAbbr

    # apply to df2
    df2["StateAbbr"] = stateAbbrStr

    # define the out file name
    file_name_out = stateAbbrStr + "_92.csv"

    print("Writing to CSV...")

    df.to_csv(file_name_out, index=False)

import csv

# import a list of state-county fips so scraper will call only those fips
fips = []
with open('fips_codes.csv', 'rU') as f:
    reader = csv.reader(f)
    for row in reader:
        fips.append(row)

# build the URL to scrape, then run_script
for fips_cd in fips:
    fipscd = fips_cd[0]
    print("fips is:" + str(fips_cd))
    url = 'http://uselectionatlas.org/RESULTS/datagraph.php?year=1992&fips=' + fipscd
    run_script(url)

