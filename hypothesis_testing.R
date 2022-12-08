# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 


# use this R file to automatically read in the data and rescale the sentiment values
source('rescale_sentiment.R')






# create model