from Queries import database, poshoUI, const, encriptar

def Agregar():
      # Correo
    finish = False
    while not finish:
        correo = input("Correo: ")
        result = database.Query("SELECT EXISTS(SELECT * FROM usuario WHERE correo='"+correo+"')")
        if result[0][0] == 0:
            finish = True
        else:
            print("Este correo ya existe. Elige otro.")

    # Contraseña
    finish = False
    while not finish:
        contraseña = input("Contraseña: ")
        contraseña2 = input("Confirmar Contraseña: ")
        if contraseña == contraseña2:
            finish = True
            contraseña = str(encriptar.encode(contraseña))
        else:
            print("Las contraseñas no coinciden.")

    # Nombre
    nombre = input("Nombre: ")
    apellido_p = input("Apellido Paterno: ")
    apellido_m = input("Apellido Materno: ")

    # Fecha de Nacimiento
    fecha = input("Fecha de Nacimiento: ")

    arquetipo = "1"

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

    return

def Quitar(g_id, a_id):
    result = database.Query("""
    DELETE
    FROM
        `grupo_electrodomestico`
    WHERE
        grupo_electrodomestico.id_grupo = """+str(g_id)+"""
        AND grupo_electrodomestico.id_electrodomestico = """+str(a_id)+"""
    """)

def Ver():
    return

def Listar():
    result = database.Query("""
    SELECT
        id_electrodomestico,
        nombre,
        consumo_por_hora
    FROM
        electrodomestico
    """)
    return result



