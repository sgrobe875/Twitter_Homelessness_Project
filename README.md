# Twitter Homelessness Project


## File hierarchy
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
- creating_datafiles.R
- eda.R 
- Any and all of the graphing/plotting R files 
  - Note that unshelt_homelessness_plotting.R is no longer compatible with the available data, which is fine
  for the purposes of this project
- hypothesis_testing.R
