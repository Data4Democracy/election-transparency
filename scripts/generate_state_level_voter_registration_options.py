import pandas as pd
from urllib.request import urlopen
from bs4 import BeautifulSoup
import csv, sys, re, os

def populate_state_lookup(filename = '../data-raw/state_lookup_table.csv'):
    """populates a state lookup from the raw data csv

        Args:
            filename: The path/name of the csv file containing state data.

        Returns: a pandas dataframe containing the state name,
        state lookup code, and eac link, with the state name as the index
            
        """

    state_lookup=pd.DataFrame(columns=[['state_code','state_name','eac_link','state_reg_link']])
    with open(filename, newline='') as f:
        reader = csv.reader(f)
        try:
            next(reader)#skip the header row
            for row in reader:
                if len(row) >2:
                    state_row_data={'state_code': row[2],
                                    'state_name': row[1],
                                    'eac_link': 'https://www.eac.gov/voters/'+(str.lower(row[1])).replace(" ","-")+'-state-elections-office/',
                                    'state_reg_link':get_state_reg_link(row[1])}
                    if state_row_data['state_code']=='DC': #url to DC info doesn't include 'state'
                        state_row_data['eac_link']='https://www.eac.gov/voters/'+(str.lower(row[1])).replace(" ","-")+'-elections-office/'
                    state_lookup=state_lookup.append(state_row_data, ignore_index=True)
        except csv.Error as e:
            sys.exit('file {}, line {}: {}'.format(filename, reader.line_num, e))


    state_lookup.set_index(['state_name'], drop=False, inplace=True)
    return state_lookup

def get_state_reg_link(state_name):
    # add the state registration link from the eac state pages

    if (state_name == 'District of Columbia') | (state_name == 'Virginia'):  # url to DC info and Virginia info doesn't include 'state'
        url = 'https://www.eac.gov/voters/' + (str.lower(state_name)).replace(" ","-") + '-elections-office/'
    else:
        url = 'https://www.eac.gov/voters/' + (str.lower(state_name)).replace(" ", "-") + '-state-elections-office/'

    state_reg_link=""

    # look through the links in the main page block
    for div in (get_limited_text(url)).findAll("div", {"class": "block"}):
        links = div.findAll('a')
        # populate WA state data if it is missing
        if (state_name == 'Washington') & (len(links) < 1):
            state_reg_link = 'https://www.sos.wa.gov/elections/register.aspx'
        else:
            for a in links:
                if ('Register' in a.text):  # this is the link we want
                    state_reg_link = a['href']
                    break
    return state_reg_link


def get_limited_text(url):
    """opens url, gathers source code, and strips out scripts

        Args:
            url: The url to process.

        Returns:
            BeautifulSoup object parsed as html and stripped of scripts
        """
    html = urlopen(url).read()
    soup = BeautifulSoup(html, "html.parser")
    # we don't need the script elements to scrape data
    for script in soup(["script"]):
        script.extract()
    # return the page source (minus scripts)
    return soup


