
library(dplyr)
library(ggplot2)
library(tidyverse)



# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))



# inputs: dataframe, the column to be used (as a string), and optionally, an addition to the plot title
calc_and_plot_Zipf <- function(dataframe, columnName, title) {
  # sort largest to smallest and add index column
  columnNo <- which(colnames(dataframe) == columnName)
  data <- dataframe %>% arrange(-dataframe[columnNo])
  data <- tibble::rowid_to_column(data, "index")
  
  # columns shift by 1 since we've now added the index column
  columnNo <- columnNo + 1
  
  # obtain all unique counts (values in V1)
  values <- data %>% distinct(data[columnNo])
  values <- values[ ,1]
  
  # add an empty column to hold the rank
  data <- data %>% mutate(rank = NA)
  
  # fill in the rank column by taking mean of indices for all those with each unique value
  for (i in seq(1, length(values))) {
    val <- values[i]
    data$rank[data[columnName] == val] <- mean(data$index[data[columnName] == val])
  }
  
  
  
  # pretty plot:
  plotTitle <- "Size-Rank Plot for Word Frequencies"
  if (!missing(title)) {
    plotTitle <- paste(plotTitle, " (", title, ")", sep='')
  } 
  
  ggplot(data = data, mapping = aes(x = log10(rank), y = log10(data[,columnNo]))) + 
    geom_point(alpha = 0.5) +
    ggtitle(plotTitle) +
    xlab("Log10(Rank)") + 
    ylab("Log10(Frequency)") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


# same as above, but does not plot, and returns the modified dataframe (with rank and index columns)
calc_Zipf <- function(dataframe, columnName) {
  # sort largest to smallest and add index column
  columnNo <- which(colnames(dataframe) == columnName)
  data <- dataframe %>% arrange(-dataframe[columnNo])
  data <- tibble::rowid_to_column(data, "index")
  
  # columns shift by 1 since we've now added the index column
  columnNo <- columnNo + 1
  
  # obtain all unique counts (values in V1)
  values <- data %>% distinct(data[columnNo])
  values <- values[ ,1]
  
  # add an empty column to hold the rank
  data <- data %>% mutate(rank = NA)
  
  # fill in the rank column by taking mean of indices for all those with each unique value
  for (i in seq(1, length(values))) {
    val <- values[i]
    data$rank[data[columnName] == val] <- mean(data$index[data[columnName] == val])
  }
  
  return(data)
}


# just the plotting portion of the calc_and_plot_Zipf function; use with dataframe from the calc_Zipf function
plot_Zipf <- function(dataframe, columnName, title) {
  columnNo <- which(colnames(dataframe) == columnName)

  # pretty plot:
  plotTitle <- "Size-Rank Plot for Word Frequencies"
  if (!missing(title)) {
    plotTitle <- paste(plotTitle, " (", title, ")", sep='')
  } 
  
  ggplot(data = dataframe, mapping = aes(x = log10(rank), y = log10(dataframe[,columnNo]))) + 
    geom_point(alpha = 0.5) +
    ggtitle(plotTitle) +
    xlab("Log10(Rank)") + 
    ylab("Log10(Frequency)") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}


# same as plot_Zipf function above, but includes the regression line in the plot
plot_Zipf_with_linreg <- function(dataframe, columnName, title) {
  columnNo <- which(colnames(dataframe) == columnName)
  
  # pretty plot:
  plotTitle <- "Size-Rank Plot for Word Frequencies"
  if (!missing(title)) {
    plotTitle <- paste(plotTitle, " (", title, ")", sep='')
  } 
  
  ggplot(data = dataframe, mapping = aes(x = log10(rank), y = log10(dataframe[,columnNo]))) + 
    geom_point(alpha = 0.5) +
    ggtitle(plotTitle) +
    xlab("Log10(Rank)") + 
    ylab("Log10(Frequency)") +
    geom_smooth(method='lm') + 
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), axis.text=element_text(size=11))
}




### Sample runs ##########################3


# read in the data
# testing file (boys names 1952 data from homework 4)
testing <- read.csv("~/Desktop/CSYS300/Assignment04/data/names-boys1952.txt", header = FALSE)


# sample function calls
calc_and_plot_Zipf(testing, 'V3')
t <- calc_Zipf(testing, 'V3')
plot_Zipf(t, 'V3')

# get linear model
model <- lm(data = t, log10(V3) ~ log10(rank))

# print slope of the line to console (for purpose of finding alpha):
model$coefficients[2]

# plot with this linear model
plot_Zipf_with_linreg(t, 'V3', 'with Linear Regression')








