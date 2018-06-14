# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 15:20:59 2017

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
df['simple_rtn]
df = df.fillna(0)
df = df.drop(['price','amount'],axis=1)    
log_rtn_series = df.log_rtn
log_rtn_series.index = df['time']
vol_hour_all = log_rtn_series.resample('H').std()*pow(8760,0.5)
vol_daily_all = log_rtn_series.resample('D').std()*pow(365,0.5)
vol_minute_all = log_rtn_series.resample('60S').std()*pow(525600,0.5)
numtick_minute = log_rtn_series.resample('H').count()
numtick_minute.plot(kind='box')
log_rtn_series.plot()
vol_daily_all.plot()
vol_minute_all.plot()
vol_hour_all.plot()
