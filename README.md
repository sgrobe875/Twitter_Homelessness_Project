# Twitter Homelessness Project

## Project Overview

## Methods

## Conclusions

## File hierarchy

### Gathering the tweets

First, tweets were pulled from the Twitter API using the following parameters:

``query = 'homeless lang:en has:geo place_country:US'``\
``start_time = '2010-01-01T00:00:00Z'``\
``end_time = '2020-01-01T00:00:00Z'``

and

``start_time = '2022-01-01T00:00:00Z'``\
``end_time = '2023-01-01T00:00:00Z'``

In plain English, this provided us with all English US-based tweets containing the substring "homeless" from 2010 through 2019, and additionally, 2022. Note that the entirety of 2020 and 2021 were ommitted due to the impacts of the coronavirus pandemic on homelessness counts and data during those years. The tweets were pulled using Python code in 6 month chunks across the entirety of the aforementioned period. These data files spanning 6 months at a time were then amalgamated into a single data file containing all tweets in the specified period, which was saved as *tweets.csv*.

A big thank you to Sean Rogers for providing the Python code used to access tweets from the Twitter API. Note that that code is not included in this repository.

### To build the master data files:
- preprocessing.py
  - **inputs:** tweets.csv
  - **outputs:** tweets_processed.csv
  - takes in raw tweet data (slightly modified from the Twitter API) and creates a preprocessed data set which includes: state in which the tweet was posted; year in which the tweet was posted; tweet type (unique, quote retweet, or reply); and preprocessed tweet text in which any nonalphabetic or nonnumeric characters have been removed
  - the cleaning portion of this script takes several hours to run (estimated 9-10 hours) while the preprocessing portion takes about 3 minutes
- sentiment_analysis_wordfreqs.py
  - **inputs:** tweets_processed.csv
  - **outputs:** month_sentiment.csv; day_sentiment.csv; state_year_sentiment.csv; year_sentiment.csv; state_sentiment.csv; month_sentiment_qrt.csv; day_sentiment_qrt.csv; state_year_sentiment_qrt.csv; year_sentiment_qrt.csv; state_sentiment_qrt.csv; month_sentiment_replies.csv; day_sentiment_replies.csv; state_year_sentiment_replies.csv; year_sentiment_replies.csv; state_sentiment_replies.csv
  - takes in the preprocessed data set created by *preprocessing.py* and outputs files of sentiment results according to various groupings
  - running the daily sentiment analysis functions are not recommended, as they are particularly computationally expensive; running all functions in the script except for the daily sentiment functions takes roughly 6 hours
  - function calls at the end of the script should be commented/uncommented as needed to save on time and space complexity
- build_master_files.R

### Once master data files have been created:
- eda.R 
- Any and all of the graphing/plotting R files 
  - Note that unshelt_homelessness_plotting.R is no longer compatible with the available data, which is fine
  for the purposes of this project
- hypothesis_testing.R
