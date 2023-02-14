import pandas as pd
import json
import datetime
from collections import Counter
import warnings
warnings.filterwarnings("ignore")
from geopy.geocoders import Nominatim
from timezonefinder import TimezoneFinder
import pytz


### load some useful data to help with building the state column

# state in "stateName, USA" format
state_USA = {"Alabama, USA":"AL", "Alaska, USA":"AK", "Arizona, USA":"AZ",
             "Arkansas, USA":"AR", "American Samoa, USA":"AS", "California, USA":"CA",
             "Colorado, USA":"CO", "Connecticut, USA":"CT", "Delaware, USA":"DE",
             "District of Columbia, USA":"DC", "Florida, USA":"FL",
             "Georgia, USA":"GA", "Guam, USA":"GU", "Hawaii, USA":"HI",
             "Idaho, USA":"ID", "Illinois, USA":"IL", "Indiana, USA":"IN",
             "Iowa, USA":"IA", "Kansas, USA":"KS", "Kentucky, USA":"KY",
             "Louisiana, USA":"LA", "Maine, USA":"ME", "Maryland, USA":"MD",
             "Massachusetts, USA":"MA", "Michigan, USA":"MI", "Minnesota, USA":"MN", 
             "Mississippi, USA":"MS", "Missouri, USA":"MO", "Montana, USA":"MT", 
             "Nebraska, USA":"NE", "Nevada, USA":"NV", "New Hampshire, USA":"NH", 
             "New Jersey, USA":"NJ", "New Mexico, USA":"NM", "New York, USA":"NY", 
             "North Carolina, USA":"NC", "North Dakota, USA":"ND", "Ohio, USA":"OH", 
             "Oklahoma, USA":"OK", "Oregon, USA":"OR", "Pennsylvania, USA":"PA", 
             "Puerto Rico, USA":"PR", "Rhode Island, USA":"RI", "South Carolina, USA":"SC", 
             "South Dakota, USA":"SD", "Tennessee, USA":"TN", "Texas, USA":"TX",
             "Utah, USA":"UT", "Vermont, USA":"VT", "Virginia, USA":"VA",
             "Washington, USA":"WA", "West Virginia, USA":"WV",
             "Wisconsin, USA":"WI","Wyoming, USA":"WY"}

# additional clear indicators of state (add to this as needed)
states_expanded = {"Arkansas": "AR", "Dallas": "TX", "California": "CA", 
                   "Pennsylvania": "PA", "Los Angeles": "CA", "Minnesota": "MN", 
                   "Indiana": "IN", "Fresno": "CA", "Illinois": "IL", 
                   "Nashville": "TN", "Austin": "TX", "Sacramento": "CA", 
                   "Philadelphia": "PA", "Yale University": "CT", 
                   "Charleston": "SC", "Massachusetts": "MA", "Las Vegas": "NV", 
                   "Indianapolis": "IN", "Columbus": "OH", "Ann Arbor": "MI", 
                   "Orlando": "FL", "Cleveland": "OH", "Madison": "WI", 
                   "Texas": "TX", "Santa Cruz": "CA", "Atlanta": "GA", 
                   "Harrisburg": "PA", "Nevada": "NV", "Queens": "NY", 
                   "Arizona": "AZ", "Oregon": "OR", "San Diego": "CA", 
                   "Oakland": "CA", "San Jose": "CA", "Miami": "FL", 
                   "Coney Island": "NY", "Albany": "NY", "Iowa": "IA", 
                   "Twin Cities": "MN", "Detroit": "MI", "Seattle": "WA", 
                   "Boston": "MA", "Fort Worth": "TX", "Chicago": "IL", 
                   "New York": "NY", "Washington DC": "DC", "Brooklyn": "NY", 
                   "Georgia": "GA", "Delaware": "DE", "New Orleans": "LA", 
                   "Denver": "CO", "NYPD": "NY", "LAPD": "CA", "NYU": "NY", 
                   "Vanderbilt": "TN", "LA ": "CA", "Hollywood": "CA", 
                   "Houston": "TX", "Santa Monica": "CA", "Connecticut": "CT", 
                   "Florida": "FL", "Capitol Hill": "DC", "Green Bay": "WI", 
                   "Hoboken": "NJ", "Pasadena": "CA", "Manhattan": "NY", 
                   "NJ ": "NJ", "CA ": "CA", "NY ": "NY", "MA ": "MA", 
                   "TX ": "TX", "San Fran": "CA", "Rochester": "NY", 
                   "Colorado": "CO", "Worcester": "MA", "Hawaii": "HI", 
                   "Bronx": "NY", "Utah": "UT", "L.A.": "CA", "White House": "DC", 
                   "Saint Paul": "MN", "Puerto Rico": "PR", "Times Square": "NY", 
                   "Statue of Liberty": "NY"}


