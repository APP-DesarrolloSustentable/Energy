from Queries import database, poshoUI, const, encriptar, CalcularEdad
import datetime


def Crear(u_id, nombre):
    result = database.Query("""
    INSERT INTO grupo(nombre)
    VALUES('"""+nombre+"""');
    INSERT INTO grupo_usuario(id_grupo, id_usuario, rol)
    VALUES(LAST_INSERT_ID(), """+str(u_id)+""", 'admin')
    """)
    return True

def Miembros(g_id):
    result = database.Query("""
    SELECT
    usuario.id_usuario,
    usuario.nombre,
    usuario.correo,
    grupo_usuario.rol
    FROM
        grupo,
        usuario,
        grupo_usuario
    WHERE
        grupo.id_grupo = """+str(g_id)+"""
        AND grupo.id_grupo = grupo_usuario.id_grupo
        AND grupo_usuario.id_usuario = usuario.id_usuario
    """)
    return result

def AgregarElectrodomestico(g_id, e_id):
    result = database.Query("""
    INSERT INTO grupo_electrodomestico(id_grupo, id_electrodomestico)
    VALUES("""+str(g_id)+""", """+str(e_id)+""")
    """)
    return result

def Invitar(id_grupo, id_usuario):
    result = database.Query("""
    INSERT INTO grupo_usuario(
        id_grupo,
        id_usuario,
        rol)
    VALUES(
        '"""+str(id_grupo)+"""',
        '"""+str(id_usuario)+"""',
        'basic') 
    """)
    return result


#todavia no funciona
def InvitarSinRepetir(id_grupo, id_usuario):
    result = database.Query("""CALL invitar('""" +str(id_grupo) + """', '"""+str(id_usuario)+"""');
    """)
    return result


def CambiarRol(g_id, m_id, rol):
    result = database.Query("""
    UPDATE
    grupo_usuario
    SET
        rol = '"""+str(rol)+"""'
    WHERE
        id_grupo ='"""+str(g_id)+ """' AND id_usuario = '"""+str(m_id)+"""'
    """)
    return result

def QuitarMiembro(g_id, m_id):
    result = database.Query("""
    DELETE
    FROM
        grupo_usuario
    WHERE
        id_usuario = '"""+str(m_id)+"""' AND id_grupo = '"""+str(g_id)+"""'
    """)
    return result

def Borrar(g_id):
    result = database.Query("""
    DELETE
    FROM
        grupo
    WHERE
        id_grupo = '"""+str(g_id)+"""' 
    """)
    return result

def Listar(id_usuario):
    result = database.Query("""
    SELECT
        grupo.id_grupo,
        grupo.nombre,
        grupo.puntos
    FROM
        grupo,
        usuario,
        grupo_usuario
    WHERE
        usuario.id_usuario ='"""+ str(id_usuario) +"""' AND usuario.id_usuario = grupo_usuario.id_usuario AND grupo_usuario.id_grupo = grupo.id_grupo
        """)
    return result

def getNombre(id_Grupo):
    result = database.Query("""
    SELECT
        nombre,
        puntos
    FROM
        grupo
    WHERE id_grupo ='"""+ str(id_Grupo) +"""'
        """)
    return result

def getPuntaje(id_Grupo):
    result = database.Query("""
    SELECT
        puntos
    FROM
        grupo
    WHERE id_grupo ='"""+ str(id_Grupo) +"""'
        """)
    return result



def ImprimirElectrodomesticos(id_g):
    tabla = database.Query("""
    SELECT DISTINCT
    electrodomestico.id_electrodomestico,
    electrodomestico.nombre,
    electrodomestico.consumo_por_hora
    FROM
        grupo_electrodomestico,
        electrodomestico
    WHERE
        grupo_electrodomestico.id_grupo = """+str(id_g)+"""
        AND electrodomestico.id_electrodomestico = grupo_electrodomestico.id_electrodomestico
    """)

    return tabla



def EliminarElectrodomesticos(id_g):
    tabla = database.Query("""
    DELETE FROM 
        grupo_electrodomestico 
    WHERE 
    id_grupo = '
     """+str(id_g)+"""'     
    """)
    return tabla

