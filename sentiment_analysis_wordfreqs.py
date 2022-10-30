import pandas as pd
import pickle
from labMTsimple.storyLab import emotionFileReader, emotion, stopper, emotionV
from importlib import reload
import datetime
from string import punctuation
import nltk
from nltk.corpus import stopwords
from collections import Counter
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
    word_frequencies = Counter(words)     ## This is where I changed the dictionary into a Counter, which is basically a dictionary
    return word_frequencies
            

def group_by_both(df):
    print('Beginning grouping by both')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    print()
    
    states = df['state'].unique()
    years = df['year'].unique()
    
    # columns for the final dataframe
    states_col = []
    years_col = []
    sentiment_column = []
    raw_sent_column = []
    
    
    # loop through all states
    for st in states:
        temp_st = df[df['state'] == st]

        # loop through all years within states
        for yr in years:
            # record the current state and year
            states_col.append(st)
            years_col.append(yr)
            
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
            
            # need this line to avoid a ValueError in the for loop 
            keys = list(freqs.keys())
            
            # loop through all keys in the dict (unique words in the group tweets)
            for key in keys:
                raw_sent, vec = emotion(key, labMT, shift=True, happsList=labMTvector)
                temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
                sentiment = emotionV(temp,labMTvector)
                
                # negative sentiment means cannot be sentimentized, so let's remove it
                if raw_sent < 0 or sentiment < 0:
                    freqs.pop(key)
                
                # if it was successfully sentimentized, append to the list so we can calc the avg
                else:
                    this_group_sent.append(sentiment * freqs[key])
                    this_group_raw.append(raw_sent * freqs[key]) 
            
            # get the total number of words in the mega_sting (must be done after the for loop!)
            num_words = sum(freqs.values())
            
            sentiment = sum(this_group_sent)/num_words
            raw_sent = sum(this_group_raw)/num_words
            
            sentiment_column.append(sentiment)
            raw_sent_column.append(raw_sent)
            
            print('Completed:', st, yr)
            e = datetime.datetime.now()
            print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
            print()
                
    del(temp_st)
    
    # convert to dictionary and then to dataframe
    state_years_grouped = {'state':states_col, 'year': years_col, 'sentiment':sentiment_column, 'raw_sent':raw_sent_column}
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
        
        # need this line to avoid a ValueError in the for loop 
        keys = list(freqs.keys())
        
        for key in keys:
            raw_sent, vec = emotion(key, labMT, shift=True, happsList=labMTvector)
            temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
            sentiment = emotionV(temp,labMTvector)
            
            # negative sentiment means cannot be sentimentized, so let's remove it
            if raw_sent < 0 or sentiment < 0:
                freqs.pop(key)
            
            # if it was successfully sentimentized, append to the list so we can calc the avg
            else:
                this_group_sent.append(sentiment * freqs[key])
                this_group_raw.append(raw_sent * freqs[key]) 
        
        # get the total number of words in the mega_sting (must be done after the for loop!)
        num_words = sum(freqs.values())
        
        sentiment = sum(this_group_sent)/num_words
        raw_sent = sum(this_group_raw)/num_words
        
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
        
        # need this line to avoid a ValueError in the for loop 
        keys = list(freqs.keys())
        
        for key in keys:
            raw_sent, vec = emotion(key, labMT, shift=True, happsList=labMTvector)
            temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
            sentiment = emotionV(temp,labMTvector)
            
            # negative sentiment means cannot be sentimentized, so let's remove it
            if raw_sent < 0 or sentiment < 0:
                freqs.pop(key)
            
            # if it was successfully sentimentized, append to the list so we can calc the avg
            else:
                this_group_sent.append(sentiment * freqs[key])
                this_group_raw.append(raw_sent * freqs[key]) 

        
        # get the total number of words in the mega_sting (must be done after the for loop!)
        num_words = sum(freqs.values())
        
        sentiment = sum(this_group_sent)/num_words
        raw_sent = sum(this_group_raw)/num_words
        
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



def get_months(date_time_list):
    return_list = []
    for string in date_time_list:
        # split string into date and time
        date_time_split = string.split('T')
        # extract just the date
        date = date_time_split[0]
        # year-month = first 7 characters in string
        return_list.append(date[0:7])
        
    return return_list


def get_days(date_time_list):
    return_list = []
    for string in date_time_list:
        # split string into date and time
        date_time_split = string.split('T')
        # extract just the date
        date = date_time_split[0]
        return_list.append(date)
        
    return return_list


