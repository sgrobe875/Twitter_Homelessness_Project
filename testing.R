library(dplyr)
library(ggplot2)



# Recommended to run this line to clear environment, especially if cleaning.R was recently run:
rm(list = ls(all.names = TRUE)) 




sent_barplot <- function() {
  state_sent <- geotagged %>% select(state, sentiment) %>% group_by(state) %>% mutate(mean_sent = mean(sentiment))
  state_sent <- merge(state_sent, stateNames, by.x = "state", by.y = "abbrev")
  state_sent <- state_sent %>% distinct(state, .keep_all = TRUE) %>% select(state, mean_sent) %>% arrange(mean_sent) 
  state_sent <- within(state_sent, state <- factor(state, levels = factor(state_sent$state)))
  ggplot(data = state_sent, mapping = aes(x = state, y = mean_sent)) + geom_col() +
    coord_flip() + 
    scale_y_continuous(expand = c(0, 0)) +
    ggtitle("Mean Compound Sentiment by State") + 
    xlab("State") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}





sent_barplot_N <- function(N) {
  state_sent <- merge(geotagged, stateNames, by.x = "state", by.y = "abbrev")
  state_sent <- state_sent %>% select(state) %>% group_by(state) %>% count 
  ignored <- state_sent %>% filter(n < N)
  state_sent <- state_sent %>% filter(n >= N)
  print(paste(paste('Ignoring', nrow(ignored), 'due to low sample size', sep = ' ')))
  
  # to avoid clutter, only print if 10 or fewer
  if (nrow(ignored) < 11) {
    writeLines(ignored$state)
  }
  
  temp <- geotagged %>% select(state, sentiment) %>% group_by(state) %>% mutate(mean_sent = mean(sentiment))
  state_sent <- merge(temp, state_sent, by.x = "state", by.y = "state")
  state_sent <- state_sent %>% distinct(state, .keep_all = TRUE) %>% select(state, mean_sent) %>% arrange(mean_sent) 
  state_sent <- within(state_sent, state <- factor(state, levels = factor(state_sent$state)))
  ggplot(data = state_sent, mapping = aes(x = state, y = mean_sent)) + geom_col() +
    coord_flip() + 
    scale_y_continuous(expand = c(0, 0.001)) +
    ggtitle(paste("Mean Compound Sentiment by State (N > ", N, ')', sep = '')) + 
    xlab("State") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}










# read in the cleaned data
source("stateNames.R")
# geotagged <- read.csv('data/geotagged_sentiment_cleaned.csv')
geotagged <- read.csv('data/geotagged_sentiment_THIS_ONE.csv')







#### Barplot of Sentiment by State ###################

sent_barplot()


######################################################






#### Sentiment by State for >= N tweets #############

sent_barplot_N(1000)
sent_barplot_N(10000)


#####################################################

