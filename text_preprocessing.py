# Twitter/Homelessness project
# Data preprocessing


# NOTE: This script should be run AFTER cleaning.py (but before the sentiment analysis!)


# imports
import pandas as pd



# read in the original data file of tweets
geotagged_tweets = pd.read_csv('data/geotagged_cleaned.csv', dtype=str)





#### TEXT PREPROCESSING ######################################################

#  set all characters in tweet to lowercase

# first filter out usernames (any substring starting with @ and ending in a space)

# filter out any character that isn't a-z or 0-9:

# loop through every tweet in the data set

# create an empty string new_tweet to hold the filtered tweet

# loop through every character in the tweet

# if character is a-z, 0-9, or a space, append it to new_tweet

# after looping through all characters, overwrite the tweet with the 
# contents of new_tweet

# write the preprocessed data set to a file








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




