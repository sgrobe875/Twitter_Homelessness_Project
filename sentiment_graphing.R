# import packages
library(dplyr)
library(ggplot2)
library(gridExtra)



# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 




sent_barplot <- function() {
  # create a dataframe with state and mean sentiment for that state
  state_sent <- geotagged %>% select(state, sentiment) %>% 
                              group_by(state) %>% 
                              mutate(mean_sent = mean(sentiment, na.rm = TRUE))
  
  # use stateNames to match the abbreviations to each state
  state_sent <- merge(state_sent, stateNames, by.x = "state", by.y = "abbrev")
  
  # remove duplicates so each state only appears once, and sort by mean sentiment (descending)
  state_sent <- state_sent %>% distinct(state, .keep_all = TRUE) %>% 
                               select(state, mean_sent) %>% 
                               arrange(mean_sent)
  
  # convert state to a factor so the dataframe holds this ordering
  state_sent <- within(state_sent, state <- factor(state, levels = factor(state_sent$state)))
  
  # plot 
  ggplot(data = state_sent, mapping = aes(x = state, y = mean_sent)) + geom_col() +
    coord_flip() + 
    ggtitle("Mean Compound Sentiment by State (All Years)") + 
    xlab("State") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}





sent_barplot_N <- function(N) {
  # find the total number of tweets for each state
  state_sent <- merge(geotagged, stateNames, by.x = "state", by.y = "abbrev")
  state_sent <- state_sent %>% select(state) %>% group_by(state) %>% count 
  
  # create an additional dataframe of those being ignored (those with number of tweets < N)
  ignored <- state_sent %>% filter(n < N)
  # filter the ignored out of the primary dataset as well
  state_sent <- state_sent %>% filter(n >= N)
  
  # print to the console how many we are ignoring
  print(paste(paste('Ignoring', nrow(ignored), 'due to low sample size', sep = ' ')))
  
  # print the names of the states we are ignoring
  # to avoid clutter, only print if 10 states or fewer
  if (nrow(ignored) < 11) {
    writeLines(ignored$state)
  }
  
  # follow the same steps as in sent_barplot, but this time with the ignored states being removed
  temp <- geotagged %>% select(state, sentiment) %>% group_by(state) %>% mutate(mean_sent = mean(sentiment, na.rm = TRUE))
  state_sent <- merge(temp, state_sent, by.x = "state", by.y = "state")
  state_sent <- state_sent %>% distinct(state, .keep_all = TRUE) %>% select(state, mean_sent) %>% arrange(mean_sent) 
  state_sent <- within(state_sent, state <- factor(state, levels = factor(state_sent$state)))
  
  # plot
  ggplot(data = state_sent, mapping = aes(x = state, y = mean_sent)) + geom_col() +
    coord_flip() + 
    ggtitle(paste("Mean Compound Sentiment by State (All Years, N > ", N, ')', sep = '')) + 
    xlab("State") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}





sent_barplot_by_year <- function(yr) {
  # filter by the inputted year
  state_sent <- geotagged %>% filter(year == yr)
  
  # create a dataframe with state, year, and mean sentiment for that state
  state_sent <- state_sent %>% select(state, sentiment, year) %>% group_by(state) %>% mutate(mean_sent = mean(sentiment, na.rm = TRUE))
  
  # use stateNames to match the abbreviations to each state
  state_sent <- merge(state_sent, stateNames, by.x = "state", by.y = "abbrev")
  
  # remove duplicates so each state only appears once, and sort by mean sentiment (descending)
  state_sent <- state_sent %>% distinct(state, .keep_all = TRUE) %>% select(state, mean_sent, year) %>% arrange(mean_sent)
  
  # convert state to a factor so the dataframe holds this ordering
  state_sent <- within(state_sent, state <- factor(state, levels = factor(state_sent$state)))
  
  # plot 
  ggplot(data = state_sent, mapping = aes(x = state, y = mean_sent)) + geom_col() +
    coord_flip() + 
    ggtitle(paste("Mean Compound Sentiment by State (", as.character(yr), ")", sep='')) + 
    xlab("State") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}



