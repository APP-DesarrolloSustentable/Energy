import database, poshoUI, const, encriptar, CalcularEdad, datetime
from datetime import datetime
from flask import Flask

def validar(correo, contraseña):
    result = database.Query("SELECT EXISTS(SELECT * FROM usuario WHERE correo='"+correo+"')")
    if result[0][0] == 0:
        poshoUI.DrawError("Este correo no existe.")
        return False

    result = database.Query("SELECT contraseña FROM usuario WHERE correo='"+correo+"'")
    if result[0][0] != "" and encriptar.check(contraseña, result[0][0]):
        poshoUI.DrawHeader("¡Inicio de sesion exitoso!")
        return True
    else:
        poshoUI.DrawError("Contraseña incorrecta.")
        return False

def ValidarCorreo(correo_invitado):
    result = database.Query("""
    SELECT EXISTS(SELECT *
    FROM usuario WHERE correo='"""+correo_invitado+"""')
    """)

    if result[0][0] == 1:
        return True
    return False


def getName(correo):
    result = database.Query("SELECT nombre FROM usuario WHERE correo='"+correo+"'")
    return result[0][0]

def getId(correo):
    result = database.Query("SELECT id_usuario FROM usuario WHERE correo='"+correo+"'")
    return result[0][0]

def Crear(correo, contraseña, contraseña2, nombre, apellido_p, apellido_m, fecha):

    # Correo
    result = database.Query("SELECT EXISTS(SELECT * FROM usuario WHERE correo='"+correo+"')")
    if result[0][0] == 0:
        finish = True
    else:
        poshoUI.DrawError("Este correo ya existe.")

    # Contraseña
    if contraseña == contraseña2:
        finish = True
        contraseña = str(encriptar.encode(contraseña))
    else:
        poshoUI.DrawError("Las contraseñas no coinciden.")

    # Nombre

    #Hace que todos los nombres esten con la primera letra en mayuscula y el resto en minuscula.
    nombre= nombre.title()
    apellido_p = apellido_p.title()
    apellido_m = apellido_m.title()

    # Fecha de Nacimiento
    if CalcularEdad.calcular_edad(fecha) > 18:
        arquetipo = "1"
    else:
        arquetipo = "2"

    database.Query("""
        INSERT INTO usuario(
        correo,
        contraseña,
        nombre,
        apellido_paterno,
        apellido_materno,
        fecha_nacimiento,
        arquetipo
    )
    VALUES(
        '"""+correo+"""',
        '"""+contraseña+"""',
        '"""+nombre+"""',
        '"""+apellido_p+"""',
        '"""+apellido_m+"""',
        '"""+fecha+"""',
        '"""+arquetipo+"""'
    )
    """)

def Salir():
    return ""


def Detalles(correo):
    result = database.Query("SELECT nombre, apellido_paterno, apellido_materno, fecha_nacimiento, arquetipo FROM usuario WHERE correo='"+correo+"'")

    nombre = result[0][0] + " " + result[0][1] + " " + result[0][2]
    date = result[0][3].strftime("%m/%d/%Y")
    arquetipo = result[0][4]

    poshoUI.ConsoleClear()
    poshoUI.DrawBorder()
    poshoUI.DrawInner("Nombre: "+nombre)
    poshoUI.DrawInner("Fecha: "+date)
    poshoUI.DrawInner("Arquetipo: "+arquetipo)
    poshoUI.DrawBorder()
    poshoUI.Wait()


def CambiarArquetipo(arquetipo, correo):
    arquetipo = arquetipo.lower()

    if arquetipo == "adulto" or arquetipo == "niño":
        database.Query("UPDATE usuario SET arquetipo ='"+arquetipo+"' WHERE correo = '" +correo+"'")
        poshoUI.DrawHeader("Arquetipo actualizado correctamente!")
    else:
        poshoUI.DrawError("Arquetipo no válido.")

def CambiarFechaNacimiento(correo, fecha):
    database.Query("UPDATE usuario SET fecha_nacimiento ='"+fecha+"' WHERE correo = '" +correo+"'")
    poshoUI.DrawHeader("Fecha de nacimiento actualizada correctamente.")


def CambiarCorreo(correo, nuevoCorreo):
    result = database.Query("SELECT EXISTS(SELECT * FROM usuario WHERE correo='"+correo+"')")
    if result[0][0] == 0:
        print("Este correo no existe.")
        return
    database.Query("UPDATE usuario SET correo ='"+nuevoCorreo+"' WHERE correo = '" +correo+"'")
    poshoUI.DrawHeader("Correo actualizado exitosamente.")


def CambiarContrasena(correo, contraseña, nuevaContraseña):
    result = database.Query("SELECT contraseña FROM usuario WHERE correo='"+correo+"'")

    if result[0][0] != "":
        if encriptar.check(contraseña, result[0][0]):
            nuevaContraseña = str(encriptar.encode(nuevaContraseña))
            database.Query("UPDATE usuario SET contraseña ='"+nuevaContraseña+"' WHERE correo = '" +correo+"'")
            poshoUI.DrawHeader("Contraseña actualizada exitosamente.")
        else:
            poshoUI.DrawError("Antigua contraseña incorrecta.")

    return
