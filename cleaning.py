import pandas as pd
import json
import datetime
from collections import Counter



print('Beginning')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()



def read_geotagged_data(filepath):
    geotagged_tweets = pd.read_csv(filepath, engine = 'c', encoding = 'latin1')
    
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
geotagged_tweets = read_geotagged_data('data/all_geotagged_tweets.csv')







# use a copy of the df in case it totally messes it up
geotagged_tweets_copy = geotagged_tweets.copy()

# read in state abbreviations dataframe
state_abbrevs = pd.read_csv('data/state_abbrevs.csv')

# get list of state two letter abbreviations
states = state_abbrevs['abbrev'].tolist()

# ensure that all entries in the state column of the tweet dataframe are strings
geotagged_tweets_copy['state'] = geotagged_tweets_copy['state'].apply(str)


# sanity check
print('Before:')
print(geotagged_tweets_copy['state'].unique())
print()


# First try just taking the last two letters, since that looks like it'll fix it
# in a lot cases
for i in range(len(geotagged_tweets_copy)):
    if len(geotagged_tweets_copy.loc[i]['state']) > 2:
        test = geotagged_tweets_copy.loc[i]['state'][-2:]
        # if last two letters match a state abbreviation, set the state to just
        # being those two letters
        if (test in states):
            geotagged_tweets_copy.at[i, 'state'] = test


# sanity check
print('After Step 1:')
print(geotagged_tweets_copy['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()


    
# now get list of all "state, USA" formats
names = state_abbrevs['full_name'].tolist()
for i in range(len(geotagged_tweets_copy)):
    # check if the state value matches any of our state, USA entries
    if len(geotagged_tweets_copy.loc[i]['state']) > 2:
        curr = geotagged_tweets_copy.loc[i]['state']
        if (curr in names):
            for j in range(len(state_abbrevs)):
                # if it does, set to the corresponding abbrev from the data frame
                if state_abbrevs.loc[j]['full_name'] == curr:
                    geotagged_tweets_copy.at[i, 'state'] = state_abbrevs.loc[j]['abbrev']
                    
        else:
            geotagged_tweets_copy.at[i, 'state'] = 'Unknown'
    

    
# guess what! more sanity checks!
print('After Step 2:')
print(geotagged_tweets_copy['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()



# Now work on the unknowns to see what else we can fix!
l = []
for i in range(len(geotagged_tweets_copy)):
    # only move forward with those that have unknown states
    if geotagged_tweets_copy.iloc[i]['state'] == 'Unknown':
        geo = geotagged_tweets_copy.iloc[i]['geo']
        
        # if geo isn't a dictionary yet, make it one
        try:
            geo = geo.replace("'",'"')
            geo = json.loads(geo)
            
        # if it's already a dictionary, don't do anything
        except (AttributeError, json.JSONDecodeError):
            pass
        
        try:
            l.append(geo['full_name'])
        except:
            l.append('none')

c = Counter(l)
print(len(c.keys()))

with open('data/states_expanded.json','r') as f:
    more_states = json.load(f)
    
locations = list(more_states.keys())


for loc in locations:
    for i in range(len(l)):
        if loc in l[i]:
            l[i] = more_states[loc]




        


c = Counter(l)
keys = list(c.keys())
for i in range(50):
    k = keys[i]
    print(k, ': ', c[k], sep='')
    
print(len(c.keys()))



print('Before fixing years:')
print(geotagged_tweets_copy['year'].unique())
print()



# Finally, fix the years
geotagged_tweets_copy['year'] = geotagged_tweets_copy['year'].apply(str)
for i in range(len(geotagged_tweets_copy)):
    geotagged_tweets_copy.at[i, 'year'] = geotagged_tweets_copy.loc[i]['year'][:4]
    
    # this is a little brute force-y, but oh well:
    if geotagged_tweets_copy.loc[i]['year'] == 'nan' or geotagged_tweets_copy.loc[i]['year'] == '[]':
        geotagged_tweets_copy.at[i, 'year'] = 'Unknown'





print('After fixing years:')
print(geotagged_tweets_copy['year'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()
    
    
    
# geotagged_tweets_copy.to_csv('data/geotagged_cleaned.csv')
    


print('Done!')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()
