import pandas as pd
import json
import datetime
from collections import Counter
import warnings
warnings.filterwarnings("ignore")


print('Beginning cleaning')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()



def read_geotagged_data(filepath):
    geotagged_tweets = pd.read_csv(filepath, engine = 'c', encoding = 'latin1')
    return geotagged_tweets




# read in the data
geotagged_tweets = read_geotagged_data('data/tweets.csv')



### DATAFRAME CLEANING #####################################################################



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
geotagged_tweets['full_name'] = geotagged_tweets['full_name'].apply(str)


# sanity check
print('Before:')
print(geotagged_tweets['state'].unique())
print()


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


names = state_abbrevs['full_name'].tolist()

with open('data/states_expanded.json','r') as f:
    more_states = json.load(f)
    
locations = list(more_states.keys())



# for i in range(len(geotagged_tweets)):
#     # check if the state value matches any of our state, USA entries
#     # but only check those that haven't been fixed yet!
#     if len(geotagged_tweets.loc[i]['state']) < 2:
#         curr = geotagged_tweets.loc[i]['full_name'][2:-2]
#         if (curr in names):
#             for j in range(len(state_abbrevs)):
#                 # if it does, set to the corresponding abbrev from the data frame
#                 if state_abbrevs.loc[j]['full_name'] == curr:
#                     geotagged_tweets.at[i, 'state'] = state_abbrevs.loc[j]['abbrev']
                    
#         else:
#             geotagged_tweets.at[i, 'state'] = 'Unknown'


    
# guess what! more sanity checks!
print('After Step 2:')
print(geotagged_tweets['state'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()


# only look at tweets with a blank state value 
if len(geotagged_tweets.loc[i]['state']) < 2:
        
    fixed = False
    
    # first check for "state, USA" format
    curr = geotagged_tweets.loc[i]['full_name'][2:-3]
    if (curr in names):
        for j in range(len(state_abbrevs)):
            # if it matches, set to the corresponding abbrev from the data frame
            if state_abbrevs.loc[j]['full_name'] == curr:
                geotagged_tweets.at[i, 'state'] = state_abbrevs.loc[j]['abbrev']
                # since we assigned a value, set fixed to True
                fixed = True  
                break
            
    # if that didn't work let's try something else that' s a bit more expensive
    else:
        # check for other clues,such as city names (from states_expanded.json)
        for loc in locations:
            if loc in curr:
                # if found, overwrite to the corresponding state
                geotagged_tweets.at[i, 'state'] = more_states[loc]
                # since we assigned a value, set fixed to Truef
                fixed = True
                break
    
    # if the prior two methods couldn't assign a state, then set it as "Unknown"
    if not fixed:
        geotagged_tweets.at[i, 'state'] = 'Unknown'


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




print('After fixing years:')
print(geotagged_tweets['year'].unique())
print()
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()



print('Cleaning done! Beginning text preprocessing')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()





### TEXT PREPROCESSING #########################################################################



# list of acceptable characters (what we DON'T want filtered out)
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


#### TEXT PREPROCESSING ######################################################

# print update
print('Beginning text preprocessing')
e = datetime.datetime.now()
print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()

retweets = []

# loop through every tweet in the data set
for row in range(len(geotagged_tweets)):
    new_tweet = str(geotagged_tweets.iloc[row]['tweet_text'])

    # split hashtags by camelcase
    
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
                        
    
    #  set all characters in tweet to lowercase
    new_tweet = new_tweet.lower()
    
    
    # Check for retweets
    start = geotagged_tweets.iloc[row]['referenced_tweets'].find('type')
    if start > -1:
        end = geotagged_tweets.iloc[row]['referenced_tweets'].find('>')
        retweets.append(geotagged_tweets.iloc[row]['referenced_tweets'][start+5:end])
        
    else:
        retweets.append('unique')
        
        

    # first filter out usernames (any substring starting with @ and ending in a space)
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
    geotagged_tweets.iloc[row]['tweet_text'] = filtered_tweet
    
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



