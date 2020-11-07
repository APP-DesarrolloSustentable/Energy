from flask import Flask, render_template, redirect, url_for, request, session 
import database, usuario, poshoUI, electrodomestico, grupo, consumo, tip, const, pymysql

app = Flask(__name__)
app.secret_key = "secret"

@app.route('/', methods=['POST', 'GET'])
def index():
    if session.get('logged_in'):
        if session["logged_in"] == False:
            IniciarSesion();  
        else:
            return redirect(url_for("inicio"))
    else:
        return redirect(url_for("IniciarSesion"))




@app.route('/Iniciar_Sesion', methods=['POST', 'GET'])
def IniciarSesion():
    if request.method == "POST":
        correo = request.form["correo"] 
        contraseña = request.form["contraseña"]
        if(usuario.validar(correo , contraseña)):
            session["correo"] = correo 
            session["contraseña"] = contraseña
            session["logged_in"] = True
            return redirect(url_for("inicio"))
        else: 
            return render_template('Iniciar_Sesion.html')
    else:
        return render_template('Iniciar_Sesion.html')


@app.route('/Registrate', methods=['POST', 'GET'])
def CrearCuenta():
    if request.method == "POST":
       return render_template('Registrate.html')
    else:    
        return render_template('Registrate.html')


@app.route('/inicio', methods=['POST', 'GET'])
def inicio():
    if session.get('logged_in'):
        if session["logged_in"] == True:
            return render_template('inicio.html', sesion = session)  
        else:
            return redirect(url_for("index"))
    else:
        return redirect(url_for("index"))

@app.route('/cerrar_sesion', methods=['POST', 'GET'])
def cerrar_sesion():
    session.clear()
    return redirect(url_for("index")) 

if __name__ == '__main__':
    app.run(debug=True)
