# Exploration Project for STAT 395
# Relates to this research project!
# Developing a network/network statistics from Tweet data


import pandas as pd
import networkx as nx
import matplotlib.pyplot as plt
import statistics
from collections import Counter



# load in the preprocessed tweet data
geotagged_tweets = pd.read_csv('data/tweets_processed.csv', dtype=str)

geotagged_tweets = geotagged_tweets.loc[300000:]

# rename some columns
geotagged_tweets.rename(columns={'tweet_text': 'text'}, inplace=True)
geotagged_tweets.rename(columns={'tweet_created_at': 'created_at'}, inplace=True)

# set to strings
geotagged_tweets['tweet_type'] = geotagged_tweets['tweet_type'].apply(str)
geotagged_tweets['user_id'] = geotagged_tweets['user_id'].apply(str)
geotagged_tweets['author_id'] = geotagged_tweets['author_id'].apply(str)




# use snowballing to build a workable subset from this data set, since it's too large
# to work with in its entirety
# workable = majority of nodes are connected and runtime is reasonable (seconds or minutes)


# uses the dataframe of tweets to build the network, up to max_size nodes
# similar to snowballing; takes all tweets which are comments (either replies or quote
# retweets) and checks if they are responses to any of the other tweets in the dataframe
def build_network_tweets(max_size = 1000000000000):
    G = nx.DiGraph()
    t = list(geotagged_tweets['tweet_id'])
    comments = pd.DataFrame(geotagged_tweets.loc[(geotagged_tweets["tweet_type"] != "unique")])

    for row in range(len(comments)):
        val = str(geotagged_tweets.iloc[row]['referenced_tweets'])
        if val != 'nan':
            val = val.split(' ')
            tweet_id = val[1][3:]
            if tweet_id in t:
                G.add_edge(geotagged_tweets.iloc[row]['tweet_id'], tweet_id)
            # comment out this else statement to ensure more connected nodes
            # else:
            #     G.add_node(geotagged_tweets.iloc[row]['tweet_id'])
        if len(G.nodes()) >= max_size:
            break
    
    return G









# build the network G from the dataframe
# G = build_network_tweets(max_size = 1000)
G = build_network_tweets()

# default draw network
nx.draw(G)
plt.show()

print('Tweet Network statistics:')
degrees = []
nodes = dict(G.in_degree())
for node in nodes.keys():
    if nodes[node] == 0:
        G.remove_node(node)
    else:
        degrees.append(nodes[node])

plt.hist(degrees)
plt.title('Histogram of Tweet In-Degree')
plt.xlabel('Degree')
plt.ylabel('Frequency')
plt.show()

print('Median degree:', statistics.median(degrees))
print('Mean degree:', statistics.mean(degrees))

print(Counter(degrees))

print('Final number of tweets in network:', str(len(G.nodes)))


print()




##### Next try to repeat the above for users rather than just the tweets themselves! #####

# takes in network of tweets and converts to relationships between users
def build_network_users(tweet_net):
    user_net = nx.MultiDiGraph()
    edges = list(tweet_net.edges())
    for edge in edges:
        start = edge[0]
        end = edge[1]
        
        row_start = geotagged_tweets[geotagged_tweets['tweet_id'] == start]
        row_end = geotagged_tweets[geotagged_tweets['tweet_id'] == end]
        
        user_start = row_start['author_id']
        user_start = list(user_start)[0][1:-2]
        
        user_end = row_end['author_id']
        user_end = list(user_end)[0][1:-2]
        
        user_net.add_edge(user_start, user_end)
        
    return user_net
        
    
H = build_network_users(G)

nx.draw(H)
plt.show()

print('User network statistics:')

print('Number of users in network:', str(len(H.nodes)))


# degrees = []
# nodes = dict(H.in_degree())
# for node in nodes.keys():
#     degrees.append(nodes[node])

in_degrees = dict(H.in_degree())

plt.hist(in_degrees.values())
plt.title('Histogram of User In-Degree')
plt.xlabel('Degree')
plt.ylabel('Frequency')
plt.show()

print('Median in-degree:', statistics.median(in_degrees.values()))
print('Mean in-degree:', statistics.mean(in_degrees.values()))

print(Counter(in_degrees.values()))

print()


# degrees = []
# nodes = dict(H.out_degree())
# for node in nodes.keys():
#     degrees.append(nodes[node])

out_degrees = dict(H.out_degree())

plt.hist(out_degrees.values())
plt.title('Histogram of User Out-Degree')
plt.xlabel('Degree')
plt.ylabel('Frequency')
plt.show()

print('Median out-degree:', statistics.median(out_degrees.values()))
print('Mean out-degree:', statistics.mean(out_degrees.values()))

print(Counter(out_degrees.values()))



print()

print("Imbalance (in-degree - out-degree):")

# calculate imbalance = indegree - outdegree
imbalance = {}

for node in list(in_degrees.keys()):
    imbalance[node] = in_degrees[node] - out_degrees[node]
    
plt.hist(imbalance.values())
plt.show()


print(Counter(imbalance.values()))





def build_network_users_noselfloops(tweet_net):
    user_net = nx.MultiDiGraph()
    edges = list(tweet_net.edges())
    for edge in edges:
        start = edge[0]
        end = edge[1]
        
        row_start = geotagged_tweets[geotagged_tweets['tweet_id'] == start]
        row_end = geotagged_tweets[geotagged_tweets['tweet_id'] == end]
        
        user_start = row_start['author_id']
        user_start = list(user_start)[0][1:-2]
        
        user_end = row_end['author_id']
        user_end = list(user_end)[0][1:-2]
        
        if user_start != user_end:
            user_net.add_edge(user_start, user_end)
        
    return user_net
        


H = build_network_users_noselfloops(G)

nx.draw(H)
plt.show()

print('User network statistics:')

print('Number of users in network:', str(len(H.nodes)))


# degrees = []
# nodes = dict(H.in_degree())
# for node in nodes.keys():
#     degrees.append(nodes[node])

in_degrees = dict(H.in_degree())

plt.hist(in_degrees.values())
plt.title('Histogram of User In-Degree')
plt.xlabel('Degree')
plt.ylabel('Frequency')
plt.show()

print('Median in-degree:', statistics.median(in_degrees.values()))
print('Mean in-degree:', statistics.mean(in_degrees.values()))

print(Counter(in_degrees.values()))

print()


# degrees = []
# nodes = dict(H.out_degree())
# for node in nodes.keys():
#     degrees.append(nodes[node])

out_degrees = dict(H.out_degree())

plt.hist(out_degrees.values())
plt.title('Histogram of User Out-Degree')
plt.xlabel('Degree')
plt.ylabel('Frequency')
plt.show()

print('Median out-degree:', statistics.median(out_degrees.values()))
print('Mean out-degree:', statistics.mean(out_degrees.values()))

print(Counter(out_degrees.values()))



print()

print("Imbalance (in-degree - out-degree):")

# calculate imbalance = indegree - outdegree
imbalance = {}

for node in list(in_degrees.keys()):
    imbalance[node] = in_degrees[node] - out_degrees[node]
    
plt.hist(imbalance.values())
plt.show()


print(Counter(imbalance.values()))


