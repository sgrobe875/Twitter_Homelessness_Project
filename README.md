# Twitter Homelessness Project


## File hierarchy
- cleaning.py
  - inputs: all_geotagged_tweets.csv
  - outputs: geotagged_cleaned.csv
- text_preprocessing.py
  - inputs: geotagged_cleaned.csv
  - outputs: geotagged_processed.csv
- sentiment_analysis_wordfreqs.py
  - inputs: geotagged_processed.csv
  - outputs: month_sentiment.csv; day_sentiment.csv; state_year_sentiment.csv; year_sentiment.csv; state_sentiment.csv; month_sentiment_qrt.csv; day_sentiment_qrt.csv; state_year_sentiment_qrt.csv; year_sentiment_qrt.csv; state_sentiment_qrt.csv; month_sentiment_rt.csv; day_sentiment_rt.csv; state_year_sentiment_rt.csv; year_sentiment_rt.csv; state_sentiment_rt.csv
- creating_datafiles.R
- eda.R 
- Any and all of the graphing/plotting R files 
  - Note that unshelt_homelessness_plotting.R is no longer compatible with the available data, which is fine
  for the purposes of this project
- hypothesis_testing.R
