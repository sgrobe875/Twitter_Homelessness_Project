import pandas as pd
import json
import datetime
from collections import Counter
import warnings
warnings.filterwarnings("ignore")


print('Beginning')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()



def read_geotagged_data(filepath):
    geotagged_tweets = pd.read_csv(filepath, engine = 'c', encoding = 'latin1')
    
    # this isn't necessary for the new data
    if filepath != 'data/tweets.csv':
        for index, geodict in enumerate(geotagged_tweets['geo']):
            try:
                thisdict = json.loads(geodict)
                geotagged_tweets.at[index, 'geo'] = thisdict
                geotagged_tweets.at[index, 'place_type'] = thisdict['place_type']
                geotagged_tweets.at[index, 'full_name'] = thisdict['full_name']
                geotagged_tweets.at[index, 'country'] = thisdict['country']
                
            except:
                pass
        
    return geotagged_tweets




# read in the data
# geotagged_tweets = read_geotagged_data('data/all_geotagged_tweets.csv')
geotagged_tweets = read_geotagged_data('data/tweets.csv')

# take subset for debugging purposes!!
# geotagged_tweets = geotagged_tweets.iloc[:1000][:]

# remove the "place_" prefix from location-related columns
cols = list(geotagged_tweets.columns)
for col in cols:
    if 'place_' in col:
        geotagged_tweets.rename(columns={col: col[6:]}, inplace=True)

# initialize columns (to be filled in in a moment!)
geotagged_tweets['state'] = ''
geotagged_tweets['year'] = ''


# read in state abbreviations dataframe
state_abbrevs = pd.read_csv('data/state_abbrevs.csv')

# get list of state two letter abbreviations
states = state_abbrevs['abbrev'].tolist()

# ensure that all entries in the state column of the tweet dataframe are strings
# geotagged_tweets['state'] = geotagged_tweets['state'].apply(str)
geotagged_tweets['full_name'] = geotagged_tweets['full_name'].apply(str)


# sanity check
print('Before:')
print(geotagged_tweets['state'].unique())
print()


# First try just taking the last two letters, since that looks like it'll fix it
# in a lot cases
# for i in range(len(geotagged_tweets)):
#     if len(geotagged_tweets.loc[i]['state']) > 2:
#         test = geotagged_tweets.loc[i]['state'][-2:]
#         # if last two letters match a state abbreviation, set the state to just
#         # being those two letters
#         if (test in states):
#             geotagged_tweets.at[i, 'state'] = test

for i in range(len(geotagged_tweets)):
    test = geotagged_tweets.loc[i]['full_name'][-5:-3]
    # if last two letters match a state abbreviation, set the state to just
    # being those two letters
    if (test in states):
        geotagged_tweets.at[i, 'state'] = test


# sanity check
print('After Step 1:')
print(geotagged_tweets['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()


    
# now get list of all "state, USA" formats
# names = state_abbrevs['full_name'].tolist()
# for i in range(len(geotagged_tweets)):
#     # check if the state value matches any of our state, USA entries
#     if len(geotagged_tweets.loc[i]['state']) > 2:
#         curr = geotagged_tweets.loc[i]['state']
#         if (curr in names):
#             for j in range(len(state_abbrevs)):
#                 # if it does, set to the corresponding abbrev from the data frame
#                 if state_abbrevs.loc[j]['full_name'] == curr:
#                     geotagged_tweets.at[i, 'state'] = state_abbrevs.loc[j]['abbrev']
                    
#         else:
#             geotagged_tweets.at[i, 'state'] = 'Unknown'

names = state_abbrevs['full_name'].tolist()
for i in range(len(geotagged_tweets)):
    # check if the state value matches any of our state, USA entries
    # but only check those that haven't been fixed yet!
    if len(geotagged_tweets.loc[i]['state']) < 2:
        curr = geotagged_tweets.loc[i]['full_name'][2:-2]
        if (curr in names):
            for j in range(len(state_abbrevs)):
                # if it does, set to the corresponding abbrev from the data frame
                if state_abbrevs.loc[j]['full_name'] == curr:
                    geotagged_tweets.at[i, 'state'] = state_abbrevs.loc[j]['abbrev']
                    
        else:
            geotagged_tweets.at[i, 'state'] = 'Unknown'


    

    
# guess what! more sanity checks!
print('After Step 2:')
print(geotagged_tweets['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()



# Now work on the unknowns to see what else we can fix!

with open('data/states_expanded.json','r') as f:
    more_states = json.load(f)
    
locations = list(more_states.keys())

for i in range(len(geotagged_tweets)):
    # only move forward with those that have unknown states
    if geotagged_tweets.iloc[i]['state'] == 'Unknown':
        geo = geotagged_tweets.iloc[i]['geo']
        
        # if geo isn't a dictionary yet, make it one
        try:
            geo = geo.replace("'",'"')
            geo = json.loads(geo)
            
        # if it's already a dictionary, don't do anything
        except (AttributeError, json.JSONDecodeError):
            pass
        
        
        try:
            # get the full name data, if it exists
            curr = geo['full_name']
            
            # loop through and look for a connection to the JSON data            
            for loc in locations:
                if loc in curr:
                    # if found, overwrite to the corresponding state
                    geotagged_tweets.at[i, 'state'] = more_states[loc]
                    break
                
        # if full name doesn't exist, move on and do nothing               
        except:
            pass
        
        





print('Before fixing years:')
print(geotagged_tweets['year'].unique())
print()



# Finally, fix the years
# geotagged_tweets['year'] = geotagged_tweets['year'].apply(str)
# for i in range(len(geotagged_tweets)):
#     geotagged_tweets.at[i, 'year'] = geotagged_tweets.loc[i]['year'][:4]
    
#     # this is a little brute force-y, but oh well:
#     if geotagged_tweets.loc[i]['year'] == 'nan' or geotagged_tweets.loc[i]['year'] == '[]':
#         geotagged_tweets.at[i, 'year'] = 'Unknown'


# force all values to strings
geotagged_tweets['tweet_created_at'] = geotagged_tweets['tweet_created_at'].apply(str)

# loop through all tweets
for i in range(len(geotagged_tweets)):
    # check that they are in the proper format for this (i.e., they contain a date)
    if '-' in geotagged_tweets.loc[i]['tweet_created_at']:
        # set year to equal the first 4 characters (which is the 4 digit year within the date)
        geotagged_tweets.at[i, 'year'] = geotagged_tweets.loc[i]['tweet_created_at'][:4]
    # if not, then we can't set the year
    else:
        geotagged_tweets.at[i, 'year'] = 'Unknown'




print('After fixing years:')
print(geotagged_tweets['year'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()
    
    
    
geotagged_tweets.to_csv('data/tweets_cleaned.csv')


print('Done!')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()