# print an update
print('Beginning cleaning')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()


# read in the raw tweets
def read_geotagged_data(filepath):
    geotagged_tweets = pd.read_csv(filepath, engine = 'c', encoding = 'latin1')
    return geotagged_tweets

# initialize the geolocator
geolocator = Nominatim(user_agent="geoapiExercises")

# initialize timezone finder
tf = TimezoneFinder()

# read in the data
geotagged_tweets = read_geotagged_data('data/tweets.csv')





### DATAFRAME CLEANING #####################################################################



# remove the "place_" prefix from location-related columns
cols = list(geotagged_tweets.columns)
for col in cols:
    if 'place_' in col:
        geotagged_tweets.rename(columns={col: col[6:]}, inplace=True)
        

geotagged_tweets.rename(columns={'tweet_created_at': 'tweet_created_at_GMT'}, inplace=True)

# initialize columns (to be filled in in a moment!)
geotagged_tweets['state'] = ''
geotagged_tweets['year'] = ''


# ensure that all entries in the state column of the tweet dataframe are strings
geotagged_tweets['full_name'] = geotagged_tweets['full_name'].apply(str)
geotagged_tweets['referenced_tweets'] = geotagged_tweets['referenced_tweets'].apply(str)


# sanity check
print('Before:')
print(geotagged_tweets['state'].unique())
print()


# First, try just doing the last two letters of the location
for i in range(len(geotagged_tweets)):
    
    # print update every 100,000 tweets
    if i > 0 and i % 100000 == 0:  
        print('Completed row ' + str(i) + ' out of ' + str(len(geotagged_tweets)))
        e = datetime.datetime.now()
        print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
        print()
    
    test = geotagged_tweets.loc[i]['full_name'][-5:-3]
    
    # if last two letters match a state abbreviation, set the state to just
    # being those two letters
    if (test in list(state_USA.values())):
        geotagged_tweets.at[i, 'state'] = test


