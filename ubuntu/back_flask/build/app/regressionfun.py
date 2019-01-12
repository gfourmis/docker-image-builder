from sklearn.metrics import mean_squared_error, r2_score
from sklearn import linear_model
from matplotlib import cm
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import pandas as pd
import seaborn as sb
import matplotlib.pyplot as plt
from datetime import date
# get_ipython().run_line_magic('matplotlib', 'inline')
plt.rcParams['figure.figsize'] = (16, 9)
plt.style.use('ggplot')

class RegresionLineal:

    def __init__(self,x,y,newX,newY):
        # Asignamos nuestra variable de entrada X para entrenamiento y las etiquetas Y.
        dataX = newX
        self.X_train = np.array(dataX)
        # y_train = filtro['tasktimes'].values
        self.y_train = newY

        # Creamos el objeto de Regresión Linear
        regr = linear_model.LinearRegression()

        # Entrenamos nuestro modelo
        regr.fit(self.X_train, self.y_train)

        # Hacemos las predicciones que en definitiva una línea (en este caso, al ser 2D)
        y_pred = regr.predict(self.X_train)

        self.regr = regr
        self.y_pred = y_pred

    def getCoeficiente(self):
        return self.regr.coef_

    def getIntercepcion(self):
        return self.regr.intercept_

    def getErrorCuadratico(self):
        return mean_squared_error(self.y_train, self.y_pred)

    def getPuntajeVarianza(self):
        return r2_score(self.y_train, self.y_pred)

    def crearGrafica(self, x, y, xlabel, ylabel, title, email):
        plt.plot(x, y, 'ro')
        # plt.xticks(x, x, rotation='vertical')
        plt.xticks(x, x, rotation='25', horizontalalignment='right')
        def f(z): return self.regr.coef_[0]*z + self.regr.intercept_
        z = np.array([0,len(x)])
        plt.plot(z, f(z), lw=2, color="blue")
        plt.ylabel(ylabel)
        plt.xlabel(xlabel)
        plt.title(title)
        plt.gcf().subplots_adjust(bottom=0.2)
        uno, dos = email.split("@")
        # plt.show()
        plt.savefig('graphical/'+uno+str(date.today())+'.png')