sent_barplot_by_year_facet <- function(yr) {
  # filter by the inputted year
  state_sent <- geotagged %>% filter(year == yr)

  # create a dataframe with state, year, and mean sentiment for that state
  state_sent <- state_sent %>% select(state, sentiment, year) %>% group_by(state) %>% mutate(mean_sent = mean(sentiment, na.rm = TRUE))

  # use stateNames to match the abbreviations to each state
  state_sent <- merge(state_sent, stateNames, by.x = "state", by.y = "abbrev")

  # remove duplicates so each state only appears once, and sort by mean sentiment (descending)
  state_sent <- state_sent %>% distinct(state, .keep_all = TRUE) %>% select(state, mean_sent, year) %>% arrange(mean_sent)

  # convert state to a factor so the dataframe holds this ordering
  state_sent <- within(state_sent, state <- factor(state, levels = factor(state_sent$state)))

  # plot
  ggplot(data = state_sent, mapping = aes(x = state, y = mean_sent)) + geom_col() +
    coord_flip() +
    ggtitle(paste(as.character(yr))) +
    xlab('state') +
    ylab('mean sentiment') +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text.y=element_blank())
}


sent_by_state <- function(st) { 
  # filter by the inputted state
  state_sent <- geotagged %>% filter(state == st)
  
  # create a dataframe with state, year, and mean sentiment for that state
  state_sent <- state_sent %>% select(state, sentiment, year) %>% group_by(year) %>% 
    mutate(mean_sent = mean(sentiment, na.rm = TRUE))
  
  # use stateNames to match the abbreviations to each state
  state_sent <- merge(state_sent, stateNames, by.x = "state", by.y = "abbrev")
  
  # remove duplicates so each year only appears once
  state_sent <- state_sent %>% distinct(year, .keep_all = TRUE) %>% select(state, mean_sent, year) 
  
  # convert year from string to integer
  state_sent$year <- as.numeric(state_sent$year)
  
  # plot 
  ggplot(data = state_sent, mapping = aes(x = year, y = mean_sent)) + geom_col() +
    ggtitle(paste("Mean Compound Sentiment Per Year (", st, ", 2010 - 2018)", sep='')) + 
    xlab("Year") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}



sent_change_by_state <- function(st) {
  # filter by the inputted state
  state_sent <- geotagged %>% filter(state == st)
  
  # create a dataframe with state, year, and mean sentiment for that state
  state_sent <- state_sent %>% select(state, sentiment, year) %>% group_by(year) %>% 
    mutate(mean_sent = mean(sentiment, na.rm = TRUE))
  
  # use stateNames to match the abbreviations to each state
  state_sent <- merge(state_sent, stateNames, by.x = "state", by.y = "abbrev")
  
  # remove duplicates so each year only appears once
  state_sent <- state_sent %>% distinct(year, .keep_all = TRUE) %>% select(state, mean_sent, year) 
  
  # convert year from string to integer
  state_sent$year <- as.numeric(state_sent$year)
  
  # loop through and calculate differences; add to a dataframe
  sent_changes <- data.frame(matrix(ncol = 2, nrow = 0))
  
  years <- c(2011:2018)
  for (yr in years) {
    curr_sent <- state_sent$mean_sent[state_sent$year == yr]     # sentiment for the year in question
    past_sent <- state_sent$mean_sent[state_sent$year == yr-1]   # sentiment for prior year
    diff <- curr_sent - past_sent
    
    row <- c(yr, diff)
    sent_changes <- rbind(sent_changes, row)
  }
  
  # fix column names
  names(sent_changes) <- c('year','change')
  
  # plot 
  ggplot(data = sent_changes, mapping = aes(x = year, y = change)) + geom_col() +
    ggtitle(paste("Changes in Mean Compound Sentiment Per Year (", st, ", 2011 - 2018)", sep='')) + 
    xlab("Year") + 
    ylab("Mean Compound Sentiment") + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=9))
}



facet_year <- function() {
  p1 <- sent_barplot_by_year_facet(2010)
  p2 <- sent_barplot_by_year_facet(2011)
  p3 <- sent_barplot_by_year_facet(2012)
  p4 <- sent_barplot_by_year_facet(2013)
  p5 <- sent_barplot_by_year_facet(2014)
  p6 <- sent_barplot_by_year_facet(2015)
  p7 <- sent_barplot_by_year_facet(2016)
  p8 <- sent_barplot_by_year_facet(2017)
  p9 <- sent_barplot_by_year_facet(2018)
  
  grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, p9, top = 'Mean Compound Sentiment Per State, 2010 - 2018')
}