# sanity check
print('After Step 1:')
print(geotagged_tweets['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()

    
locations = list(states_expanded.keys())

local_time_column = []

# Make more attempts at defining the state

# loop through all tweets, only look at tweets with a blank state value 
for i in range(len(geotagged_tweets)):
    
    # first fix the time
    try:
        # get geo field and convert from string to dict
        geo = geotagged_tweets.loc[i]['geo']
        geo = geo[1:-2].replace("'",'"')
        geo = json.loads(geo)
        
        # get coordinate values
        long = geo['bbox'][0]
        lat  = geo['bbox'][1]
        
        ###### COURTESY OF ZacharyST ON GITHUB ################################
        # slight modifications to the original code were made to suit these data
        # https://github.com/ZacharyST/Twitter_AdjustTimeCorrectly
        
        # Get timezones
        zone = tf.timezone_at(lng=long, lat=lat)
        timezone = pytz.timezone(zone)

		# Make local time 
        # utc_time = datetime.datetime.strptime(geotagged_tweets.loc[i]['tweet_created_at'], '%a %b %d %H:%M:%S +0000 %Y').replace(tzinfo=pytz.UTC)
        utc_time = datetime.datetime.strptime(geotagged_tweets.loc[i]['tweet_created_at_GMT'], '%Y-%m-%d %H:%M:%S+00:00').replace(tzinfo=pytz.UTC)
        local_time = utc_time.replace(tzinfo=pytz.utc).astimezone(timezone)  # Get local time as datetime object

        # tweet['local_time_twitterStyle'] = local_time.strftime(format='%a %b %d %H:%M:%S +0000 %Y')
        
        # tweet['local_time_nice'] = local_time.strftime('%Y-%m-%d %H:%M:%S')
        local_time_column.append(local_time.strftime('%Y-%m-%d %H:%M:%S'))
    except:
        local_time_column.append('nan')
        
        #######################################################################
    
    # print update every 100,000 tweets
    if i > 0 and i % 100000 == 0:  
        print('Completed row ' + str(i) + ' out of ' + str(len(geotagged_tweets)))
        e = datetime.datetime.now()
        print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
        print()
         
    # check if state field is still blank
    if len(geotagged_tweets.loc[i]['state']) < 2:
        
        # flag for whether one of these solutions has worked
        fixed = False
        
        # first check for "state, USA" format
        curr = geotagged_tweets.loc[i]['full_name'][2:-3]
        # check for a match in the dictionary
        if (curr in list(state_USA.keys())):
            # if match, set the state field to the corresponding value
            geotagged_tweets.at[i, 'state'] = state_USA[curr]
            # since we assigned a value, set fixed to True
            fixed = True  
                
        # if that didn't work, let's try looking for cities, landmarks, etc.
        if not fixed:
            # check for other clues, such as city names 
            for loc in locations:
                if loc in curr:
                    # if found, overwrite to the corresponding state
                    geotagged_tweets.at[i, 'state'] = states_expanded[loc]
                    # since we assigned a value, set fixed to True
                    fixed = True
                    break
        
        # if still not fixed after prior two methods, try using coordinates
        # (with some help from Yoshi here!)
        if not fixed:
            try:
                # get geo field and convert from string to dict
                geo = geotagged_tweets.loc[i]['geo']
                geo = geo[1:-2].replace("'",'"')
                geo = json.loads(geo)
                
                # get coordinate values
                long = geo['bbox'][0]
                lat  = geo['bbox'][1]
                
                # use the geolocator to get a state value
                location = geolocator.reverse(str(lat) + "," + str(long))
                address = location.raw['address']['state']
                
                # append ', USA' to the state value
                address += ', USA'
                
                # use the state_USA dict to get the correct state abbreviation
                abbrev = state_USA[address]
                
                # put value into the dataframe and mark as fixed
                geotagged_tweets.at[i, 'state'] = abbrev
                fixed = True
            
            # any errors --> coordinates are invalid in some way, so just skip
            except:
                pass
        
        # if the prior methods couldn't assign a state, then change from '' to "Unknown"
        # this also ensures we are hitting every relevant row in the data set
        if not fixed:
            geotagged_tweets.at[i, 'state'] = 'Unknown'
            
geotagged_tweets['tweet_created_at'] = local_time_column

# guess what! more sanity checks!
print('After Step 2:')
print(geotagged_tweets['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()


### Moving on to the years column

# print update
print('Before fixing years:')
print(geotagged_tweets['year'].unique())
print()


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



# sanity check for years column
print('After fixing years:')
print(geotagged_tweets['year'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()


# print update
print('Cleaning done! Beginning text preprocessing')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()





### TEXT PREPROCESSING #########################################################################



# lists of acceptable characters (what we DON'T want filtered out)
letters =    ['a','b','c','d','e','f','g','h','i','j','k','l','m',
              'n','o','p','q','r','s','t','u','v','w','x','y','z']

letters_upper = ['A','B','C','D','E','F','G','H','I','J','K','L','M',
                 'N','O','P','Q','R','S','T','U','V','W','X','Y','Z']

digits =     ['0','1','2','3','4','5','6','7','8','9']

acceptable = ['a','b','c','d','e','f','g','h','i','j','k','l','m',   # letters
              'n','o','p','q','r','s','t','u','v','w','x','y','z',
              '0','1','2','3','4','5','6','7','8','9',               # numbers
              ' ']                                                   # space

# slang dictionary! Used to enhance the sentiment analysis
# all abbreviations included here are NOT already in the labMT dictionary, but
# all words in the translation ARE! (or are symbols, and will be filtered out)
slang = {'foh': 'fuck outta here', 'gtfo': 'get the fuck out', 'str8': 'straight',
         'bby': 'baby', 'hon': 'hun', '&amp;': 'and', '&lt;': '<', '&gt;': '>'}



# print update
print('Beginning text preprocessing')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()

# list to hold the tweet type column to be added to the dataframe
retweets = []

# loop through every tweet in the data set
for row in range(len(geotagged_tweets)):
    
    # extract the tweet text
    new_tweet = str(geotagged_tweets.iloc[row]['tweet_text'])

    ### First step: split hashtags by camelcase
    
    # search for pound symbol
    while new_tweet.rfind('#') > -1:
        # isolate the hashtag
        hash_start = new_tweet.rfind('#')
        hash_end = hash_start + 1
        if hash_start < len(new_tweet)-1:
            while new_tweet[hash_end] != ' ' and hash_end < len(new_tweet)-1:
                hash_end += 1
                
            fixed_hash = new_tweet[hash_start+1:hash_end+1]
        
            for i in range(1, len(fixed_hash)-1):
                # if uppercase letter
                if fixed_hash[i] in letters_upper:
                    before = fixed_hash[i-1]
                    after = fixed_hash[i+1]
                    # if lowercase on either side of the uppercase letter
                    if before in letters and after in letters:
                        # add in a space before the capital
                        fixed_hash = fixed_hash[:i] + ' ' + fixed_hash[i:]
                    
            # replace the fixed hash in new_tweet
            new_tweet = new_tweet[:hash_start] + fixed_hash + new_tweet[hash_end+1:]
            
        else:
            new_tweet = new_tweet[:-1]
                        
    
    # set all characters in tweet to lowercase
    new_tweet = new_tweet.lower()
    
    
    # Check for retweets and fill in the retweets list
    start = geotagged_tweets.iloc[row]['referenced_tweets'].find('type')
    if start > -1:
        end = geotagged_tweets.iloc[row]['referenced_tweets'].find('>')
        retweets.append(geotagged_tweets.iloc[row]['referenced_tweets'][start+5:end])
        
    else:
        retweets.append('unique')
        
        

    # next filter out usernames (any substring starting with @ and ending in a space)
    while new_tweet.rfind('@') > -1:
        username_start = new_tweet.rfind('@')
        i = 1
        username_end = username_start + 1
        # find the end of the username
        if username_start < len(new_tweet)-1:
            while  new_tweet[username_end] != ' ' and username_end < len(new_tweet)-1:
                username_end += 1
            # remove the username
            new_tweet = new_tweet[:username_start] + new_tweet[username_end+1:]
        else: 
            new_tweet = new_tweet[:-1]
            
    # links! filter out anything with the substring http (so this includes https!)
    while new_tweet.rfind('http') > -1:
        start = new_tweet.rfind('http')
        end = start + 1
        while end < len(new_tweet) and new_tweet[end] != ' ':
            end += 1
            
        new_tweet = new_tweet[:start] + new_tweet[end+1:]
        
    # loop through and search for items in the slang dictionary, replace as needed
    for key in slang.keys():
        while new_tweet.rfind(key) > -1:
            start = new_tweet.rfind(key)   
            end = start + len(key)
            new_tweet = new_tweet[:start] + slang[key] + new_tweet[end:]
        
    # loop through every character in the tweet
    filtered_tweet = ''
    prev = ''
    for char in new_tweet:
        # if character is a-z, 0-9, or a space, append it to filtered_tweet (otherwise ignore)
        if char in acceptable:
            # note that this causes some excess spaces, but fixes issue from ellipses, hyphens, etc.
            if (prev == '.' and char != ' ') or prev == '-' or prev == '/':
                filtered_tweet += ' '
            filtered_tweet += char
        prev = char
            
        
    # after looping through all characters, overwrite the tweet with the 
    # contents of filtered_tweet
    geotagged_tweets.at[row, 'tweet_text'] = filtered_tweet
    
    # print update every 100,000 tweets
    if row > 0 and row % 100000 == 0:  
        print('Completed row ' + str(row) + ' out of ' + str(len(geotagged_tweets)))
        e = datetime.datetime.now()
        print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
        print()
    
    
# add the retweets as a column to the dataframe
geotagged_tweets['tweet_type'] = retweets

    
# write the preprocessed data set to a file
geotagged_tweets.to_csv('data/tweets_processed.csv', index=False)

# print a final update
print('Completed all ' + str(len(geotagged_tweets)) + ' rows!')
e = datetime.datetime.now()
print("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()
retweet_counter = Counter(retweets)
print(retweet_counter)




print()
print()
print('Cleaning and preprocessing is now complete.')



