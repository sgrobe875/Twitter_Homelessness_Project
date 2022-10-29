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

# set up the analyzer
labMT,labMTvector,labMTwordList = emotionFileReader(stopval=0.0,lang='english', returnVector=True)







#### Declare functions ####

def words_of_tweet(tweet):
  exclude = set(punctuation)  # Keep a set of "bad" characters.
  list_letters_noPunct = [char for char in tweet if char not in exclude]
  text_noPunct = "".join(list_letters_noPunct)
  list_words = text_noPunct.strip().split()
  list_words = [word.lower() for word in list_words]
  return list_words  


# takes in the concatenated string of all tweets in the group
# returns dictionary of word frequencies for that mega string
def get_frequencies(mega_string):
    # get list of individual words
    words = words_of_tweet(mega_string)
    # create the dictionary
    word_frequencies = {}
    # loop through the list
    for word in words:
        # check if word is already in the dictionary
        try:
            # if it is, then increment the frequency
            word_frequencies[word] += 1
        except KeyError:
            # if it isn't, add it!
            word_frequencies[word] = 1
            
    # return the final dictionary
    return word_frequencies
            

def group_by_both(df):
    print('Beginning grouping by both')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    print()
    
    states = df['state'].unique()
    years = df['year'].unique()
    
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
            
            freqs = get_frequencies(year_tweets)
                        
            del(year_tweets)
            
            this_group_sent = []
            this_group_raw = []
            
            for key in freqs.keys():
                raw_sent, vec = emotion(key, labMT, shift=True, happsList=labMTvector)
                temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
                sentiment = emotionV(temp,labMTvector)
                
                this_group_sent.append(sentiment * freqs[key])
                this_group_raw.append(sentiment * freqs[key]) 
            
            sentiment = sum(this_group_sent)/len(this_group_sent)
            raw_sent = sum(this_group_raw)/len(this_group_raw)
            sentiment_column.append(sentiment)
            raw_sent_column.append(raw_sent)
            
            print('Completed:', st, yr)
            e = datetime.datetime.now()
            print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
            print()
                
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




def group_by_state(df):
    print('Beginning grouping by state')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    print()
    
    states = df['state'].unique()

    sentiment_column = []
    raw_sent_column = []
    
    # loop through all states
    for st in states:
        temp_tweets = df[df['state'] == st]
            
        # concatenate all these tweets into one large string
        state_tweets = ''
        for index in range(0, len(temp_tweets)):
            state_tweets += temp_tweets.iloc[index]['text']
            state_tweets += ' '  # add a space onto the end to avoid tweets merging together

        del(temp_tweets)
        
        freqs = get_frequencies(state_tweets)
        
        del(state_tweets)
        
        this_group_sent = []
        this_group_raw = []
        
        for key in freqs.keys():
            raw_sent, vec = emotion(key, labMT, shift=True, happsList=labMTvector)
            temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
            sentiment = emotionV(temp,labMTvector)
            
            this_group_sent.append(sentiment * freqs[key])
            this_group_raw.append(sentiment * freqs[key]) 
        
        sentiment = sum(this_group_sent)/len(this_group_sent)
        raw_sent = sum(this_group_raw)/len(this_group_raw)
        sentiment_column.append(sentiment)
        raw_sent_column.append(raw_sent)
        
        print('Completed:', st)
        e = datetime.datetime.now()
        print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
        print()
    
    # convert to dictionary and then to dataframe
    state_grouped = {'state':states, 'sentiment':sentiment_column, 'raw_sent':raw_sent_column}
    state_grouped = pd.DataFrame(state_grouped)

    
    # save the results to a file to move to R
    state_grouped.to_csv('data/state_sentiment.csv', index = False)
    
    del(state_grouped)
    
    print('Completed sentiment analysis for grouping by state')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))





def group_by_year(df):
    print('Beginning grouping by year')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    print()
    
    years = df['year'].unique()

    sentiment_column = []
    raw_sent_column = []
    
    # loop through all states
    for yr in years:
        temp_tweets = df[df['year'] == yr]
            
        # concatenate all these tweets into one large string
        year_tweets = ''
        for index in range(0, len(temp_tweets)):
            year_tweets += temp_tweets.iloc[index]['text']
            year_tweets += ' '  # add a space onto the end to avoid tweets merging together

        del(temp_tweets)
        
        freqs = get_frequencies(year_tweets)
        
        del(year_tweets)
        
        this_group_sent = []
        this_group_raw = []
        
        for key in freqs.keys():
            raw_sent, vec = emotion(key, labMT, shift=True, happsList=labMTvector)
            temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
            sentiment = emotionV(temp,labMTvector)
            
            this_group_sent.append(sentiment * freqs[key])
            this_group_raw.append(sentiment * freqs[key]) 
        
        sentiment = sum(this_group_sent)/len(this_group_sent)
        raw_sent = sum(this_group_raw)/len(this_group_raw)
        sentiment_column.append(sentiment)
        raw_sent_column.append(raw_sent)
        
        print('Completed:', yr)
        e = datetime.datetime.now()
        print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
        print()
    
    # convert to dictionary and then to dataframe
    year_grouped = {'year':years, 'sentiment':sentiment_column, 'raw_sent':raw_sent_column}
    year_grouped = pd.DataFrame(year_grouped)

    
    # save the results to a file to move to R
    year_grouped.to_csv('data/year_sentiment.csv', index = False)
    
    del(year_grouped)
    
    print('Completed sentiment analysis for grouping by year')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))






df = pd.DataFrame(geotagged_tweets.loc[(geotagged_tweets["state"]!= "Puerto Rico") & (geotagged_tweets["state"] != "Unknown") & (geotagged_tweets['year'] != "")])


group_by_both(df)
group_by_year(df)
group_by_state(df)









