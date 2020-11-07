from flask import Flask, render_template, redirect, url_for, request, session 
import database, usuario, poshoUI, electrodomestico, grupo, consumo, tip, const

app = Flask(__name__)
app.secret_key = "secret"

@app.route('/', methods=['POST', 'GET'])
def index():
    if not session["correo"] or not session["contraseña"]:
        redirect(url_for("/Inisiar_Sesion"))
    else:
        if usuario.validar(session["correo"], session["contraseña"]):
            redirect(url_for("/inicio"))


@app.route('/Inisiar_Sesion', methods=['POST', 'GET'])
def IniciarSesion():
    if request.method == "POST":
            session["correo"] = request.form["correo"] 
            session["contraseña"] = request.form["contraseña"]
            return redirect(url_for("/"))
    else:
        return render_template('Iniciar_Sesion.html')

@app.route('/inicio', methods=['POST', 'GET'])
def inicio():
    return render_template('inicio.html')


if __name__ == '__main__':
    app.run(debug=True)
