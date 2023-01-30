import pandas as pd
import matplotlib.pyplot as plt
import numpy as np
import datetime
import gzip
import statsmodels.tsa.seasonal as sm
from statsmodels.graphics.tsaplots import plot_acf
import pandas as pd
import math
from statistics import variance as var
import pycircular
import matplotlib.ticker as mticker



# reference for analysis: 
# https://towardsdatascience.com/time-series-decomposition-in-python-8acac385a5b2



# read in data files
month_sent = pd.read_csv('data/sentiment/month_sentiment.csv')
month_sent_unique = pd.read_csv('data/sentiment/month_sentiment_unique.csv')
month_sent_replies = pd.read_csv('data/sentiment/month_sentiment_replies.csv')
month_sent_qrt = pd.read_csv('data/sentiment/month_sentiment_qrt.csv')



dataframes = [month_sent, month_sent_unique, month_sent_replies, month_sent_qrt]


# clean up all of the inputted dataframes
for df in dataframes:
    # rescale sentiment
    df['sentiment'] = (df['sentiment'] - 5) / 4
    # convert all months to datetimes
    for row in range(len(df)):
        df.at[row, 'month'] = datetime.datetime.strptime(df.iloc[row]['month'], "%Y-%m")
    # sort the dataframe by datetime (chronological order, ascending)
    df.sort_values(by = ['month'], inplace = True, ignore_index = True)
    # rename this column of datetimes
    df.rename(columns={'month':'month_dt'}, inplace=True)
    # convert dates back to strings and save that as a separate column
    month = []
    for row in range(len(df)):
        month.append(datetime.datetime.strftime(df.iloc[row]['month_dt'], "%Y-%m"))
    df['month'] = month
    
    months = list(df['month'])
    years = []
    raw_month = []
    
    for i in range(len(months)):
        years.append(months[i][:-3])
        raw_month.append(months[i][-2:])
    
    df['year'] = years
    df['raw_month'] = raw_month
    




# performs detrending on the inputted dataframe sentiment data and plots it vs.
# the original data
def detrend(df, t2):
    fig_trend, ax_trend = plt.subplots()
    
    x = df['month']
    y = df['sentiment']
    
    data = pd.DataFrame({"time" : x, "original" : y})
    
    data["detrended"] = data["original"].diff()
    ax_trend = data.plot()
    ax_trend.legend(ncol=5, 
              loc='lower center',
              # bbox_to_anchor=(0.5, 1.0),
              bbox_transform=plt.gcf().transFigure)
    
    title = "Monthly Sentiment Over Time " + t2
    ax_trend.set_title(title)
    mLabels = []
    for i in range(len(x)): 
        if i%12 == 0:
            mLabels.append("Jan " + x[i][0:4])
        else:
            mLabels.append("")
            
    x2 = np.arange(len(x))
    distance_between_ticks = 12
    # reduced_xticks = x2[np.arange(0, len(x2), distance_between_ticks)]
    
    ax_trend.set_xticks(x2)
    
    ax_trend.set_title(title)
    ax_trend.set_ylabel("Sentiment")
    
    ax_trend.set_xticklabels(mLabels)
    plt.xlabel("Time")
    
    plt.xticks(rotation = 45)
    plt.title(title)
    plt.show()
    
    
    data["detrended"].iloc[0] = 0
    plt.acorr(data["detrended"], maxlags = 12)
    title = "Autocorrelation for Monthly Sentiment " + t2 
    plt.title(title)
    plt.xlabel("Lags")
    plt.show()
    
    #####
    
    fig, ax = plt.subplots()
    title = "Autocorrelation for Monthly Sentiment " + t2 + "\n(detrended)"
    ax.set_title(title)
    plt.xlabel("Lags")
    plot_acf(data["detrended"], bartlett_confint = False, ax = ax, title = title)
    
    plt.show()
    
    
    
    
