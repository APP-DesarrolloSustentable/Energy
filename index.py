from flask import Flask, render_template, redirect, url_for, request, session 
import database, usuario, poshoUI, electrodomestico, grupo, consumo, tip, const, pymysql

app = Flask(__name__)
app.secret_key = "secret"

@app.route('/', methods=['POST', 'GET'])
def index():
    if session.get('logged_in'):
        if session["logged_in"] == False:
            IniciarSesion()
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
            session["arquetipo"] = usuario.getArquetipo(session["correo"])
            session["nombre"] = usuario.getName(session["correo"])
            session["apellido_p"] = usuario.getApellidoP(session["correo"])
            session["apellido_m"] = usuario.getApellidoM(session["correo"])

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


@app.route('/grupo', methods=['POST', 'GET'])
def paginaGrupo():
    if session.get('logged_in'):
        if session["logged_in"] == True:
            if request.method == "POST":
                session["idGrupo"] = request.form["idGrupo"]
                session["nombreGrupo"] = grupo.getNombre(session["idGrupo"])
                session["puntaje"] = grupo.getPuntaje(session["idGrupo"])
                print("nombre", session["nombreGrupo"])
                miembros = grupo.Miembros(session["idGrupo"])
                size = len(miembros)
                print(miembros)
                print(miembros[0][1])
                print(miembros[0][2])
                return render_template('grupo.html', session=session, miembros = miembros, size = size)
            else:
                return redirect(url_for("inicio"))

        else:
            return redirect(url_for("index"))
    else:
        return redirect(url_for("index"))



@app.route('/tips', methods=['POST', 'GET'])
def tips():
    if session.get('logged_in'):
        if session["logged_in"] == True:
            tips = tip.Ver(session["arquetipo"])
            size = len(tips)

            return render_template('tips.html', tips = tips, size = size)  
        else:
            return redirect(url_for("index"))
    else:
        return redirect(url_for("index"))


@app.route('/configuracion', methods=['POST', 'GET'])
def configuracion():
    if session.get('logged_in'):
        if session["logged_in"] == True:
            if request.method == "POST":
                if "nombre" in request.form:
                    usuario.CambiarNombre(request.form["nombre"], request.form["apellido_p"], request.form["apellido_m"], session["correo"])
                    session["nombre"] = request.form["nombre"]
                    session["apellido_p"] = request.form["apellido_p"]
                    session["apellido_m"] = request.form["apellido_m"]
                elif "arquetipo" in request.form:
                    print( request.form["arquetipo"])
                    usuario.CambiarArquetipo(request.form["arquetipo"], session["correo"])
                    session["arquetipo"] = request.form["arquetipo"]
                elif "contraseña" in request.form:
                    if usuario.validar(session["correo"], request.form["contraseña"]):
                        if  request.form["contraseña2"] ==   request.form["contraseña3"]:
                            usuario.CambiarContrasena(session["correo"], session["contraseña"],  request.form["contraseña2"])
                            print("else")
                        else:
                            error = "las nuevas contraseñas no coinciden"
                            return render_template('configuracion_Resultado.html', error = error)  

                    else:
                        error = "Antigua contraseña incorrecta"
                        return render_template('configuracion_Resultado.html', error = error)  

            return render_template('configuracion.html', session = session)  
        else:
            return redirect(url_for("index"))
    else:
        return redirect(url_for("index"))

if __name__ == '__main__':
    app.run(debug=True)
