from flask import Flask, request
import pandas as pd
from scriptspandas import ScriptsPandas
from scorefun import getValues, getNewVar
from regressionfun import RegresionLineal
# Nueva instancia
app = Flask(__name__)

@app.route('/')
def index():
    return "Welcome Python 3.7 & Flask"


@app.route('/regrlineal', methods=['POST'])
def regrlineal():
    fullname = request.json.get("fullname")
    email = request.json.get("email")
    url = './' + request.json.get("url", "score.csv")
    module = request.json.get("module", "tasktimes")

    filtro = ScriptsPandas(url).getFilter('email', email)
    y = getValues(filtro, module)
    x = getValues(filtro,'range')
    newX, newY = getNewVar(x,y)
    RegresionLineal(x, y, newX, newY).crearGrafica(x, y, "Rangos", "Puntos",fullname,email)
    return "Finalizado correctamente"


if __name__ == "__main__":
    # El modo debug sirve para que se obtengan cambios
    # En el código mientras se desarrolla
    app.run(host='0.0.0.0', debug=True)

