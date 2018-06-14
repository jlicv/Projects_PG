# -*- coding: utf-8 -*-
"""
Created on Sun Nov 26 10:47:33 2017

@author: Jason Li
"""


import pandas as pd
import sqlite3 as sl

conn = sl.connect('C:/Fall2017-HKUST/Independt Project- Dr. Chou Hongsong/DataSet/Datebase/btc_cny.db')
q = """SELECT time, 
    (CASE 
        WHEN sum(amount)=0 THEN null 
        ELSE sum(amount*price)/sum(amount)
    END) as weighted_price,
    sum(amount) as amount
    FROM trades 
    GROUP BY time"""
df = pd.read_sql_query(q,conn,parse_dates='time')
