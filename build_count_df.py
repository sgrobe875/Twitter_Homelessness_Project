# import Rbeast as rb  



# beach, year = rb.load_example('beach')
# o = rb.beast(beach, deltat=1/12, freq =12)
# rb.plot(o)
# rb.print(o)




# import Rbeast as rb; (Nile, Year)=rb.load_example('nile'); o=rb.beast(Nile,season='none'); rb.plot(o)


import pandas as pd
from collections import Counter
from datetime import datetime
import matplotlib.pyplot as plt




def get_months(date_time_list):
    return_list = []
    for string in date_time_list:
        try:
            # split string into date and time
            date_time_split = string.split('T')
            # extract just the date
            date = date_time_split[0]
            # year-month = first 7 characters in string
            return_list.append(date[0:7])
        except:
            return_list.append('NA')
        
    return return_list



df = pd.read_csv('data/tweets_processed.csv', dtype=str)



# call get_months with the entire 'created_at' column
df['month'] = get_months(list(df['tweet_created_at']))

        
c = dict(Counter(df['month']))
del c['NA']

counts = pd.DataFrame({'month':list(c.keys()), 'count':list(c.values())})



# Finally, convert to datetimes and sort
months = counts['month']

months = [x + '-01' for x in months]

months = [datetime.strptime(x, '%Y-%m-%d') for x in months]

counts['month'] = months

counts = counts.sort_values(by=['month'])

plt.plot(counts['month'],counts['count'])
plt.title('Number of Tweets Per Month Containing "Homeless"')
plt.xlabel('Time')
plt.ylabel('Number of Tweets')
plt.show()

# now convert back
months = counts['month']

months = [datetime.strftime(x, '%Y-%m-%d') for x in months]

months = [x[:-3] for x in months]

counts['month'] = months


counts.to_csv('data/monthly_counts.csv', index=False)





    















