# Exploration Project for STAT 395
# Relates to this research project!
# Developing a network/network statistics from Tweet data


import pandas as pd
import networkx as nx
from collections import Counter



# load in the preprocessed tweet data
geotagged_tweets = pd.read_csv('data/tweets_processed.csv', dtype=str)

geotagged_tweets = geotagged_tweets.loc[600000:]

# rename some columns
geotagged_tweets.rename(columns={'tweet_text': 'text'}, inplace=True)
geotagged_tweets.rename(columns={'tweet_created_at': 'created_at'}, inplace=True)

# set to strings
geotagged_tweets['tweet_type'] = geotagged_tweets['tweet_type'].apply(str)




# use snowballing to build a workable subset from this data set, since it's too large
# to work with in its entirety
# workable = majority of nodes are connected and runtime is reasonable (seconds or minutes)


# uses the dataframe of tweets to build the network, up to max_size nodes
# similar to snowballing; takes all tweets which are comments (either replies or quote
# retweets) and checks if they are responses to any of the other tweets in the dataframe
def build_network(max_size):
    G = nx.DiGraph()
    t = list(geotagged_tweets['tweet_id'])
    comments = pd.DataFrame(geotagged_tweets.loc[(geotagged_tweets["tweet_type"] != "unique")])
    print('YAY')
    for row in range(len(comments)):
        val = str(geotagged_tweets.iloc[row]['referenced_tweets'])
        if val != 'nan':
            val = val.split(' ')
            tweet_id = val[1][3:]
            if tweet_id in t:
                G.add_edge(geotagged_tweets.iloc[row]['tweet_id'], tweet_id)
            else:
                G.add_node(geotagged_tweets.iloc[row]['tweet_id'])
        if len(G.nodes()) == max_size:
            break









# build the network G from the dataframe
G = build_network(max_size = 500)

# default draw network
nx.draw(G)


