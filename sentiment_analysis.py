import pandas as pd
import pickle
from labMTsimple.storyLab import emotionFileReader, emotion, stopper, emotionV
from importlib import reload
import datetime


# load in the tweet data
with open('data/geotagged_tweets_df.pkl', 'rb') as pickled_tweets:
    geotagged_tweets = pickle.load(pickled_tweets)
    
pickled_tweets.close()

# set up the analyzer
labMT,labMTvector,labMTwordList = emotionFileReader(stopval=0.0,lang='english', returnVector=True)



# There's probably a better way to do this, but this is what I know will work:
    
    
# Declare functions
def group_by_state():
    ### group by state (over all years)
    
    e = datetime.datetime.now()

    print("Beginning grouping")
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    
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
    
    print('Beginning sentiment analysis')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    
    ### for state groups

    # for i in range(0, len(states_grouped)):
    for i in range(0, 1):
        vec = emotion(states_grouped.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[1]
        raw_sent = emotion(states_grouped.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[0]
        temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
        sentiment = emotionV(temp,labMTvector)
        states_grouped.at[i, 'sentiment'] = sentiment
        states_grouped.at[i, 'raw_sentiment'] = raw_sent
    
    # drop the text column since it's huge
    states_grouped = states_grouped.drop(columns = ['text'])
    
    # save the results to a file to move to R
    states_grouped.to_csv('data/state_sentiment.csv', index = False)
    
    del(states_grouped)
    
    print('Completed sentiment analysis for states')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))



def group_by_year():
    ### group by year (over all states)
    
    print('Beginning grouping')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))

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
    
    print('Beginning sentiment analysis for years')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    
    ### for year groups

    for i in range(0, len(years_grouped)):
        vec = emotion(years_grouped.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[1]
        raw_sent = emotion(years_grouped.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[0]
        temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
        sentiment = emotionV(temp,labMTvector)
        years_grouped.at[i, 'sentiment'] = sentiment
        years_grouped.at[i, 'raw_sentiment'] = raw_sent
    
    # drop the text column since it's huge
    years_grouped = years_grouped.drop(columns = ['text'])
    
    # save the results to a file to move to R
    years_grouped.to_csv('data/year_sentiment.csv', index = False)
    
    del(years_grouped)
    
    print('Completed sentiment analysis for years')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    
    
    
def group_by_both():
    ### group by state AND year
    
    print('Beginning grouping')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))
    
    states = geotagged_tweets['state'].unique()
    years = geotagged_tweets['year'].unique()

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

    
    print('Beginning sentiment analysis')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))

    ### for year and state groups
    
    for i in range(0, len(states_years_grouped)):
        vec = emotion(states_years_grouped.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[1]
        raw_sent = emotion(states_years_grouped.iloc[i]['text'], labMT, shift=True, happsList=labMTvector)[0]
        temp = stopper(vec,labMTvector,labMTwordList,stopVal=1.0)
        sentiment = emotionV(temp,labMTvector)
        states_years_grouped.at[i, 'sentiment'] = sentiment
        states_years_grouped.at[i, 'raw_sentiment'] = raw_sent
    
    # drop the text column since it's huge
    states_years_grouped = states_years_grouped.drop(columns = ['text'])
    
    # save the results to a file to move to R
    states_years_grouped.to_csv('data/state_year_sentiment.csv', index = False)
    
    del(states_years_grouped)
    
    print('Completed sentiment analysis for grouping by both')
    e = datetime.datetime.now()
    print ("The current time is %s:%s:%s" % (e.hour, e.minute, e.second))


    



#### RECOMMEND ONLY RUNNING ONE OF THESE AT A TIME ####
group_by_state()
# group_by_year()
# group_by_both()












