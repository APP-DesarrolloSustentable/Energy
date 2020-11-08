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
    error = ""
    if request.method == "POST":
        correo = request.form["correo"] 
        contraseña = request.form["contraseña"]
        if(usuario.validar(correo , contraseña)):
            session["correo"] = correo 
            session["contraseña"] = contraseña
            session["logged_in"] = True
            return redirect(url_for("inicio"))
        else: 
            error = "Correo o contraseña incorrecta"
            return render_template('Iniciar_Sesion.html', error = error)
    else:
        return render_template('Iniciar_Sesion.html', error = error)


@app.route('/Registrate', methods=['POST', 'GET'])
def CrearCuenta():
    error = ""
    if request.method == "POST":
        nombre = request.form["nombre"]         
        apellido_p = request.form["apellido_p"] 
        apellido_m = request.form["apellido_m"] 
        fechaNacimiento = request.form["fecha"] 
        correo = request.form["correo"] 
        contraseña = request.form["contraseña"]
        contraseña2 = request.form["contraseña2"]
        tipoError = usuario.Crear(correo, contraseña, contraseña2,nombre,apellido_p, apellido_m, fechaNacimiento)
        if tipoError == 0:
            session["correo"] = correo 
            session["contraseña"] = contraseña
            session["logged_in"] = True
            return redirect(url_for("inicio"))
        elif tipoError == 1:
            error = "Este correo ya existe"
            print(error)
            return render_template('Registrate.html', error = error)
        elif tipoError == 2:
            error = "Contraseñas no coinciden"
            print(error)
            return render_template('Registrate.html', error = error)
    else:    
        return render_template('Registrate.html', error = error)


@app.route('/inicio', methods=['POST', 'GET'])
def inicio():
    if session.get('logged_in'):
        if session["logged_in"] == True:
            session["id"] = usuario.getId(session["correo"])
            grupos = grupo.Listar(session["id"])
            session["grupos"] = grupos
            size = len(session["grupos"])
            color = ['Skobeloff','Medium_Aquarum', 'Verdigris']
            return render_template('inicio.html', sesion = session, size = size, color = color)  
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