def seasonality(df, t2):
    x = df['month']

    
    result = sm.seasonal_decompose(df["sentiment"], model='additive', period=12)
        
    fig, ax1 = plt.subplots()
    result.trend.plot(ax=ax1,ylabel = "trend")

    plt.title("Trend of Monthly Sentiment Over Time " + t2)
    
    
    plt.xlabel("Time")

    
    plt.xticks(rotation = 45)
    
        
    mLabels = []
    for i in range(len(x)): 
        if i%12 == 0:
            mLabels.append("Jan " + x[i][0:4])
        else:
            mLabels.append("")

    
    x2 = np.arange(len(x))
    distance_between_ticks = 12
    # reduced_xticks = x2[np.arange(0, len(x2), distance_between_ticks)]
    
    ax1.set_xticks(x2)
    
    #ax.set_title(title)
    ax1.set_ylabel("Sentiment")
    
    # ax1.set_xticklabels(x)
    ax1.set_xticklabels(mLabels)
    plt.xlabel("Time")
    
    plt.xticks(rotation = 45)

    
    plt.show()
    

    
    p = result.seasonal

    
    
    plt.xlabel("Time")
    title = "Seasonality of Monthly Sentiment Over Time " + t2
    
    plt.xticks(rotation = 45)

    fig, ax = plt.subplots()
    
    x2 = np.arange(len(x))
    distance_between_ticks = 12
    # reduced_xticks = x2[np.arange(0, len(x2), distance_between_ticks)]
    
    ax.set_xticks(x2)
    
    ax.set_title(title)
    ax.set_ylabel("Sentiment")
    
    ax.set_xticklabels(mLabels)
    plt.xlabel("Time")
    
    plt.xticks(rotation = 45)
    
    plt.plot(x, p)

    
    newYears = ['2010-01', '2011-01', '2012-01', '2013-01', '2014-01',
                '2015-01', '2016-01', '2017-01', '2018-01', '2019-01',
                '2020-01', '2021-01', '2022-01']
    
    for year in newYears:
        for date in x:
            if year == date:
                plt.axvline(x = date, color = 'red', linestyle = 'dashed')
                
            

    plt.show()
    
def overlaid_by_year(og_df):
    
    df = og_df.copy()
    
    # months = list(df['month'])
    # years = []
    # raw_month = []
    
    # for i in range(len(months)):
    #     years.append(months[i][:-3])
    #     raw_month.append(months[i][-2:])
    
    # df['year'] = years
    # df['raw_month'] = raw_month
    
    # lay all years on top of each other
    fig, ax2 = plt.subplots()
    
    for yr in range(2011, 2023):
        yr = str(yr)
        df_slice = df[df.year == yr]
        
        plt.plot(df_slice['raw_month'], df_slice['sentiment'])
        
    plt.xticks(rotation = 45)
    
    labels = list(range(2011, 2023))
    ax2.legend(labels, loc='center left', bbox_to_anchor=(1, 0.5))

    
    plt.show()
    
    
    # zoom in on September - December
    zoom_months = {'01':'January', '02':'February', '03':'March',
                   '04':'April', '05':'May', '06':'June'}
    for yr in range(2011, 2023):
        # zoom_df = pd.DataFrame(columns = list(df_slice.columns))
        # zoom_df.columns = list(df_slice.columns)
        yr = str(yr)
        df_slice = df[df.year == yr]
        sent = []
        for i in range(len(df_slice)):
            if df_slice.iloc[i]['raw_month'] in zoom_months.keys():
                # temp = pd.DataFrame(df_slice.iloc[i])
                # zoom_df.append(temp)
                sent.append(df_slice.iloc[i]['sentiment'])
        
        # plt.plot(zoom_months, zoom_df['sentiment'])
        plt.plot(zoom_months.values(), sent)
        
    # plt.xticks(rotation = 45)
    
    labels = list(range(2011, 2023))
    ax2.legend(labels, loc='center left', bbox_to_anchor=(1, 0.5))

    
    plt.show()
    
    
    # zoom in on September - December
    zoom_months = {'07':'July', '08':'August', '09':'September','10':'October',
                   '11':'November','12':'December'}
    for yr in range(2011, 2023):
        # zoom_df = pd.DataFrame(columns = list(df_slice.columns))
        # zoom_df.columns = list(df_slice.columns)
        yr = str(yr)
        df_slice = df[df.year == yr]
        sent = []
        for i in range(len(df_slice)):
            if df_slice.iloc[i]['raw_month'] in zoom_months.keys():
                # temp = pd.DataFrame(df_slice.iloc[i])
                # zoom_df.append(temp)
                sent.append(df_slice.iloc[i]['sentiment'])
        
        # plt.plot(zoom_months, zoom_df['sentiment'])
        plt.plot(zoom_months.values(), sent)
        
    # plt.xticks(rotation = 45)
    
    labels = list(range(2011, 2023))
    ax2.legend(labels, loc='center left', bbox_to_anchor=(1, 0.5))

    
    plt.show()
    



