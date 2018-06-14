# -*- coding: utf-8 -*-
"""
Created on Thu Nov 16 15:20:59 2017

@author: Jason Li
"""


import pandas as pd
import sqlite3 as sl

#Connect to the database;
conn = sl.connect('C:/Fall2017-HKUST/Independt Project- Dr. Chou Hongsong/DataSet/Datebase/btc_cny.db')
#Query 
q = """SELECT time,price,amount
    FROM trades 
    """
#Grab the data by query;
df = pd.read_sql_query(q,conn,parse_dates='time')

df_amt = df['amount']
df_amt.index = df.time
#Sum up the trade amount of ticks within each bin,
df_amt_3s = df_amt.resample('1s').sum()

df_pricexamt = df.amount.values*df.price.values
df_pricexamt = pd.Series(df_pricexamt)
df_pricexamt.index = df.time
df_pricexamt = df_pricexamt.resample('1s').sum()
df_avgprice = pd.Series(df_pricexamt/df_amt_3s)
df_avgprice.to_csv('avg-price-1s.csv')