def group_by_month(df):
    # begin by building the month column
    print('Building month column')          
            
    df['month'] = get_months(list(df['created_at']))
    
    # group by month
    print('Beginning grouping by month')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    print()
    
    months = df['month'].unique()

    sentiment_column = []
    raw_sent_column = []
    
    # loop through all states
    for m in months:
        temp_tweets = df[df['month'] == m]
            
        # concatenate all these tweets into one large string
        month_tweets = ''
        for index in range(0, len(temp_tweets)):
            month_tweets += temp_tweets.iloc[index]['text']
            month_tweets += ' '  # add a space onto the end to avoid tweets merging together

        del(temp_tweets)
        
        freqs = get_frequencies(month_tweets)
        
        del(month_tweets)
        
        this_group_sent = []
        this_group_raw = []
        
        # need this line to avoid a ValueError in the for loop 
        keys = list(freqs.keys())
        
        for key in keys:
            raw_sent, vec = emotion(key, labMT, shift=True, happsList=labMTvector)
            temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
            sentiment = emotionV(temp,labMTvector)
            
            # negative sentiment means cannot be sentimentized, so let's remove it
            if raw_sent < 0 or sentiment < 0:
                freqs.pop(key)
            
            # if it was successfully sentimentized, append to the list so we can calc the avg
            else:
                this_group_sent.append(sentiment * freqs[key])
                this_group_raw.append(raw_sent * freqs[key]) 

        
        # get the total number of words in the mega_sting (must be done after the for loop!)
        num_words = sum(freqs.values())
        
        sentiment = sum(this_group_sent)/num_words
        raw_sent = sum(this_group_raw)/num_words
        
        sentiment_column.append(sentiment)
        raw_sent_column.append(raw_sent)
        
        print('Completed:', m)
        e = datetime.datetime.now()
        print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
        print()
    
    # convert to dictionary and then to dataframe
    month_grouped = {'month':months, 'sentiment':sentiment_column, 'raw_sent':raw_sent_column}
    month_grouped = pd.DataFrame(month_grouped)

    
    # save the results to a file to move to R
    month_grouped.to_csv('data/month_sentiment.csv', index = False)
    
    del(month_grouped)
    
    print('Completed sentiment analysis for grouping by month')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))



def group_by_day(df):
    # begin by building the day column
    print('Building day column')
            
    df['day'] = get_days(list(df['created_at']))
    
    # group by day
    print('Beginning grouping by day')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    print()
    
    days = df['day'].unique()

    sentiment_column = []
    raw_sent_column = []
    
    # loop through all states
    for d in days:
        temp_tweets = df[df['day'] == d]
            
        # concatenate all these tweets into one large string
        day_tweets = ''
        for index in range(0, len(temp_tweets)):
            day_tweets += temp_tweets.iloc[index]['text']
            day_tweets += ' '  # add a space onto the end to avoid tweets merging together

        del(temp_tweets)
        
        freqs = get_frequencies(day_tweets)
        
        del(day_tweets)
        
        this_group_sent = []
        this_group_raw = []
        
        # need this line to avoid a ValueError in the for loop 
        keys = list(freqs.keys())
        
        for key in keys:
            raw_sent, vec = emotion(key, labMT, shift=True, happsList=labMTvector)
            temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
            sentiment = emotionV(temp,labMTvector)
            
            # negative sentiment means cannot be sentimentized, so let's remove it
            if raw_sent < 0 or sentiment < 0:
                freqs.pop(key)
            
            # if it was successfully sentimentized, append to the list so we can calc the avg
            else:
                this_group_sent.append(sentiment * freqs[key])
                this_group_raw.append(raw_sent * freqs[key]) 

        
        # get the total number of words in the mega_sting (must be done after the for loop!)
        num_words = sum(freqs.values())
        
        sentiment = sum(this_group_sent)/num_words
        raw_sent = sum(this_group_raw)/num_words
        
        sentiment_column.append(sentiment)
        raw_sent_column.append(raw_sent)
        
        print('Completed:', d)
        e = datetime.datetime.now()
        print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
        print()
    
    # convert to dictionary and then to dataframe
    day_grouped = {'day':days, 'sentiment':sentiment_column, 'raw_sent':raw_sent_column}
    day_grouped = pd.DataFrame(day_grouped)

    
    # save the results to a file to move to R
    day_grouped.to_csv('data/day_sentiment.csv', index = False)
    
    del(day_grouped)
    
    print('Completed sentiment analysis for grouping by day')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))



####################################



df = pd.DataFrame(geotagged_tweets.loc[(geotagged_tweets["state"]!= "Puerto Rico") & (geotagged_tweets["state"] != "Unknown") & (geotagged_tweets['year'] != "")])

group_by_month(df)
group_by_day(df)


# group_by_both(df)
# group_by_year(df)
# group_by_state(df)









