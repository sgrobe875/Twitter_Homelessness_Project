import pandas as pd
import pickle
from labMTsimple.storyLab import emotionFileReader, emotion, stopper, emotionV
from importlib import reload



# load in the tweet data
with open('data/geotagged_tweets_df.pkl', 'rb') as pickled_tweets:
    geotagged_tweets = pickle.load(pickled_tweets)
    
pickled_tweets.close()

# set up the sentiment analyzer
labMT,labMTvector,labMTwordList = emotionFileReader(stopval=0.0,lang='english', returnVector=True)



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
del(states)
del(all_tweets)
del(state_tweets)






# group by year (over all states)





# group by state AND year







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