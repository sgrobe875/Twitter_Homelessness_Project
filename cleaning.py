import pandas as pd
import json
import datetime



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
states = state_abbrevs['abbrev'].tolist()


geotagged_tweets_copy['state'] = geotagged_tweets_copy['state'].apply(str)

print('Before:')
print(geotagged_tweets_copy['state'].unique())
print()

# First try just taking the last two letters, since that looks like it'll fix it
# in a lot cases
for i in range(len(geotagged_tweets_copy)):
    if len(geotagged_tweets_copy.loc[i]['state']) > 2:
        test = geotagged_tweets_copy.loc[i]['state'][-2:]
        if (test in states):
            geotagged_tweets_copy.at[i, 'state'] = test

print('After Step 1:')
print(geotagged_tweets_copy['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()


    
    
names = state_abbrevs['full_name'].tolist()
for i in range(len(geotagged_tweets_copy)):
    if len(geotagged_tweets_copy.loc[i]['state']) > 2:
        curr = geotagged_tweets_copy.loc[i]['state']
        if (curr in names):
            for j in range(len(state_abbrevs)):
                if state_abbrevs.loc[j]['full_name'] == curr:
                    geotagged_tweets_copy.at[i, 'state'] = state_abbrevs.loc[j]['abbrev']
                    
        else:
            geotagged_tweets_copy.at[i, 'state'] = 'Unknown'
    

    
    
print('After Step 2:')
print(geotagged_tweets_copy['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()





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
    
    
    
geotagged_tweets_copy.to_csv('data/geotagged_cleaned.csv')
    


print('Done!')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()