# read in the state names & abbreviations data
source("stateNames.R")

# read in the file that includes the sentiment analysis results
# geotagged <- read.csv('data/geotagged_sentiment_only.csv')
geotagged <- read.csv('data/geotagged_sentiment_labMT_scaled.csv')






#### Barplot of Sentiment by State ###################

sent_barplot()


######################################################






#### Sentiment by State for >= N tweets ##############

sent_barplot_N(1000)
sent_barplot_N(10000)


######################################################





#### Sentiment by State by Year ######################

sent_barplot_by_year(2010)
sent_barplot_by_year(2011)
sent_barplot_by_year(2012)
sent_barplot_by_year(2013)
sent_barplot_by_year(2014)
sent_barplot_by_year(2015)
sent_barplot_by_year(2016)
sent_barplot_by_year(2017)
sent_barplot_by_year(2018)

facet_year()

######################################################


#### Sentiment per year for a specific state #########

sent_by_state('CA')
sent_change_by_state('CA')

sent_by_state('MA')
sent_change_by_state('MA')


######################################################
















### Create files to share sentiment results in different formats #######

# empty dataframe to hold the results
sentiment_by_state_by_year <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(sentiment_by_state_by_year) <- c("state", "mean_sent", "year")

years <- c(2010:2018)

for (yr in years) {
  # filter by the inputted year
  state_sent <- geotagged %>% filter(year == yr)
  
  # create a dataframe with state, year, and mean sentiment for that state
  state_sent <- state_sent %>% select(state, sentiment, year) %>% group_by(state) %>% mutate(mean_sent = mean(sentiment))
  
  # use stateNames to match the abbreviations to each state
  state_sent <- merge(state_sent, stateNames, by.x = "state", by.y = "abbrev")
  
  # remove duplicates so each state only appears once, and sort by mean sentiment (descending)
  state_sent <- state_sent %>% distinct(state, .keep_all = TRUE) %>% select(state, mean_sent, year) %>% arrange(mean_sent)
  
  # add to the existing dataframe
  sentiment_by_state_by_year <- rbind(sentiment_by_state_by_year, state_sent)
}

write.csv(sentiment_by_state_by_year, "data/sentiment_by_state_by_year.csv")





# File for changes in sentiment (all 50 states, 2011-2018)
sentiment_change_by_state_by_year <- data.frame(matrix(ncol = 3, nrow = 0))
colnames(sentiment_change_by_state_by_year) <- c("state", "year", "change")

for (st in stateNames$abbrev) {
  # filter by the inputted state
  state_sent <- geotagged %>% filter(state == st)
  
  # only proceed if we have data recorded for that state/territory
  if (nrow(state_sent) > 0) {
    # create a dataframe with state, year, and mean sentiment for that state
    state_sent <- state_sent %>% select(state, sentiment, year) %>% group_by(year) %>% 
      mutate(mean_sent = mean(sentiment))
    
    # use stateNames to match the abbreviations to each state
    state_sent <- merge(state_sent, stateNames, by.x = "state", by.y = "abbrev")
    
    # remove duplicates so each year only appears once
    state_sent <- state_sent %>% distinct(year, .keep_all = TRUE) %>% select(state, mean_sent, year) 
    
    # convert year from string to integer
    state_sent$year <- as.numeric(state_sent$year)
    
    # loop through and calculate differences; add to a dataframe
    sent_changes <- data.frame(matrix(ncol = 3, nrow = 0))
    
    years <- c(2011:2018)
    for (yr in years) {
      curr_sent <- state_sent$mean_sent[state_sent$year == yr]     # sentiment for the year in question
      past_sent <- state_sent$mean_sent[state_sent$year == yr-1]   # sentiment for prior year
      diff <- curr_sent - past_sent
      
      row <- c(st, yr, diff)
      sent_changes <- rbind(sent_changes, row)
    }
    
    names(sent_changes) <- c('state', 'year', 'change')
    sentiment_change_by_state_by_year <- rbind(sentiment_change_by_state_by_year, sent_changes)
  }
}


write.csv(sentiment_change_by_state_by_year, "data/sentiment_change_by_state_by_year.csv")







