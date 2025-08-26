import re
cadena = "Py@thón 3!"
# Elimina caracteres no alfanuméricos
cadena_filtrada = re.sub(r"[^0-9A-Za-z]", "", cadena)
# Codifica en UTF-8
cadena_filtrada.encode('utf-8')
print(cadena_filtrada)  # Salida: b'Python3'