#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jun 28 10:02:10 2021

@author: shahrzad
"""
import glob
import grain_size_funcs as gf
import numpy as np
from matplotlib import pyplot as plt
import pandas
from scipy.optimize import curve_fit
import math
from sklearn.metrics import r2_score
import blaze_funcs as bf

import matplotlib
matplotlib.rcParams.update({'font.size': 20})

data_dir='/home/shahrzad/repos/EigenData/data/'
directories=[data_dir+'hpx', data_dir+'openmp']
thr=[]
data_files=[]
data={}
for directory in directories:
    [data_files.append(i) for i in glob.glob(directory+'/*.dat')]

matrix_sizes=[]
thr=[]
nodes=[]
for filename in data_files:
    (node, _, th, matrix_size) = filename.split('/')[-1].replace('.dat','').split('_')         
  
        
    matrix_size=int(matrix_size)
    th=int(th)
   
    if node not in nodes:
        nodes.append(node)    
        data[node]={}
    if th not in thr:
        thr.append(th)
    if matrix_size not in matrix_sizes:
        matrix_sizes.append(matrix_size)
    if matrix_size not in data[node].keys():
        data[node][matrix_size]={}
    if th not in data[node][matrix_size].keys():
        data[node][matrix_size][th]={'openmp':0,'hpx':0}
   
nodes.sort()
matrix_sizes.sort()
thr.sort()                                                                       
data_files.sort()   

for filename in data_files:   
    f=open(filename, 'r')
             
    result=f.readlines()
    
    if len(result)!=0:
        avg=0
        (node, runtime, th, matrix_size) = filename.split('/')[-1].replace('.dat','').split('_')         

        runtime=runtime.split('-')[0]
        matrix_size=int(matrix_size)
        th=int(th)       
        first=True
        for r in [r for r in result if r!='\n']:  
            if not first:
                avg+=float(r.split('in ')[1].split('microseconds')[0].strip())
            else:
                first=False      
        if avg>0:
            avg=avg/(len([r for r in result if r!='\n'])-1)

        data[node][matrix_size][th][runtime]=avg

node='medusa'
i=1
for m in matrix_sizes:    
    plt.figure(i)
    plt.scatter([th for th in thr if th in data[node][m].keys()],[data[node][m][th]['hpx'] for th in thr if th in data[node][m].keys()],color='blue',label='hpx')
    plt.scatter([th for th in thr if th in data[node][m].keys()],[data[node][m][th]['openmp'] for th in thr if th in data[node][m].keys()],color='red',label='openmp')
    plt.title('matrix size: '+str(int(m)))
    plt.xticks(thr)
    plt.legend(bbox_to_anchor=(1.05, 1), loc=2, borderaxespad=0.)

    i=i+1