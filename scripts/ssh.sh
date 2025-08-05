#!/bin/bash
set -e

source lib/env.sh
source lib/print.sh
source lib/utils.sh

print_menu() {
    echo -e "1) Configurar SSH"
    echo -e "0) Volver al menú principal" 
}

configure_ssh() {
    if ! is_installed "ssh"; then
        print_msg error "SSH no está instalado."
        return 0
    fi

    if ! [[ -f "$USER_HOME/.dotfiles/config/ssh/config" ]]; then
        print_msg error "No se encontró el archivo de configuración de SSH"
        return 1
    fi

    print_msg info "Enlazando archivos de configuración de SSH..."

    if ! ln -sf "$USER_HOME/.dotfiles/config/ssh/config" "$USER_HOME/.ssh/config"; then
        print_msg error "Error al enlazar el archivo de configuracion de SSH"
        return 1
    fi

    print_msg success "Configuración de SSH aplicada correctamente."
}

main() {
    while true; do
        clear
        print_menu
        read -p "Seleccione una opción: " option

        case $option in
            1)
                clear
                configure_ssh
                ;;
            0)
                clear
                print_msg success "Volviendo al menú principal..."
                return 0
                ;;
            *)
                clear
                print_msg error "Opción no válida. Por favor, intente de nuevo."
                ;;
        esac
    done
}

main "$@"