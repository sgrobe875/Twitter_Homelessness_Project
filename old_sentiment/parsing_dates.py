import pandas as pd
import datetime


# TODOS:
# focus on California for homelessness
    # maybe over a year? most reliable and most data
    # maybe do Wisconsin as well


# read in data
geotagged_tweets = pd.read_csv('data/geotagged_sentiment_only.csv')  


### Convert to datetimes - Only going to focus on dates, not times

# split created_at variable by 'T' (first part is the date, second part is the time)
dates = []
for item in geotagged_tweets['created_at']:
    # get the date as a string
    try:
        date = item.split('T')[0]
        # convert to datetime and append to list
        dates.append(datetime.datetime.strptime(date, "%Y-%m-%d"))
    except:
        dates.append('NA')
    
# add list of datetime dates to the dataframe as a column
geotagged_tweets['date_posted'] = dates

# write finalized dataframe to a file (so we can graph in R)
geotagged_tweets.to_csv('data/geotagged_sentiment_plus_datetimes.csv', index = False)



