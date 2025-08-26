import re
import os
import sys

# Verificar que se haya pasado el nombre del archivo como argumento
if len(sys.argv) != 2:
    print("Uso: python nombre_del_programa.py nombre_del_archivo.txt")
    sys.exit(1)  # Salir con un código de error

# Obtener el nombre del archivo desde los argumentos
nombre_archivo = sys.argv[1]
if not os.path.exists(nombre_archivo):
    print(f'Error: El archivo {nombre_archivo} no se encontró.')
    sys.exit(1)  # Salir con un código de error

with open(nombre_archivo, 'r', encoding='utf-8') as archivo_entrada:
    lineas = archivo_entrada.readlines()

lineas_depuradas = []
for linea in lineas:
    linea = linea.strip()
    # Elimina caracteres no alfanuméricos
    linea = re.sub(r"[^0-9A-Za-z]", "", linea)
    if linea:  # Ignora líneas vacías
        lineas_depuradas.append(linea)

with open(nombre_archivo, 'w', encoding='utf-8') as archivo_salida:
    archivo_salida.write('\n'.join(lineas_depuradas) + '\n')  # Escribe todas las líneas de una vez
