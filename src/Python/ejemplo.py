import re

cadena_valida = "Python3"
cadena_invalida_simbolo = "Python_3"
cadena_invalida_espacio = "Python 3"

# Patrón que solo acepta letras (mayúsculas y minúsculas) y números
patron = r'^[0-9A-Za-z]+$'

print(f"'{cadena_valida}' tiene solo letras/números: {bool(re.match(patron, cadena_valida))}") # Salida: 'Python3' tiene solo letras/números: True
print(f"'{cadena_invalida_simbolo}' tiene solo letras/números: {bool(re.match(patron, cadena_invalida_simbolo))}") # Salida: 'Python_3' tiene solo letras/números: False
print(f"'{cadena_invalida_espacio}' tiene solo letras/números: {bool(re.match(patron, cadena_invalida_espacio))}") # Salida: 'Python 3' tiene solo letras/números: False

def depurar_cadena(cadena):
    # Elimina caracteres no alfanuméricos
    cadena_filtrada = re.sub(r'[^0-9A-Za-z]', '', cadena)
    # Codifica en UTF-8
    return cadena_filtrada.encode('utf-8')

# Ejemplo de uso
cadena = "Py@thón 3!"
cadena_depurada = depurar_cadena(cadena)
print(cadena_depurada)  # Salida: b'Python3'