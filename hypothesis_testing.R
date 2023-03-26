library(dplyr)


# set working directory to the location of this file
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))


# Recommended but not required to clear environment
rm(list = ls(all.names = TRUE)) 


# use this R file to automatically read in and rescale the data (will take a few seconds)
source('load_corpus_data.R')






### Pair-wise comparisons of sentiments across different groups of tweets ###

## Some functions to help out ## 

# takes in filtered dataframe, returns the raw list of sentiments
get_sent_vector <- function(filtered_df) {
  sents <- rep(filtered_df$sentiment, filtered_df$frequency)
  return(sents)
}

# returns the sd of sentiments from a filtered dataframe
calc_sd <- function(filtered_df) {
  sentiments <- get_sent_vector(filtered_df)
  return(sd(sentiments))
}

quick_pairwise_ttest <- function(cutoff) {
  # check variances and run appropriate test
  # if variances are equal, run ttest with equal variance
  
  # unique vs. replies:
  if (var.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
                get_sent_vector(year_corpus_replies %>% filter(year == cutoff)))$p.value > 0.05) {
    u.r <- t.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
           get_sent_vector(year_corpus_replies %>% filter(year == cutoff)),
           var.equal = TRUE)$p.value
  } else {
    u.r <- t.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
                  get_sent_vector(year_corpus_replies %>% filter(year == cutoff)),
                  var.equal = FALSE)$p.value
  }
  
  # unique vs. qrts:
  if (var.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
               get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)))$p.value > 0.05) {
    u.q <- t.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
                  get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)),
                  var.equal = TRUE)$p.value
  } else {
    u.q <- t.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
                  get_sent_vector(year_corpus_qrt%>% filter(year == cutoff)),
                  var.equal = FALSE)$p.value
  }

  # replies vs. qrts:
  if (var.test(get_sent_vector(year_corpus_replies %>% filter(year == cutoff)), 
               get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)))$p.value > 0.05) {
    r.q <- t.test(get_sent_vector(year_corpus_replies %>% filter(year == cutoff)), 
                  get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)),
                  var.equal = TRUE)$p.value
  } else {
    r.q <- t.test(get_sent_vector(year_corpus_replies %>% filter(year == cutoff)), 
                  get_sent_vector(year_corpus_qrt%>% filter(year == cutoff)),
                  var.equal = FALSE)$p.value
  }
  
  # print quick results
  print(paste('--------------------------------------------------------'))
  print(paste("YEAR =", cutoff))
  
  if (u.r > 0.05) {
    print(paste("Unique vs. Replies: NOT SIGNIFICANT"))
  } else {
    print(paste("Unique vs. Replies: SIGNIFICANT"))
  }
  
  if (u.q > 0.05) {
    print(paste("Unique vs. QRTs:    NOT SIGNIFICANT"))
  } else {
    print(paste("Unique vs. QRTs:    SIGNIFICANT"))
  }
  
  if (r.q > 0.05) {
    print(paste("Replies vs. QRTs:   NOT SIGNIFICANT"))
  } else {
    print(paste("Replies vs. QRTs:   SIGNIFICANT"))
  }
  
}


#### 

cutoff <- 2016

# check sds
calc_sd(year_corpus_unique %>% filter(year == cutoff))
calc_sd(year_corpus_qrt %>% filter(year == cutoff))
calc_sd(year_corpus_replies %>% filter(year == cutoff))

### test for equal variance

# unique vs. replies - EQUAL
var.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
         get_sent_vector(year_corpus_replies %>% filter(year == cutoff)))
# unique vs. qrts - EQUAL
var.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
         get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)))
# replies vs. qrts - UNEQUAL (although barely)
var.test(get_sent_vector(year_corpus_replies %>% filter(year == cutoff)), 
         get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)))

### test difference of means

# unique vs. replies - SIGNIFICANT
t.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
       get_sent_vector(year_corpus_replies %>% filter(year == cutoff)),
       var.equal = TRUE)

# unique vs. qrts - SIGNIFICANT
t.test(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)), 
       get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)),
       var.equal = TRUE)

# replies vs. qrts - NOT SIGNIFICANT
t <- t.test(get_sent_vector(year_corpus_replies %>% filter(year == cutoff)), 
       get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)),
       var.equal = FALSE)


# check normality
cutoff <- 2018
hist(get_sent_vector(year_corpus_all %>% filter(year == cutoff)))
hist(get_sent_vector(year_corpus_unique %>% filter(year == cutoff)))
hist(get_sent_vector(year_corpus_qrt %>% filter(year == cutoff)))
hist(get_sent_vector(year_corpus_replies %>% filter(year == cutoff)))


# quick test for a single year
quick_pairwise_ttest(2016)

# quick test for several years
for (c in 2015:2022) {
  quick_pairwise_ttest(c)
}







