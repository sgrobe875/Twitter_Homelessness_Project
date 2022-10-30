import pandas as pd
import json
import nltk 
from nltk.sentiment.vader import SentimentIntensityAnalyzer
nltk.download('vader_lexicon')
import datetime
import pickle




with open('data/geotagged_tweets_df.pkl', 'rb') as pickled_tweets:
    geotagged_tweets = pickle.load(pickled_tweets)
    
pickled_tweets.close()






### Begin sentiment analysis


# initalize sentiment analyzer
analyzer = SentimentIntensityAnalyzer()


# loop through data frame and record compound sentiment for each tweet to the column "sentiment"
for i in range(0, len(geotagged_tweets)):
    scores = analyzer.polarity_scores(geotagged_tweets.loc[i, 'text'])
    geotagged_tweets.at[i, 'sentiment'] = scores['compound']
    



# save the results to a file to move to R
geotagged_tweets.to_csv('data/geotagged_sentiment_only.csv', index = False)