import database, usuario, poshoUI, electrodomestico, grupo, consumo, tip, const
from flask import Flask

def main():
    # poshoUI.ConsoleSizeSet(const.len, const.hei)
    poshoUI.ConsoleClear()

    user = {}
    user["sesion"] = False

    fin = False
    while not fin:
        if not user["sesion"]:
            Menu(user)
        else:
            MenuLogged(user)


# El Menú si el usuario no ha ingresado sesión.
def Menu(user):
    poshoUI.DrawBorder()
    poshoUI.DrawInner("ENERGÍA")

    #Opciones
    poshoUI.DrawIndexBorder()
    poshoUI.DrawIndex(1, "Iniciar Sesión.")
    poshoUI.DrawIndex(2, "Crear Cuenta.")
    poshoUI.DrawIndexBorder()

    # Input
    inpoot = int(poshoUI.Input())
    poshoUI.ConsoleClear()

    # Iniciar Sesión
    if inpoot == 1:
        poshoUI.DrawFrame("Iniciar Sesión")
        correo = input("| Correo: ")
        contraseña = input("| Contraseña: ")
        validacion = usuario.validar(correo, contraseña)

        if validacion:
            user["correo"] = correo
            user["id"] = usuario.getId(correo)
            user["nombre"] = usuario.getName(correo)
            user["sesion"] = True


    # Crear Cuenta
    elif inpoot == 2:
        poshoUI.DrawFrame("Crear Cuenta")
        correo = input("| Correo: ")
        contraseña = input("| Contraseña: ")
        contraseña2 = input("| Confirmar Contraseña: ")
        nombre = input("| Nombre: ")
        apellido_p = input("| Apellido Paterno: ")
        apellido_m = input("| Apellido Materno: ")
        fecha = input("| Fecha de Nacimiento: ")
        usuario.Crear(correo, contraseña, contraseña2, nombre, apellido_p, apellido_m, fecha)
        poshoUI.DrawHeader("Se ha creado la cuenta para "+nombre+".")


