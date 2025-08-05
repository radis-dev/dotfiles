#!/bin/bash
set -e

source lib/env.sh
source lib/print.sh
source lib/utils.sh

print_menu() {
    echo "1) Configurar Git"
    echo "0) Volver al menú principal" 
}

configure_git() {
    if ! is_installed "git"; then
        print_msg error "Git no está instalado."
        return 0
    fi

    if ! [[ -f "$USER_HOME/.dotfiles/config/git/.gitconfig" ]]; then
        print_msg error "No se encontró el archivo de configuración de Git"
        return 1
    fi

    print_msg info "Enlazando archivos de configuración de Git..."

    if ! ln -sf "$USER_HOME/.dotfiles/config/git/.gitconfig" "$USER_HOME/.gitconfig"; then
        print_msg error "Error al enlazar el archivo de configuracion de Git"
        return 1
    fi

    print_msg success "Configuración de Git aplicada correctamente."
}

main() {
    while true; do
        clear
        print_menu
        read -p "Seleccione una opción: " option

        case $option in
            1)
                clear
                configure_git
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