# reference: https://towardsdatascience.com/introducing-pycircular-a-python-library-for-circular-data-analysis-bfd696a6a42b
def date2rad(dates, time_segment='hour'):

    if time_segment == 'hour':

        radians = dates * 2 * np.pi / 24

        # Fix to rotate the clock and move PI / 2
        # https://en.wikipedia.org/wiki/Clock_angle_problem

        radians = - radians + np.pi/2

    elif time_segment == 'dayweek':

        # Day of week goes counter-clockwise
        radians = dates * 2 * np.pi / 7 + np.pi/2

    elif time_segment == 'daymonth':

        # Day of month goes counter-clockwise
        radians = dates * 2 * np.pi / 31 + np.pi/2
        # TODO: check what to do with last day of month
        
    ### SG ##################################
    elif time_segment == 'monthyear':

        # Day of month goes counter-clockwise
        radians = dates * 2 * np.pi / 12 + np.pi/2
    #########################################

    # Change to be in [0, 2*pi]
    radians1 = []
    for i in radians:
        if(i<0):
            radians1.append(i+2*np.pi)
        
        elif(i>(2*np.pi)):
            radians1.append(i-2*np.pi)
        
        else:
            radians1.append(i) 
        

    return radians1


def freq_time(dates, time_segment='hour', freq=True, continious=True):
    # Get frequency per time_segment
    dates_index = pd.DatetimeIndex(dates)

    # calculate times
    # times = dates_index.hour + dates_index.minute / 60 + dates_index.second / 60 / 100
    times = dates_index.month / 12 / 100

    if time_segment == 'hour':

        time_temp = dates_index.hour

    elif time_segment == 'dayweek':

        time_temp = dates_index.dayofweek  # Monday=0, Sunday=6
        times = time_temp + times / 24

    elif time_segment == 'daymonth':

        time_temp = dates_index.day
        times = time_temp + times / 24
        
        
    #### SG ######################
    elif time_segment == 'monthyear':

        time_temp = dates_index.month
        times = time_temp + times / 12
    ##############################

    freq_arr = None

    if freq:
        freq_ = pd.Series(time_temp).value_counts()
        freq_ = freq_ / freq_.sum()

        freq_arr = np.zeros((freq_.shape[0], 2))  # Hour, freq
        freq_arr[:, 0] = freq_.index
        freq_arr[:, 1] = freq_.values
        
    else:
        freq_arr = []

    if continious:
        return freq_arr, times
    else:
        return freq_arr, time_temp




