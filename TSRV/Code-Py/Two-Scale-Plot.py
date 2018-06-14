# -*- coding: utf-8 -*-
"""
Created on Wed Nov 15 18:22:37 2017

@author: Jason Li
"""


from mpl_toolkits.mplot3d import Axes3D
from matplotlib.collections import PolyCollection
import matplotlib.pyplot as plt
from matplotlib import colors as mcolors
import pandas as pd
def cc(arg):
    return mcolors.to_rgba(arg, alpha=0.6)

Estm = pd.read_csv('Daily_TwoScale.csv')
#Don't simply change the values of column names, use rename instead
Estm = Estm.rename(columns={Estm.columns.values[0]:'Day'})
Estm_xs = Estm['Day'].unique()
Estm_zs = Estm['K'].unique()
Estm_verts = []
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')
ax.set_xlabel('Day')
ax.set_ylabel('Number of Bin')
ax.set_zlabel('Rlzd S.D. Estm.')

#zlist = zip(['r','g','b','y','c'],Estm_zs)
#for c,z in zip(['r', 'g', 'b', 'y','c'],Estm_zs):
#    Estm_ys = Estm.groupby('K').get_group(z)['log_rtn']
#    cs = [c] * len(Estm_xs)
#    ax.bar(Estm_xs, Estm_ys, zs=z, color=cs,zdir='y', alpha=0.8)
for z in Estm_zs:
    Estm_ys =Estm.groupby('K').get_group(z)['log_rtn']
    ax.bar(Estm_xs, Estm_ys, zs=z, zdir='y', alpha=0.8)

#poly = PolyCollection(Estm_verts, facecolors=[cc('r'), cc('g'), cc('b'),
#                                         cc('y')])
#poly.set_alpha(0.7)
