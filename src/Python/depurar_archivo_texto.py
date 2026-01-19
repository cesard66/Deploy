import re
import os

def depurar_archivo_texto(nombre_archivo_entrada):
    if not os.path.exists(nombre_archivo_entrada):
        print(f'Error: El archivo {nombre_archivo_entrada} no se encontró.')
        return

    with open(nombre_archivo_entrada, 'r', encoding='utf-8') as archivo_entrada:
        lineas = archivo_entrada.readlines()

    lineas_depuradas = []
    for linea in lineas:
        linea = linea.strip()
        # Elimina caracteres no alfanuméricos
        linea = re.sub(r"[^0-9A-Za-z]", "", linea)
        if linea:  # Ignora líneas vacías
            lineas_depuradas.append(linea)

    with open(nombre_archivo_entrada, 'w', encoding='utf-8') as archivo_salida:
        archivo_salida.write('\n'.join(lineas_depuradas) + '\n')  # Escribe todas las líneas de una vez

# Ejemplo de uso
nombre_archivo = 'texto.txt'  # Cambia el nombre del archivo según sea necesario
depurar_archivo_texto(nombre_archivo)

print(f'El archivo {nombre_archivo} ha sido depurado.')