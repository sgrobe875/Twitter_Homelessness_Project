# Twitter Homelessness Project

## Project Overview
The goal of this project is to develop a proxy measure for local homelessness rates in the U.S. using Twitter data. We hope to find a way to leverage relationships between relevant tweets, specifically their sentiment and volume, and total homelessness counts in order to be able to predict homelessness in the future. Much of this project up to this point has been exploratory, with a big focus on refining the preprocessing and sentiment analysis portions, and creating visualizations of many of the variables and their potential relationships with each other. Further analyses on these relationships include hypothesis testing using simple linear regression and two sample t-tests, as well as the BEAST algorithm to help identify and isolate trends and seasonal behavior in time series data.

## File hierarchy

### Gathering the tweets

First, tweets were pulled from the Twitter API using the following parameters:

``query = 'homeless lang:en has:geo place_country:US'``\
``start_time = '2010-01-01T00:00:00Z'``\
``end_time = '2023-01-01T00:00:00Z'``


In plain English, this provided us with all English US-based tweets containing the substring "homeless" from 2010 through 2022. Note that while we do pull tweets from 2020 and 2021, we do not utilize any homelessness counts during these years due to their inaccuracies resulting from the coronavirus pandemic. The tweets were pulled using Python code in 6 month chunks across the entirety of the aforementioned period. These data files spanning 6 months at a time were then amalgamated into a single data file containing all tweets in the specified period, which was saved as *tweets.csv*.

A big thank you to Sean Rogers for providing the Python code used to access tweets from the Twitter API. Note that that code is not included in this repository.

### To build the master data files:
- preprocessing.py
  - **inputs:** tweets.csv
  - **outputs:** tweets_processed.csv
  - takes in raw tweet data (slightly modified from the Twitter API) and creates a preprocessed data set which includes: state in which the tweet was posted; year in which the tweet was posted; tweet type (unique, quote retweet, or reply); and preprocessed tweet text in which any nonalphabetic or nonnumeric characters have been removed
  - On the most recent execution, this file took about 10.5 hours for the cleaning portion, and about 7 minutes for the text preprocessing portion. While optimization is certainly possible, it is not considered a priority for this project since this script is not being executed repeatedly.
- sentiment_analysis_wordfreqs.py
  - **inputs:** tweets_processed.csv
  - **outputs:** month_sentiment.csv; day_sentiment.csv; state_year_sentiment.csv; year_sentiment.csv; state_sentiment.csv; month_sentiment_qrt.csv; day_sentiment_qrt.csv; state_year_sentiment_qrt.csv; year_sentiment_qrt.csv; state_sentiment_qrt.csv; month_sentiment_replies.csv; day_sentiment_replies.csv; state_year_sentiment_replies.csv; year_sentiment_replies.csv; state_sentiment_replies.csv
  - takes in the preprocessed data set created by *preprocessing.py* and outputs files of sentiment results according to various groupings
  - running the daily sentiment analysis functions are not recommended, as they are particularly computationally expensive; running all functions in the script except for the daily sentiment functions takes roughly 6 hours
  - function calls at the end of the script should be commented/uncommented as needed to save on time and space complexity
- build_master_files.R
  - **inputs:** percapita_total.csv, percapita_tweets.csv, percapita_annual_changes_total.csv; all *sentiment_analysis_wordfreqs.py* outputs
  - **outputs:** state_year_master.csv
  - joins all data recorded in state-years into a single file, which can then be used for a majority of subsequent graphs and analyses
  - since some of the data is missing for 2020 and 2021 (e.g., homelessness rates), this data file only contains state-year data for 2010-2019 and 2022; for state-year sentiment during these two missing years, the data file *state_year_sentiment.csv* should be used

### Once master data files have been created:
- eda.R 
- Any and all of the graphing/plotting R files 
  - Note that unshelt_homelessness_plotting.R is no longer compatible with the available data, which is fine
  for the purposes of this project
- hypothesis_testing.R
- time_series_analysis.py
- time_series_analysis.R

### Miscellaneous files
- load_data.R
  - This file is nested within all graphing R files as a cleaner way to load in all necessary data files at once in a single line
  - Reads in relevant data files and rescales the sentiment columns from the default [1,9] to a more accessible [-1,1]
- load_corpus_data.R
  - This file is nested within all hypothesis testing R files as a cleaner way to load in all necessary data files at once in a single line
  - Reads in relevant data files and rescales the sentiment columns from the default [1,9] to a more accessible [-1,1]
- network.py
  - Written as a final project for another UVM course (STAT 395) using this same data set
  - Builds a network of tweet comments within the scope of the data set and calculates some basic network statistics
  - Provides an additional way of visualizing part of the data set