def populate_same_day_states(state_lookup,url= "https://ballotpedia.org/Same-day_voter_registration"):
    """uses the page at the url to identify states that permit same-day registration

        Args:
            url: page containing same day voter registration information
            
        Returns:
            pandas dataframe containing same day data with state name as an index
            and containing the following fields:
            state_name - full name of the state
            same_day_flag - true/false indicator
            same_day_note - any notes about same day registration
            same_day_description - for use in generating the .md file
            same_day_data_source - the url the data was generated from
        """
    references_regex = '\[.*?\]'
    state_list_span_id="States_with_same-day_registration"
    same_day_columns = ['state_name', 'same_day_flag', 'same_day_note', 'same_day_description' ,'same_day_data_source']
    default_data = {'same_day_flag': False, 'same_day_note': "", 'same_day_description':"",'same_day_data_source': url}

    #get page source from the url (without scripts)
    soup = get_limited_text(url)

    #empty data frame
    same_day_data=pd.DataFrame(columns=same_day_columns)

    #use the span id to find the tables containing state data
    same_day_lists_span = soup.find(id=state_list_span_id)

    #first list following span contains states that had implemented
    #same-day registration prior to the 2016 election
    states_list=same_day_lists_span.find_next('ul')
    for li in states_list.find_all('li'):
        state_name=re.sub(references_regex, '', li.text)
        state_row_data=[[ state_name,True,"implemented prior to 2016 election","Same-day voter registration available (Implemented prior to 2016 election). ",url]]
        state_row=pd.DataFrame(state_row_data,columns=same_day_columns,index=[state_name])
        same_day_data=same_day_data.append(state_row)

    #the second list following the span contains states that have implemented
    #same day registration after the 2016 election
    second_states_list=(same_day_lists_span.find_next('ul')).find_next('ul')
    for li in second_states_list.find_all('li'):
        state_name=re.sub(references_regex, '', li.text)
        state_row_data=[[state_name,True,"implemented after 2016 election","Same-day voter registration available (implemented after 2016 election). ",url]]
        state_row=pd.DataFrame(state_row_data,columns=same_day_columns,index=[state_name])
        same_day_data=same_day_data.append(state_row)

    #get all of the states (ballotpedia only lists same day registration states)
    state_lookup = populate_state_lookup()
    final_data = state_lookup.merge(same_day_data, left_index=True, right_index=True, how="left",
                                              copy=False, suffixes=['', '_x'])
    #drop the duplicate column
    #final_data.drop('state_name_x', axis=1, inplace=True)
    #fill the empty data
    final_data.fillna(default_data, axis=0, inplace=True)

    return final_data[same_day_columns]

def populate_online_reg_data(state_lookup, url="https://ballotpedia.org/Online_voter_registration"):
    """uses the page at the url to identify states that permit online registration

            Args:
                state_lookup: pandas dataframe containing state name as an index
                url: page containing online voter registration information

            Returns:
                pandas dataframe containing same day data with state name as an index
                and containing the following fields:
                state_name - full name of the state
                online_flag - true/false indicator
                online_note - any notes about same day registration
                online_description - for use in generating the .md file
                online_data_source - the url the data was generated from
            """
    online_columns = ['state_name', 'online_flag', 'online_note','online_description', 'online_data_source']
    default_data = {'same_day_flag': False, 'same_day_note': "none", 'online_description':"",'same_day_data_source': url}

    #get page source text (minus scripts)
    soup = get_limited_text(url)

    states_data=pd.DataFrame(columns=online_columns)

    #span identifying the states list area of the page
    online_span=soup.find(id='Online_registration_by_state')
    #state list is in the second table after the span
    online_table=(online_span.find_next('table')).find_next('table')
    rows = online_table.findChildren(['tr'])

    for row in rows:
        cells = row.findChildren('td')
        state_name=""
        online_flag=False
        online_note=""
        online_description=""
        for cell in cells:
            a_check=cell.find('a') #look for links

            if(a_check is not None):#there is a link
                yes_check='Yes_check' in str(a_check)
                no_check='Red_x' in str(a_check)
                state_check='Voting_in' in str(a_check)

                if(yes_check):
                    online_flag=True
                    online_description="Online voter registration is available. "
                if(no_check):
                    online_flag=False
                    online_description=""
                if(state_check):
                    state_name=a_check.text
            else: #there is no link
                if 'Enacted in' in str(cell): #cell contains online registration enactment dates
                    online_flag=True
                    online_description="Online voter registration is available ("+cell.text+"). "
                    online_note = cell.text

        if(state_name is not ""): #state data was populated
            state_row_data=[[state_name,online_flag,online_note,online_description,url]]
            state_row = pd.DataFrame(state_row_data, columns=online_columns, index=[state_name])
            states_data=states_data.append(state_row)
            states_data.fillna(default_data,axis=0,inplace=True)

    final_data = state_lookup.merge(states_data, left_index=True, right_index=True, how="left",
                                              copy=False, suffixes=['', '_x'])
    #drop the duplicate column
    final_data.drop('state_name_x', axis=1, inplace=True)
    #fill the empty data
    final_data.fillna(default_data, axis=0, inplace=True)

    return final_data[online_columns]

