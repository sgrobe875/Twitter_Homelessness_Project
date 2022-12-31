# Twitter/Homelessness project
# Data preprocessing


# NOTE: This script should be run AFTER cleaning.py (but before the sentiment analysis!)


# imports
import pandas as pd



# read in the original data file of tweets
# geotagged_tweets = pd.read_csv('data/geotagged_cleaned.csv', dtype=str)

sample = "TeSTINg tweet so i can @username make sUre thi's work\"s! what? @another_username else. can} i& put* here$"

# list of acceptable characters (what we DON'T want filtered out)
acceptable = ['a','b','c','d','e','f','g','h','i','j','k','l','m',   # letters
              'n','o','p','q','r','s','t','u','v','w','x','y','z',
              '0','1','2','3','4','5','6','7','8','9',               # numbers
              ' ']                                                   # space


#### TEXT PREPROCESSING ######################################################

# loop through every tweet in the data set

#  set all characters in tweet to lowercase
new_tweet = sample.lower()

# first filter out usernames (any substring starting with @ and ending in a space)
while new_tweet.rfind('@') > -1:
    username_start = new_tweet.rfind('@')
    i = 1
    username_end = username_start + i
    # find the end of the username
    while  new_tweet[username_end] != ' ' and username_end < len(sample):
        i += 1
        username_end = username_start + i
    # remove the username
    new_tweet = new_tweet[:username_start] + new_tweet[username_end+1:]
        
# loop through every character in the tweet
filtered_tweet = ''
for char in new_tweet:
    # if character is a-z, 0-9, or a space, append it to filtered_tweet (otherwise ignore)
    if char in acceptable:
        filtered_tweet += char

    # after looping through all characters, overwrite the tweet with the 
    # contents of filtered_tweet

# write the preprocessed data set to a file


print(sample)
print(filtered_tweet)





#### BUILDING SUBSETS ########################################################

# Data set of just user data (detach the tweet data)




# Data set of just tweet data (detach the user data)




# Filter out retweets

# start by searching for the substring "rt:"

# if the above is the first three characters of a tweet, delete that tweet
# from the data set

# also loop through and check for any identical tweets in the data set:
    
# first sort tweets by when they were posted (date & time)

# if two identical tweets are found, remove whichever tweet was posted later

# write a file of the end result: all unique tweets

# NOTE: the above *should* handle all retweets, I think, but definitely keep
# brainstorming other things we could be missing here




# Count retweets

# essentially same procedure as above, but include some kind of a counter
# variable that increments as retweets are found





# Ambitious and potentially not useful: number of retweets in first XX days
# since tweet was posted (e.g., first 2 days, first 5 days, first 10 days)

# Again, pretty much same as above, but now we need to count days




