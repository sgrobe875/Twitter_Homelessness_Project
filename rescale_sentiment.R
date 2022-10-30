# editing the labMT sentiment to range from -1 to 1
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
state_sent <- read.csv('data/state_sentiment.csv')
year_sent <- read.csv('data/year_sentiment.csv')
state_year_sent <- read.csv('data/state_year_sentiment.csv')



# now rescale to -1 to 1
state_sent$sentiment <- state_sent$sentiment - 5
state_sent$sentiment <- state_sent$sentiment / 4

year_sent$sentiment <- year_sent$sentiment - 5
year_sent$sentiment <- year_sent$sentiment / 4

state_year_sent$sentiment <- state_year_sent$sentiment - 5
state_year_sent$sentiment <- state_year_sent$sentiment / 4
