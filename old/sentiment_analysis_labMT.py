import pandas as pd
import pickle
from labMTsimple.storyLab import emotionFileReader, emotion, stopper, emotionV
from importlib import reload




with open('data/geotagged_tweets_df.pkl', 'rb') as pickled_tweets:
    geotagged_tweets = pickle.load(pickled_tweets)
    
pickled_tweets.close()



# Sentiment analysis with labMT

labMT,labMTvector,labMTwordList = emotionFileReader(stopval=0.0,lang='english', returnVector=True)

for i in range(0, len(geotagged_tweets)):
    vec = emotion(geotagged_tweets.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[1]
    raw_sent = emotion(geotagged_tweets.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[0]
    temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
    sentiment = emotionV(temp,labMTvector)
    geotagged_tweets.at[i, 'sentiment'] = sentiment
    geotagged_tweets.at[i, 'raw_sentiment'] = raw_sent



# save the results to a file to move to R
geotagged_tweets.to_csv('data/geotagged_sentiment_labMT.csv', index = False)