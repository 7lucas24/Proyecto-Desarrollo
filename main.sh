#!/bin/bash

# Variable global para la opción elegida
op=""

# el archivo correspondiente
arch=""

submenu() {
    local nmeto="$1"
    arch="$2"

    # Crear archivo si no existe
    [ ! -f "$arch" ] && touch "$arch"

    while true; do
        echo
        echo "Usted está en la sección ${nmeto}, seleccione la opción que desea utilizar:"
        echo "1. Agregar información"
        echo "2. Buscar información"
        echo "3. Eliminar información"
        echo "4. Leer base de información"
        echo "5. Volver al menú principal"
        echo "6. Salir"
        read -p "Opción: " sub_op

        case $sub_op in
            1)
                read -p "Ingrese el concepto: " concepto
                read -p "Ingrese la definición: " definicion
                echo "[$concepto] .- $definicion." >> "$arch"
                echo "Información agregada correctamente."
                ;;
            2)
                read -p "Ingrese el concepto a buscar: " buscar
                echo "Resultados de búsqueda:"
                grep -E "\[$buscar\]" "$arch" || echo "No se encontró el concepto."
                ;;
            3)
                read -p "Ingrese el concepto a eliminar: " eliminar
                if grep -qE "\[$eliminar\]" "$arch"; then
                    sed -i "/\[$eliminar\]/d" "$arch"
                    echo "Concepto eliminado correctamente."
                else
                    echo "El concepto no se encontró."
                fi
                ;;
            4)
                echo "Contenido de la base de información:"
                if [ -s "$arch" ]; then
                    cat "$arch"
                else
                    echo "(Archivo vacío)"
                fi
                ;;
            5)
                echo "Volviendo al menú principal..."
                return 0
                ;;
            6)
                echo "Saliendo de la aplicación."
                exit 0
                ;;
            *)
                echo "Opción no válida."
                ;;
        esac
    done
}

main() {
    arg="$1"

    if [ -z "$arg" ]; then
        echo "Uso: $0 <-a|-t>"
        exit 1
    fi

    if [ "$arg" == "-a" ]; then
        echo "Bienvenido a la guía rápida de Agile, para continuar seleccione un tema:"
        echo "1. SCRUM"
        echo "2. Kanban"
        echo "3. XP (Extreme Programming)"
        echo "4. Crystal"
        echo "5. Cambiar a metodologías tradicionales"
        read -p "Ingrese una opción (1-5): " op

        case $op in
            1) submenu "SCRUM" "meto/scrum.inf" ;;
            2) submenu "Kanban" "meto/kanban.inf" ;;
            3) submenu "XP (Extreme Programming)" "meto/xp.inf" ;;
            4) submenu "Crystal" "meto/crystal.inf" ;;
            5) main "-t" ;;
            *) echo "Opción no válida." ;;
        esac

    elif [ "$arg" == "-t" ]; then
        echo "Bienvenido a la guía rápida de metodologías tradicionales, para continuar seleccione un tema:"
        echo "1. Cascada"
        echo "2. Modelo en V"
        echo "3. Espiral"
        echo "4. Cambiar a metodologías ágiles"
        read -p "Ingrese una opción (1-4): " op

        case $op in
            1) submenu "Cascada" "meto/cascada.inf" ;;
            2) submenu "Modelo en V" "meto/modelo_v.inf" ;;
            3) submenu "Espiral" "meto/espiral.inf" ;;
            4) main "-a" ;;
            *) echo "Opción no válida." ;;
        esac

    else
        echo "Parámetro no válido. Usa: -a o -t"
        exit 1
    fi
}

# Programa principal: bucle para permitir volver al menú principal si se desea
while true; do
    main "$1"
    echo
    echo "¿Deseas realizar otra operación? (s/n)"
    read -p "Respuesta: " respuesta
    if [ "$respuesta" != "s" ]; then
        echo "Gracias por usar la aplicación. ¡Hasta luego!"
        break
    fi
done
