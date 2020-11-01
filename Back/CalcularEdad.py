from datetime import date
from dateutil.relativedelta import relativedelta


def calcular_edad(fechaNacimiento):
    x = [int(n) for n in fechaNacimiento.split("-")]
    fecha_nacimiento = date(x[0], x[1], x[2])

    edad = date.today().year - fecha_nacimiento.year
    cumpleanios = fecha_nacimiento + relativedelta(years=edad)
 
    if cumpleanios > date.today():
        edad = edad - 1
    return edad
