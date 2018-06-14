# -*- coding: utf-8 -*-
"""
Created on Sun Nov 19 12:08:12 2017

@author: Jason Li
"""

# -*- coding: utf-8 -*-
"""
Created on Wed Oct 25 15:37:19 2017

@author: Jason Li
"""

import pandas as pd
import sqlite3 as sl
import numpy as np

#import datetime as datetime

conn = sl.connect('C:/Fall2017-HKUST/Independt Project- Dr. Chou Hongsong/DataSet/Datebase/btc_cny.db')
q = """SELECT time,price,amount
    FROM trades 
    """
df = pd.read_sql_query(q,conn,parse_dates='time')
df['log_rtn'] = np.log(df.price) - np.log(df.price.shift(1))
df = df.fillna(0)
df = df.drop(['price','amount'],axis=1)    

log_rtn_series = pd.Series(df.log_rtn)
log_rtn_series.index = df.time
n_tick = log_rtn_series.resample('15min').count()

vol_std = log_rtn_series.resample('15min').std()*pow(365*96,0.5)
vol_std = vol_std.fillna(0)
#vol_std.to_csv("vol-tick-15minutes.csv")
#You have to bind it with a 0
#一开始选择的是0到31行，所以要加多一行
cumsum_n_tick = np.cumsum(n_tick)
extrarow_cumsum = cumsum_n_tick[0:1]
extrarow_cumsum = extrarow_cumsum.shift(freq='-15min')
extrarow_cumsum[0] = 0
cumsum_n_tick = extrarow_cumsum.append(cumsum_n_tick)
two_scale_vol = pd.Series()
for i in range(0,len(cumsum_n_tick)-1):
    series = log_rtn_series[cumsum_n_tick[i]:cumsum_n_tick[i+1]]
    series.index = range(0,len(series))
    n = len(series)
    K_initial = pow(n,2/3.0)
    if(n!=0):
        nbar_initial = n/K_initial
        index_K = series.index.map(lambda x:x%int(K_initial)).values
        Vol_slice = series.groupby(index_K).std()
        Vol_TwoScale = Vol_slice.mean()*pow(365*96,0.5) - nbar_initial/n*vol_std[i]
    else:
        Vol_TwoScale = 0
    two_scale_vol = two_scale_vol.append(pd.Series(Vol_TwoScale))
two_scale_vol.index = vol_std.index
two_scale_vol.name = 'two_scale'
vol_std.name = 'realized vol'
vol_df = pd.concat([two_scale_vol,vol_std],axis=1)
vol_df.plot()
vol_df.to_csv('vol-twoestimates-15min.csv')