# -*- coding: utf-8 -*-
"""
Created on Wed Nov 15 10:21:30 2017

@author: Jason Li
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
#Notice that the index has been silently change when you read from csv.
Estm = pd.read_csv('Daily_TwoScale.csv')
#Don't simply change the values, use rename instead
Estm = Estm.rename(columns={Estm.columns.values[0]:'Day'})
Estm['Day']
X = Estm['K']
Y = Estm['Day']
Z = Estm['log_rtn']
fig = plt.figure()
ax = Axes3D(fig)
bar = ax.bar(X,Y,Z)
plt.show()
#Axes3D.plot(x=Estm.iloc[:'Day'],y=Estm.loc['log_rtn'])
#for day,log_rtn in Estm.groupby(Estm['K']):
#    plt.plot(x=day,y=log_rtn)
