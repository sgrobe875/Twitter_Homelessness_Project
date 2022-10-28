import pandas as pd
import pickle
from labMTsimple.storyLab import emotionFileReader, emotion, stopper, emotionV
from importlib import reload



# load in the tweet data
with open('data/geotagged_tweets_df.pkl', 'rb') as pickled_tweets:
    geotagged_tweets = pickle.load(pickled_tweets)
    
pickled_tweets.close()

# set up the sentiment analyzer
# abMT,labMTvector,labMTwordList = emotionFileReader(stopval=0.0,lang='english', returnVector=True)



# There's probably a better way to do this, but this is what I know will work:

    


### group by state (over all years)

# get list of all unique states
states = geotagged_tweets['state'].unique()

all_tweets = []

# loop through state list
for st in states:
    # get df of all tweets from that state
    temp = geotagged_tweets[geotagged_tweets['state'] == st]
    
    # concatenate all these tweets into one large string
    state_tweets = ''
    for index in range(0, len(temp)):
        state_tweets += temp.iloc[index]['text']
        state_tweets += ' '  # add a space onto the end to avoid tweets merging together
        
    # add this state's tweets to list of all states' tweets
    all_tweets.append(state_tweets)
    
# convert to dictionary and then to dataframe
states_grouped = {'state': states, 'text': all_tweets}
states_grouped = pd.DataFrame(states_grouped)

# delete the extra lists so we don't almost explode again
del(state_tweets)


print('Completed grouping by state')



### group by year (over all states)

# get list of all unique years
years = geotagged_tweets['year'].unique()

all_tweets = []

# loop through year list
for yr in years:
    # get df of all tweets from that year
    temp = geotagged_tweets[geotagged_tweets['year'] == yr]
    
    # concatenate all these tweets into one large string
    year_tweets = ''
    for index in range(0, len(temp)):
        year_tweets += temp.iloc[index]['text']
        year_tweets += ' '  # add a space onto the end to avoid tweets merging together
        
    # add this year's tweets to list of all years' tweets
    all_tweets.append(year_tweets)
    
# convert to dictionary and then to dataframe
years_grouped = {'year': years, 'text': all_tweets}
years_grouped = pd.DataFrame(years_grouped)

# delete the extra lists so we don't almost explode again
del(year_tweets)


print('Completed grouping by year')



### group by state AND year

all_tweets = []
states_column = []
years_column = []

# loop through all states
for st in states:
    temp_st = geotagged_tweets[geotagged_tweets['state'] == st]
    
    # within this state, loop through all years
    for yr in years:
        temp = temp_st[temp_st['year'] == yr]
        
        # concatenate all these tweets into one large string
        year_tweets = ''
        for index in range(0, len(temp)):
            year_tweets += temp.iloc[index]['text']
            year_tweets += ' '  # add a space onto the end to avoid tweets merging together
        
        # add this year's tweets to list of all years' tweets
        all_tweets.append(year_tweets)
        states_column.append(st)
        years_column.append(yr)


# convert to dictionary and then to dataframe
states_years_grouped = {'state': states_column, 'year': years_column, 'text': all_tweets}
states_years_grouped = pd.DataFrame(states_years_grouped)

del(years, states, all_tweets, states_column, years_column, year_tweets)


print('Completed grouping by both')


print('Beginning sentiment analysis!')




#### Sentiment analysis with labMT - run for each of the dataframes and save results to a file

# labMT,labMTvector,labMTwordList = emotionFileReader(stopval=0.0,lang='english', returnVector=True)

# for i in range(0, len(geotagged_tweets)):
#     vec = emotion(geotagged_tweets.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[1]
#     raw_sent = emotion(geotagged_tweets.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[0]
#     temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
#     sentiment = emotionV(temp,labMTvector)
#     geotagged_tweets.at[i, 'sentiment'] = sentiment
#     geotagged_tweets.at[i, 'raw_sentiment'] = raw_sent



# # save the results to a file to move to R
# geotagged_tweets.to_csv('data/geotagged_sentiment_labMT.csv', index = False)