# El menú si el usuario ya ha ingresado sesión.
def MenuLogged(user):
    poshoUI.DrawBorder()
    poshoUI.DrawInner("Bienvenido, "+user["nombre"]+".")
    poshoUI.DrawIndexBorder()
    poshoUI.DrawIndex(1, "Ver información de usuario.")
    poshoUI.DrawIndex(2, "Cambiar arquetipo.")
    poshoUI.DrawIndex(3, "Cambiar fecha de nacimiento.")
    poshoUI.DrawIndex(4, "Cambiar correo.")
    poshoUI.DrawIndex(5, "Cambiar contraseña.")
    poshoUI.DrawIndex(6, "Crear grupo.")
    poshoUI.DrawIndex(7, "Ver lista de miembros de grupo.")
    poshoUI.DrawIndex(8, "Agregar electrodoméstico a grupo.")
    poshoUI.DrawIndex(9, "Invitar miembro a grupo.")
    poshoUI.DrawIndex(10, "Cambiar rol de miembro de grupo.")
    poshoUI.DrawIndex(11, "Quitar miembro de grupo.")
    poshoUI.DrawIndex(12, "Quitar electrodoméstico.")
    poshoUI.DrawIndex(13, "Ver electrodomésticos.")
    poshoUI.DrawIndex(14, "Ver tip.")
    poshoUI.DrawIndex(15, "Cerrar sesión.")
    poshoUI.DrawIndexBorder()

    inpoot = int(poshoUI.Input())

    if inpoot == 1:
        usuario.Detalles(user["correo"])

    elif inpoot == 2:
        poshoUI.DrawHeader("Cambiar Arquetipo")
        print("\nEscoger arquetipo (Niño / Adulto).")
        arquetipo = input("| Arquetipo: ")
        usuario.CambiarArquetipo(arquetipo, user["correo"])

    elif inpoot == 3:
        poshoUI.DrawHeader("Cambiar Fecha de Nacimiento")
        fecha = input("| Nueva Fecha: ")
        usuario.CambiarFechaNacimiento(user["correo"], fecha)

    elif inpoot == 4:
        poshoUI.ConsoleClear()
        poshoUI.DrawFrame("Cambiar Correo Electrónico")
        nuevo_correo = input("| Nuevo correo: ")
        usuario.CambiarCorreo(user["correo"], nuevo_correo)
        user["correo"] = nuevo_correo

    elif inpoot == 5:
        poshoUI.DrawHeader("Cambiar Contraseña")
        contraseña = input("| Antigua Contraseña: ")
        nueva_contraseña = input("| Nueva Contraseña: ")
        usuario.CambiarContrasena(user["correo"], contraseña, nueva_contraseña)

    elif inpoot == 6:
        poshoUI.DrawHeader("Crear Grupo Nuevo")
        nombre = input("| Nombre de Grupo: ")
        if grupo.Crear(user["id"], nombre):
            poshoUI.DrawHeader("Grupo "+nombre+" creado exitosamente.")

    elif inpoot == 7:
        poshoUI.DrawHeader("Ver Miembros")
        group = ElegirGrupo(user)
        tabla = grupo.Miembros(group["id"])

        poshoUI.ConsoleClear()
        ImprimirMiembros(tabla)

        poshoUI.Wait()

    elif inpoot == 8:
        poshoUI.DrawHeader("Agregar Electrodoméstico a Grupo")
        group = ElegirGrupo(user)

        poshoUI.DrawHeader("Agregar Electrodoméstico a Grupo")
        print("\nElige un electrodoméstico:")
        elec = ImprimirElectrodomesticos()
        index2 = int(input("| Electrodoméstico: "))
        e_id = elec[index2-1][0]
        e_name = elec[index2-1][1]

        grupo.AgregarElectrodomestico(group["id"], e_id)
        poshoUI.DrawHeader("Se agregó "+e_name+" en "+group["name"]+".")

    elif inpoot == 9:
        poshoUI.DrawHeader("Invitar Usuario a Grupo")
        group = ElegirGrupo(user)

        poshoUI.DrawHeader("Invitar Usuario a Grupo")
        print("\nEscribe el correo electrónico del usuario.")
        correo_invitado = input("| Correo: ")
        if usuario.ValidarCorreo(correo_invitado):
            invitado_id = usuario.getId(correo_invitado)
            grupo.Invitar(group["id"], invitado_id)
            poshoUI.DrawHeader("Se agregó "+correo_invitado+" a "+group["name"]+".")
        else:
            poshoUI.DrawError("El usuario no existe.")

    elif inpoot == 10:
        poshoUI.DrawHeader("Cambiar Rol de Miembro")
        group = ElegirGrupo(user)

        poshoUI.DrawHeader("Cambiar Rol de Miembro")
        member = ElegirMiembro(group)

        poshoUI.DrawHeader("Cambiar Rol de Miembro")
        print("\nSeleccionado: "+member["name"])
        print("\nEscoge el rol (admin / basic)")
        rol = input("| Rol: ")

        if rol=="admin" or rol=="basic":
            grupo.CambiarRol(group["id"], member["id"], rol)
            poshoUI.DrawHeader(member["name"]+" es ahora "+rol+".")
        else:
            poshoUI.DrawError("Rol equivocado.")

    elif inpoot == 11:
        poshoUI.DrawHeader("Quitar Miembro")
        group = ElegirGrupo(user)

        poshoUI.DrawHeader("Quitar Miembro")
        member = ElegirMiembro(group)

        grupo.QuitarMiembro(group["id"], member["id"])
        poshoUI.DrawHeader("Se ha quitado "+member["name"]+" de "+group["name"]+".")


    elif inpoot == 12:
        poshoUI.DrawHeader("Quitar Electrodoméstico")
        group = ElegirGrupo(user)

        poshoUI.DrawHeader("Quitar Electrodoméstico")
        appliance = ElegirGrupoElectrodomestico(group)

        electrodomestico.Quitar(group["id"], appliance["id"])
        poshoUI.DrawHeader("Se ha quitado "+appliance["name"]+" de "+group["name"]+".")


    elif inpoot == 13:
        poshoUI.DrawHeader("Ver Electrodomésticos de un Grupo")
        group = ElegirGrupo(user)

        poshoUI.DrawHeader("Ver Electrodomésticos de un Grupo")
        ImprimirGrupoElectrodomesticos(group)

        poshoUI.Wait()

    elif inpoot == 14:
        tipp = tip.Ver()[0][0]

        poshoUI.DrawHeader("Tip del Día")
        poshoUI.DrawFrame(tipp)
        poshoUI.Wait()

    elif inpoot == 15:
        #usuario.Salir()
        poshoUI.DrawHeader("Se cerró la sesión con éxito.")
        user["sesion"] = False