def populate_mail_in_data(state_lookup):
    """populates information about mail in voter registration
            
            args:
                state_lookup - pandas dataframe containing state name as an index
                
            Returns:
                pandas dataframe containing mail-in data with state name as an index
                and containing the following fields:
                state_name - full name of the state
                mail_flag - true/false indicator
                mail_note - any notes about same day registration
                mail_description - for use in generating the .md file
                mail_data_source - the url the data was generated from
                mail_form - the national mail in voter registration form
            """
    mail_columns=['state_name','mail_flag','mail_note','mail_data_source','mail_form']
    mail_data=pd.DataFrame(state_lookup['state_name'],columns=[['state_name']])
    mail_data['mail_form']='https://www.eac.gov/assets/1/6/Federal_Voter_Registration_6-25-14_ENG.pdf'
    mail_data['mail_flag']=True
    mail_data['mail_note']=""
    mail_data['mail_data_source']='https://www.eac.gov/voters/national-mail-voter-registration-form/'
    return mail_data[mail_columns]

def populate_all_voter_registration_data(state_lookup):
    """combines data from online, mail-in, and same-day registration
        and adds a markup column
            args:
                state_lookup - pandas data frame containing state name as an index
                
            Returns:
                pandas dataframe containing all voter registration data with state name as an index
                and containing the following fields:
                state_name - full name of the state
                same_day_flag - true/false indicator
                same_day_note - any notes about same day registration
                same_day_description - for use in generating the .md file
                same_day_data_source - the url the data was generated from
                online_flag - true/false indicator
                online_note - any notes about same day registration
                online_description - for use in generating the .md file
                online_data_source - the url the data was generated from
                mail_flag - true/false indicator
                mail_note - any notes about same day registration
                mail_description - for use in generating the .md file
                mail_data_source - the url the data was generated from
                mail_form - url reference to the national mail in voter registration form
                markup - markup text containing the descriptions for each registration type
            """

    #populate same-day voter registration data
    same_day_states_data=populate_same_day_states(state_lookup)

    #populate online voter registration data
    online_states_data=populate_online_reg_data(state_lookup)

    #populate mail in voter registration data
    mail_in_states_data=populate_mail_in_data(state_lookup)

    #merge the 3 data sources
    all_state_data=same_day_states_data.merge(online_states_data,left_index=True,right_index=True,how="left",suffixes=["","_ol"])
    all_state_data=all_state_data.merge(mail_in_states_data,left_index=True,right_index=True,how="left",suffixes=["","_mi"])
    all_state_data=state_lookup.merge(all_state_data,left_index=True,right_index=True,how="left",suffixes=["","_all"])
    all_state_data.drop('state_name_ol', axis=1, inplace=True)
    all_state_data.drop('state_name_mi',axis=1,inplace=True)
    all_state_data.drop('state_name_all',axis=1,inplace=True)

    all_state_data['markdown']="**["+all_state_data['state_name']+"]("+all_state_data['state_reg_link']+")**: "+ all_state_data['online_description'] + all_state_data['same_day_description']+"Mail in registration is available."
    all_state_data.dropna()
    return all_state_data

def write_out_registration_data(md_path="../data-dictionary/state-level/state_registration_options.md",csv_path="../data-raw/state_registration_options.csv"):
    """collects all the registration data and writes out to the markdown and comma-separated files

            Args:
                md_path: markdown file
                csv_path: csv file
            """
    state_lookup = populate_state_lookup()
    all_state_data=populate_all_voter_registration_data(state_lookup)

    if os.path.exists(md_path):
        md_file = open(md_path, "w")
        md_file.truncate()
    else:
        md_file = open(md_path, "w")
    md_file.write("# State Voter Registration Options\n\n")
    md_file.write("List of states with a description of the voter registration options available\n\n")
    for row in zip(all_state_data['markdown']):
        md_file.write(" + "+str(row[0])+"\n")
    md_file.close()

    if os.path.exists(csv_path):
        csv_file = open(csv_path, "w")
        csv_file.truncate()
    else:
        csv_file=open(csv_path,"w")
    all_state_data.to_csv(path_or_buf=csv_path,sep=",")
    csv_file.close()

if __name__ == "__main__":
    write_out_registration_data()