from flask import Flask, request

# Nueva instancia
app = Flask(__name__)


@app.route('/')
def index():
    return "Welcome Python 3.7 & Flask"


if __name__ == "__main__":
    # El modo debug sirve para que se obtengan cambios
    # En el código mientras se desarrolla
    app.run(host='0.0.0.0', debug=True)