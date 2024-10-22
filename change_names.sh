#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Uso: $0 <name_files_common> <ruta>"
    exit 1
fi


search_string=$1
search_path=$2

# Convert string on script downs
new_name=$(echo "$search_string" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')

# Verify if route is avalide
if [ ! -d "$search_path" ]; then
    echo "Error: La ruta '$search_path' no es válida o no existe."
    exit 1
fi

echo "Buscando archivos que contengan '$search_string' en su nombre dentro de '$search_path'..."

IFS=$'\n' 
files=($(find "$search_path" -type f -iname "*$search_string*"))

if [ ${#files[@]} -eq 0 ]; then
    echo "No se encontraron archivos que contengan '$search_string' en su nombre."
    exit 0
fi

counter=1

for file in "${files[@]}"; do
    ext="${file##*.}"
    ext=$(echo "$ext" | tr '[:upper:]' '[:lower:]')

    case "$ext" in
        gifv) new_ext="gif" ;;
        pnj)  new_ext="png" ;;
        *) 
            echo "Eliminando archivo no válido: $file"
            rm "$file" && echo "Archivo eliminado."
            continue
            ;;
    esac

    # Build new name for the file 
    new_file="${search_path}/${new_name}_$(printf "%02d" $counter).$new_ext"

    # Rename files
    echo "Renombrando '$file' a '$new_file'"
    mv "$file" "$new_file"

    ((counter++))
done

echo "Renombrado completado."