def ImprimirGrupos(user):
    tabla = grupo.Listar(user["id"])

    poshoUI.DrawIndexBorder()
    poshoUI.DrawIndex("#", "Nombre")

    poshoUI.DrawIndexBorder()
    i = 1
    for row in tabla:
        poshoUI.DrawIndex(i, tabla[i-1][1])
        i += 1
    poshoUI.DrawIndexBorder()

    return tabla


def ImprimirMiembros(members):
    poshoUI.DrawIndexBorder()
    poshoUI.DrawIndex("#", "Miembro")

    poshoUI.DrawIndexBorder()
    i = 0
    for row in members:
        poshoUI.DrawIndex(str(i+1), members[i][1]+" ("+members[i][2]+")")
        i += 1
    poshoUI.DrawIndexBorder()

    return members


def ImprimirElectrodomesticos():
    tabla = electrodomestico.Listar()

    poshoUI.DrawIndexBorder()
    poshoUI.DrawIndex("#", "Electrodoméstico")

    poshoUI.DrawIndexBorder()
    i = 1
    for row in tabla:
        poshoUI.DrawIndex(i, tabla[i-1][1])
        i += 1
    poshoUI.DrawIndexBorder()

    return tabla


def ElegirGrupo(user):
    print("\nElige un grupo:")
    grupos = ImprimirGrupos(user)
    index1 = int(input("| Grupo: "))
    group = {}
    group["id"] = grupos[index1-1][0]
    group["name"] = grupos[index1-1][1]
    return group

def ElegirMiembro(group):
    print("\nElige un miembro:")
    tabla = grupo.Miembros(group["id"])
    miembros = ImprimirMiembros(tabla)
    index1 = int(input("| Miembro: "))
    member = {}
    member["id"] = miembros[index1-1][0]
    member["name"] = miembros[index1-1][1]
    return member

def ElegirGrupoElectrodomestico(group):
    print("\nElige un electrodoméstico:")
    elec = ImprimirGrupoElectrodomesticos(group)
    index1 = int(input("| Electrodoméstico: "))
    appliance = {}
    appliance["id"] = elec[index1-1][0]
    appliance["name"] = elec[index1-1][1]
    return appliance

def ImprimirGrupoElectrodomesticos(group):
    tabla = database.Query("""
    SELECT DISTINCT
    electrodomestico.id_electrodomestico,
    electrodomestico.nombre,
    electrodomestico.consumo_por_hora
    FROM
        grupo_electrodomestico,
        electrodomestico
    WHERE
        grupo_electrodomestico.id_grupo = """+str(group["id"])+"""
        AND electrodomestico.id_electrodomestico = grupo_electrodomestico.id_electrodomestico
    """)

    poshoUI.DrawIndexBorder()
    poshoUI.DrawIndex("#", "Electrodoméstico")

    poshoUI.DrawIndexBorder()
    i = 1
    for row in tabla:
        poshoUI.DrawIndex(i, tabla[i-1][1])
        i += 1
    poshoUI.DrawIndexBorder()

    return tabla

main()
