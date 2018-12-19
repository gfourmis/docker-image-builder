import numpy as np

def getValues(pd,value):
    return pd[value].values

def getNewVar(x, y):
    newX = []
    newY = []
    dx = 0
    for i in range(len(x)):
        if (y[i] != 0):
            newX.append([dx, dx + 1])
            dx += 1
            newY.append(y[i])
    return [newX,newY]

