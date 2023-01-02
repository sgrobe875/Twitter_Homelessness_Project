# Twitter/Homelessness project
# Data preprocessing


# NOTE: This script should be run AFTER cleaning.py (but before the sentiment analysis!)


# imports
import pandas as pd
import datetime
from collections import Counter



# read in the original data file of tweets
geotagged_tweets = pd.read_csv('data/geotagged_cleaned.csv', dtype=str)

# sample = "TeSTINg tweet so i can @username make sUre thi's work\"s! what? @another_username else. can} i& put* here$"
# sample += ' str8 gtfo bby https://google.com/testing/this_is_a_url/ you &amp; I '
# sample += '#Homeless #HashtagCheck #ImTryingMyBest'


# sample = 'I\'m trying...my best. Right-now. right/left' 




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
    new_tweet = str(geotagged_tweets.iloc[row]['text'])

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
    
    # check if retweet
    if new_tweet.rfind('rt @') > -1:
        # if it is, append either RT or QRT
        if new_tweet.rfind('rt @') == 0:
            retweets.append('RT')
        else:
            retweets.append('QRT')
        # remove everything that is being retweeted (aka, the text that is not unique to this user)
        new_tweet = new_tweet[:new_tweet.rfind('rt @')]
        
    # if not a retweet, append no and do nothing else
    else:
        retweets.append('No')
    
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
    geotagged_tweets.iloc[row]['text'] = filtered_tweet
    
    # print update every 100,000 tweets
    if row > 0 and row % 100000 == 0:  
        print('Completed row ' + str(row) + ' out of ' + str(len(geotagged_tweets)))
        e = datetime.datetime.now()
        print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
        print()
    
    
# add the retweets as a column to the dataframe
geotagged_tweets['retweet_type'] = retweets

    
# write the preprocessed data set to a file
geotagged_tweets.to_csv('data/geotagged_processed.csv', index=False)

print('Completed all ' + str(len(geotagged_tweets)) + ' rows!')
e = datetime.datetime.now()
print("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
print()
retweet_counter = Counter(retweets)
print('Table of retweet counts')
print()
print('Type            |    Count  |  Percent')
print('----------------+-----------+----------')
print('Simple retweets |  %7d  |  %6.2f%%' % (retweet_counter['RT'], retweet_counter['RT'] / len(geotagged_tweets) * 100))
print('Quote retweets  |  %7d  |  %6.2f%%' % (retweet_counter['QRT'], retweet_counter['QRT'] / len(geotagged_tweets) * 100))
print('Not a retweet   |  %7d  |  %6.2f%%' % (retweet_counter['No'], retweet_counter['No'] / len(geotagged_tweets) * 100))
print()






# NOTE: the above *should* handle all retweets, I think, but definitely keep
# brainstorming other things we could be missing here
















### I don't think these are possible with how the data are currently set up, but ###
### still leaving these notes here for future reference                          ###



# Count retweets

# essentially same procedure as above, but include some kind of a counter
# variable that increments as retweets are found





# Ambitious and potentially not useful: number of retweets in first XX days
# since tweet was posted (e.g., first 2 days, first 5 days, first 10 days)

# Again, pretty much same as above, but now we need to count days




