library(dplyr)


geotagged <- read.csv('data/geotagged_sentiment.csv')


# create dataframe matching state names to abbreviations
# https://www.faa.gov/air_traffic/publications/atpubs/cnt_html/appendix_a.html
stateNames <- data.frame(c('Alabama, USA', 'AL'), c('Alaska, USA', 'AK'), c('Arizona, USA', 'AZ'),
                         c('Arkansas, USA', 'AR'), c('American Samoa, USA', 'AS'), c('California, USA', 'CA'),
                         c('Colorado, USA', 'CO'), c('Connecticut, USA', 'CT'), c('Delaware, USA', 'DE'),
                         c('District of Columbia, USA', 'DC'), c('Florida, USA', 'FL'), c('Georgia, USA', 'GA'),
                         c('Guam, USA', 'GU'), c('Hawaii, USA', 'HI'), c('Idaho, USA', 'ID'),
                         c('Illinois, USA', 'IL'), c('Indiana, USA', 'IN'), c('Iowa, USA', 'IA'),
                         c('Kansas, USA', 'KS'), c('Kentucky, USA', 'KY'), c('Louisiana, USA', 'LA'),
                         c('Maine, USA', 'ME'), c('Maryland, USA', 'MD'), c('Massachusetts, USA', 'MA'),
                         c('Michigan, USA', 'MI'), c('Minnesota, USA', 'MN'), c('Mississippi, USA', 'MS'),
                         c('Missouri, USA', 'MO'), c('Montana, USA', 'MT'), c('Nebraska, USA', 'NE'),
                         c('Nevada, USA', 'NV'), c('New Hampshire, USA', 'NH'), c('New Jersey, USA', 'NJ'),
                         c('New Mexico, USA', 'NM'), c('New York, USA', 'NY'), c('North Carolina, USA', 'NC'),
                         c('North Dakota, USA', 'ND'), c('Northern Mariana Islands, USA', 'CM'), c('Ohio, USA', 'OH'),
                         c('Oklahoma, USA', 'OK'), c('Oregon, USA', 'OR'), c('Pennsylvania, USA', 'PA'),
                         c('Puerto Rico, USA', 'PR'), c('Rhode Island, USA', 'RI'), c('South Carolina, USA', 'SC'),
                         c('South Dakota, USA', 'SD'), c('Tennessee, USA', 'TN'), c('Texas, USA', 'TX'),
                         c('Trust Territories, USA', 'TT'), c('Utah, USA', 'UT'), c('Vermont, USA', 'VT'),
                         c('Virginia, USA', 'VA'), c('Virgin Islands, USA', 'VI'), c('Washington, USA', 'WA'),
                         c('West Virginia, USA', 'WV'), c('Wisconsin, USA', 'WI'), c('Wyoming, USA', 'WY'))

stateNames <- as.data.frame(t(stateNames))

names(stateNames) <- c('full_name', 'abbrev')




View(geotagged %>% filter(place_type == 'admin') %>% distinct(full_name, .keep_all = TRUE) %>% 
       filter(substr(full_name, nchar(full_name)-2, nchar(full_name)) == 'USA'))

View(geotagged %>% filter(place_type == 'admin') %>% distinct(full_name, .keep_all = TRUE) %>% 
       filter(substr(full_name, nchar(full_name)-2, nchar(full_name)) != 'USA') %>% mutate(state = NA))



# create dataframe matching state names to abbreviations
source("stateNames.R")





# join that to the geotagged dataframe to get full state data (these lines are just testing)
# temp <- geotagged %>% filter(place_type == 'admin') %>% distinct(full_name, .keep_all = TRUE) %>% 
#                filter(substr(full_name, nchar(full_name)-2, nchar(full_name)) == 'USA')
# 
# 
# t <- merge(x = temp, y = stateNames, by = "full_name", all.x = TRUE)
# t <- t %>% mutate(state = abbrev)
# t <- t %>% select(-abbrev)





# now doing it for real, first with those in the US:
# get the subset of those in the format "stateName, USA" and fetch abbreviation from stateNames dataframe
geotagged_subset1 <- merge(x = geotagged %>% filter(place_type == 'admin') %>% 
                             filter(substr(full_name, nchar(full_name)-2, nchar(full_name)) == 'USA'), 
                           y = stateNames, by = "full_name", all.x = TRUE)

# reassign the abbreviations to the "state" column
geotagged_subset1$state <- geotagged_subset1$abbrev

# remove the superfluous "abbrev" column
geotagged_subset1 <- geotagged_subset1 %>% select(-abbrev)

# reassign state values in the original data set to those from the subset by matching the id
# Note: this takes a hot minute to run
for (id_value in geotagged_subset1$id) {
  geotagged$state[geotagged$id == id_value] <- geotagged_subset1$state[geotagged_subset1$id == id_value]
}


# ignoring the stragglers since there aren't that many (~42):
geotagged_subset2 <- geotagged %>% filter(place_type == 'admin')  %>% 
  filter(substr(full_name, nchar(full_name)-2, nchar(full_name)) != 'USA') %>% mutate(state = NA)

for (id_value in geotagged_subset2$id) {
  geotagged$state[geotagged$id == id_value] <- geotagged_subset2$state[geotagged_subset2$id == id_value]
}



# Ignore this part, it takes literal hours to run and I don't think it's worth it

# # this is going to be slightly redundant to the above, but that's okay:
# 
# # subset starts out as a copy of geotagged
# subset <- data.frame(geotagged)
# 
# # anything that isn't one of the 50 state abbreviations can now be set to NA
# for (index in seq(1, nrow(geotagged))) {
#   if (!(geotagged[index, 'state'] %in% stateNames$abbrev)) {
#     subset <- subset[-c(index), ]
#   }
# }





# write this to a file so I don't have to do it again:
write.csv(geotagged, 'data/geotagged_sentiment_cleaned.csv')



