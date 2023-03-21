library(Rbeast)
library(dplyr)


# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 


# use this R file to automatically read in the relevant data files all at once
source('load_data.R')


use_beast <- function(df) {
  # filter out 2010
  df2 <- data.frame()
  for (i in seq(1:nrow(df))) {
    m = df[i, 'month']
    if (substr(m,1,4) != '2010') {
      df2 <- rbind(df2, df[i,])
    }
  }
  
  # convert months to dates
  df2 <- df2 %>% mutate(month = paste(month, '-01', sep=''))
  df2$month <- as.Date(df2$month)
  
  # sort by month
  df2 <- df2 %>% arrange(month)
  
  beast(y = df2$sentiment,
        start = df2[1,'month'],
        deltat = 1/12,
        season = 'harmonic',
        period = '12 months'
        )
  
  return(df2)
}



df2 <- use_beast(month_sent_all)
