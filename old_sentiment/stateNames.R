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



write.csv(stateNames, 'data/state_abbrevs.csv')
