import pandas as pd
import json
import nltk 
from nltk.sentiment.vader import SentimentIntensityAnalyzer
nltk.download('vader_lexicon')


def read_geotagged_data(filepath):
    geotagged_tweets = pd.read_csv(filepath, engine = 'c', encoding = 'latin1')
    
    for index, geodict in enumerate(geotagged_tweets['geo']):
        try:
            thisdict = json.loads(geodict)
            geotagged_tweets.at[index, 'geo'] = thisdict
            geotagged_tweets.at[index, 'place_type'] = thisdict['place_type']
            geotagged_tweets.at[index, 'full_name'] = thisdict['full_name']
            geotagged_tweets.at[index, 'country'] = thisdict['country']
            
            # attempting to extract the state
            full_name = thisdict['full_name']
            state = full_name[-2:]
            geotagged_tweets.at[index, 'state'] = state
            
        except:
            pass
        
    return geotagged_tweets












# read in the data
geotagged_tweets = read_geotagged_data('data/geotagged')
    
# make sure things look as you expect:      geotagged_tweets.loc[0,:]





### Begin sentiment analysis


# initalize sentiment analyzer
analyzer = SentimentIntensityAnalyzer()


# loop through data frame and record compound sentiment for each tweet to the column "sentiment"
for i in range(0, len(geotagged_tweets)):
    scores = analyzer.polarity_scores(geotagged_tweets.loc[i, 'text'])
    geotagged_tweets.at[i, 'sentiment'] = scores['compound']
    

# save the results to a file to move to R
geotagged_tweets.to_csv('data/geotagged_sentiment.csv', index = False)