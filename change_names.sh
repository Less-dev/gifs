#!/bin/bash

# Verificar que se hayan proporcionado exactamente 2 argumentos
if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <string_busqueda> <ruta>"
    exit 1
fi

# Asignar los parámetros a variables
search_string=$1
search_path=$2

# Convertir el string a minúsculas y reemplazar espacios por guiones bajos
new_name=$(echo "$search_string" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Verificar si la ruta es válida
if [ ! -d "$search_path" ]; then
    echo "Error: La ruta '$search_path' no es válida o no existe."
    exit 1
fi

echo "Buscando archivos que contengan '$search_string' en su nombre dentro de '$search_path'..."

# Buscar archivos coincidentes (manejar espacios en nombres con IFS)
IFS=$'\n' 
files=($(find "$search_path" -type f -iname "*$search_string*"))

# Verificar si se encontraron archivos
if [ ${#files[@]} -eq 0 ]; then
    echo "No se encontraron archivos que contengan '$search_string' en su nombre."
    exit 0
fi

# Contador para numerar los archivos
counter=1

# Recorrer los archivos encontrados
for file in "${files[@]}"; do
    # Obtener la extensión actual en minúsculas
    ext="${file##*.}"
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    # Determinar la nueva extensión o eliminar el archivo si no es válido
    case "$ext" in
        gifv) new_ext="gif" ;;
        pnj)  new_ext="png" ;;
        *) 
            echo "Eliminando archivo no válido: $file"
            rm "$file" && echo "Archivo eliminado."
            continue
            ;;
    esac

    # Construir el nuevo nombre con el formato adecuado
    new_file="${search_path}/${new_name}_$(printf "%02d" $counter).$new_ext"

    # Renombrar el archivo (manejar nombres con espacios)
    echo "Renombrando '$file' a '$new_file'"
    mv "$file" "$new_file"

    # Incrementar el contador
    ((counter++))
done

echo "Renombrado completado."
