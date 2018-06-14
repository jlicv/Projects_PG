# -*- coding: utf-8 -*-
"""
Created on Mon Nov 20 20:46:48 2017

@author: Jason Li
"""


import pandas as pd
import sqlite3 as sl
import numpy as np
import json 
import matplotlib.pyplot as plt
#import numpy as np

conn = sl.connect('C:/Fall2017-HKUST/Independt Project- Dr. Chou Hongsong/DataSet/Datebase/btc_cny.db')
#Avg_Tick_Count_ByTickDifference
q = """SELECT ts,bids,asks FROM depth"""    
df = pd.read_sql_query(q,conn)
ts = pd.to_datetime(df.ts,unit='ms')
ask1 = df.asks.apply(json.loads).apply(lambda x:x[0])
bid1 = df.bids.apply(json.loads).apply(lambda x:x[0])
ask1_price = ask1.apply(lambda x:x[0])
bid1_price = bid1.apply(lambda x:x[0])
midquote = 0.5*(ask1_price+bid1_price)
log_rtn = np.log(midquote) - np.log(midquote.shift(1))
log_rtn = log_rtn.fillna(0)
#log_rtn.plot.box()
log_rtn.index = ts
plt.figure()
plt.boxplot(log_rtn.values,1)
log_rtn.to_csv('log_rtn_midquote.csv')
#No duplicated Values found.
#ts_dpted = pd.Series.duplicated(df.ts)
