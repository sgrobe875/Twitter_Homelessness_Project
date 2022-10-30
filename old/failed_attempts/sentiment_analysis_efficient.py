import pandas as pd
import pickle
from labMTsimple.storyLab import emotionFileReader, emotion, stopper, emotionV
from importlib import reload
import datetime
from string import punctuation
import nltk
from nltk.corpus import stopwords
nltk.download('stopwords')
stops = set(stopwords.words('english'))





# load in the tweet data
with open('data/geotagged_tweets_df.pkl', 'rb') as pickled_tweets:
    geotagged_tweets = pickle.load(pickled_tweets)
    
pickled_tweets.close()


# use a subset for debugging purposes
# geotagged_tweets = geotagged_tweets.sample(n = 50000)


# set up the analyzer
labMT,labMTvector,labMTwordList = emotionFileReader(stopval=0.0,lang='english', returnVector=True)



# There's probably a better way to do this, but this is what I know will work:
    
    
# Declare functions


### I haven't made these two yet with the more space efficient way, but should be essentially the same as below
# def group_by_state():


# def group_by_year():
    ### group by year (over all states)
    
    e = datetime.datetime.now()

    print("Beginning grouping")
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    
    # get list of all unique states
    years = geotagged_tweets['year'].unique()
    
    sentiment_column = []
    raw_sent_column = []
    
    # loop through state list
    for yr in years:
        # get df of all tweets from that state
        temp_tweets = geotagged_tweets[geotagged_tweets['year'] == yr]
        
        # concatenate all these tweets into one large string
        year_tweets = ''
        for index in range(0, len(temp_tweets)):
            year_tweets += temp_tweets.iloc[index]['text']
            year_tweets += ' '  # add a space onto the end to avoid tweets merging together

        del(temp_tweets)
        
        vec = emotion(year_tweets, labMT, shift=True, happsList=labMTvector)[1]
        raw_sent = emotion(year_tweets, labMT, shift=True, happsList=labMTvector)[0]
        
        del(year_tweets)
        
        temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
        sentiment = emotionV(temp,labMTvector)
        sentiment_column.append(sentiment)
        raw_sent_column.append(raw_sent)
        
    # convert to dictionary and then to dataframe
    years_grouped = {'year': years, 'sentiment':sentiment_column, 'raw_sent':raw_sent_column}
    years_grouped = pd.DataFrame(years_grouped)

    
    # save the results to a file to move to R
    years_grouped.to_csv('data/year_sentiment.csv', index = False)
    
    del(years_grouped)
    
    print('Completed sentiment analysis for years')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
###    
    
    
def group_by_both(df):
    ### group by state AND year
    
    print('Beginning grouping')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    
    states = df['state'].unique()
    years = df['year'].unique()

    all_tweets = []
    states_column = []
    years_column = []
    
    sentiment_column = []
    raw_sent_column = []
    
    
    # loop through all states
    for st in states:
        temp_st = df[df['state'] == st]

        # loop through all years within states
        for yr in years:
            # get df of all tweets from that state and year
            temp_tweets = temp_st[temp_st['year'] == yr]
            
            # concatenate all these tweets into one large string
            year_tweets = ''
            for index in range(0, len(temp_tweets)):
                year_tweets += temp_tweets.iloc[index]['text']
                year_tweets += ' '  # add a space onto the end to avoid tweets merging together
    
            del(temp_tweets)
            
            raw_sent, vec = emotion(year_tweets, labMT, shift=True, happsList=labMTvector)
            
            del(year_tweets)
            
            temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
            sentiment = emotionV(temp,labMTvector)
            sentiment_column.append(sentiment)
            raw_sent_column.append(raw_sent)
         
    del(temp_st)
    
    # convert to dictionary and then to dataframe
    state_years_grouped = {'state':states, 'year': years, 'sentiment':sentiment_column, 'raw_sent':raw_sent_column}
    state_years_grouped = pd.DataFrame(state_years_grouped)

    
    # save the results to a file to move to R
    state_years_grouped.to_csv('data/state_year_sentiment.csv', index = False)
    
    del(state_years_grouped)
    
    print('Completed sentiment analysis for grouping by both')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))




def words_of_tweet(tweet):
  exclude = set(punctuation)  # Keep a set of "bad" characters.
  list_letters_noPunct = [char for char in tweet if char not in exclude]
  text_noPunct = "".join(list_letters_noPunct)
  list_words = text_noPunct.strip().split()
  list_words = [word.lower() for word in list_words]
  return list_words  



  

# print('By state:')
# group_by_state()
# print('By year:')
# group_by_year()



df = pd.DataFrame(geotagged_tweets.loc[(geotagged_tweets["state"]!= "Puerto Rico") & (geotagged_tweets["state"] != "Unknown") & (geotagged_tweets['year'] != "")])
group_by_both(df)













