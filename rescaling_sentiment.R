library(dplyr)



# editing the labMT sentiment to range from -1 to 1
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
geotagged <- read.csv('data/geotagged_sentiment_labMT.csv')

geotagged$og_sentiment <- geotagged$sentiment

# first deal with the -1s, which should be NA
geotagged$sentiment[geotagged$sentiment == -1] <- NA

# now rescale to -1 to 1
geotagged$sentiment <- geotagged$sentiment - 5
geotagged$sentiment <- geotagged$sentiment / 4


# write to a file
write.csv(geotagged, 'data/geotagged_sentiment_labMT_scaled.csv')