# def base_periodic_fig(dates, freq, bottom=0, ymax=1,
#                       rescale=True, figsize=(8, 8),
#                       time_segment='hour', fig=None, ax1=None):
def base_periodic_fig(dates, sentiment, bottom=0, ymax=1,
                      rescale=True, figsize=(8, 8),
                      time_segment='hour', fig=None, ax1=None):

    # if rescale:
    #     freq = freq / freq.max()
    #     ymax = 1.
    if rescale:
        # sentiment = sentiment + sentiment.min()
        # sentiment = sentiment / sentiment.max()
        ymax = sentiment.max()
        bottom = sentiment.min()


    angles = date2rad(dates, time_segment)

    if fig is None:
        fig = plt.figure(figsize=figsize)
        ax1 = plt.subplot(111, polar=True)

    # Define figure parameters
    width = (2*np.pi)

    if time_segment == 'hour':
        width /= 30
        ticks_loc = ax1.get_xticks().tolist()
        ax1.xaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
        ax1.set_xticklabels(['6h', '3h', '0h', '21h', '18h', '15h', '12h', '9h'])
        angles=[i+(width/2) for i in angles]

    elif time_segment == 'dayweek':
        width /= 30
        temp_xticks = np.linspace(np.pi/2, 2*np.pi+np.pi/2, 7, endpoint=False)
        temp_xticks[-1] -= 2 * np.pi
        ax1.set_xticks(temp_xticks)
        ticks_loc = ax1.get_xticks().tolist()
        ax1.xaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
        ax1.set_xticklabels(['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'])
        angles=[i-(width) for i in angles]
        # TO DO: check the shift amount for good visualization
        # angles=[i-(width/2) for i in angles] ?

    elif time_segment == 'daymonth':
        width /= 31
        temp_xticks = np.linspace(np.pi/2, 2*np.pi+np.pi/2, 31, endpoint=False)
        temp_xticks[temp_xticks>2*np.pi] -= 2 * np.pi
        ax1.set_xticks(temp_xticks)
        ticks_loc = ax1.get_xticks().tolist()
        ax1.xaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
        ax1.set_xticklabels(range(1, 32))
        angles=[i-(width/2) for i in angles]
        
    #### MODIFIED BY SG ######################
    elif time_segment == 'monthyear':
        width /= 12
        temp_xticks = np.linspace(np.pi/2, 2*np.pi+np.pi/2, 12, endpoint=False)
        temp_xticks[temp_xticks>2*np.pi] -= 2 * np.pi
        ax1.set_xticks(temp_xticks)
        ticks_loc = ax1.get_xticks().tolist()
        ax1.xaxis.set_major_locator(mticker.FixedLocator(ticks_loc))
        ax1.set_xticklabels(range(1, 13))
        angles=[i-(width) for i in angles]
    ##########################################


    # ax1.bar(angles, freq, width=width, bottom=bottom, alpha=0.5, label="Dates")
    ax1.plot(angles, sentiment)

    ax1.set_ylim([bottom, ymax])

    # ax1.set_xticklabels(['January','February','March','April','May','June','July',
    #                      'August','September','October','November','December'])
    ax1.set_xticklabels(['Jan','Feb','Mar','Apr','May','Jun','Jul',
                         'Aug','Sep','Oct','Nov','Dec'])
    
    ax1.set_yticklabels([])
    ax1.tick_params(axis='both', which='major', labelsize=12)
    return fig, ax1




def circular(df, t2):
    time_segment = 'monthyear'
    # freq_arr, times = freq_time(df['month_dt'] , time_segment=time_segment)
    freq_arr, times = freq_time(df['month_dt'] , time_segment=time_segment, freq=False)
    fig, ax1 = base_periodic_fig(dates = times, time_segment=time_segment, sentiment=df['sentiment'])
    # ax1.legend(bbox_to_anchor=(-0.3, 0.05), loc="upper left", borderaxespad=0)
    plt.title('Monthly Tweet Sentiment, 2010-2022 ' + t2 + '\n', fontdict={'fontsize':22})
    plt.show()
        
        
    
    
    
    
# detrend(month_sent, '(All Tweets)')
# detrend(month_sent_unique, '(Unique Tweets Only)')
# detrend(month_sent_replies, '(Reply Tweets Only)')
# detrend(month_sent_qrt, '(Quote Tweets Only)')


# seasonality(month_sent, '(All Tweets)')


# overlaid_by_year(month_sent)
# overlaid_by_year(month_sent_unique)
# overlaid_by_year(month_sent_replies)
# overlaid_by_year(month_sent_qrt)



circular(month_sent, '(All Tweets)')
circular(month_sent_unique, '(Unique Tweets)')
circular(month_sent_replies, '(Reply Tweets)')
circular(month_sent_qrt, '(Quote Tweets)')



