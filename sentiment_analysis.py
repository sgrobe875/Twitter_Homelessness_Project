import pandas as pd
import json
import nltk 
from nltk.sentiment.vader import SentimentIntensityAnalyzer
nltk.download('vader_lexicon')
import datetime
import pickle


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
            geotagged_tweets.at[index, 'state'] = 'state'
            
        except:
            pass
        
    return geotagged_tweets












# read in the data
# geotagged_tweets = read_geotagged_data('data/geotagged')
    
# make sure things look as you expect:      geotagged_tweets.loc[0,:]


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
    











# ### Convert to datetimes

# # Fix dates

# days_as_datetimes = []

# for i in range(0, len(d)):
#     days_as_datetimes.append(datetime.datetime.strptime(d["Day"][i], "%m/%d/%y"))
    

# events_as_datetimes = []
    
# for i in range(0, len(d)):
#     events_as_datetimes.append(datetime.datetime.strptime(d["Event.Date"][i], "%m/%d/%y"))
    
    



# # Fix Times

# datesTimes_as_datetimes = []

# for i in range(0, len(d)):
#     time = d["Time"][i]
    
#     if time[-2] == "P" and time[0] != "1" and time[1] != "2":
#         firstDigit = int(time[0])
#         firstDigit = firstDigit + 12
#         digitString = str(firstDigit)
#         newString = digitString + time[1:-3]
#         #d["Time"][i] = newString
        
#         date = d["Day"][i]
        
#         dateAndTime = date + " " + newString
        
#     else:
#         time = time[:-3]
#         date = d["Day"][i]
        
#         dateAndTime = date + " " + time
        
#     try:
#         datesTimes_as_datetimes.append(datetime.datetime.strptime(dateAndTime, "%m/%d/%y %H:%M:%S"))   
#     except:
#         print(d["Time"][i])



































# save the results to a file to move to R
#geotagged_tweets.to_csv('data/geotagged_sentiment.csv', index = False)
geotagged_tweets.to_csv('data/geotagged_sentiment_THIS_ONE.csv', index = False)