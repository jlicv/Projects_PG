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
df = df.fillna(0)
df = df.drop(['price','amount'],axis=1)    
log_rtn_series = df.log_rtn
log_rtn_series.index = df['time']
log_rtn_30min = log_rtn_series.resample('30min').sum()
log_rtn_30min = log_rtn_30min.fillna(0)
log_rtn_30min.to_csv('log_rtn_30min.csv')
#Annualized log return
log_rtn_30min_annualized = log_rtn_30min*pow(365*48,0.5)