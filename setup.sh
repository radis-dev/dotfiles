#!/bin/bash
set -e

source lib/env.sh
source lib/print.sh
source lib/utils.sh

print_menu() {
    echo "1) Preinstalacion"
    echo "2) Git"
    echo "3) SSH"
    echo "4) ZSH"
    echo "5) Flathub"
    echo "0) Salir" 
}

main() {
    if [ $EUID -ne 0 ]; then
        print_msg error "Este script debe ejecutarse como root."
        exit 1
    fi

    if ! is_debian_like; then
        print_msg error "Este script solo funciona en distribuciones basadas en Debian."
        exit 1
    fi

    while true; do
        clear
        print_menu
        read -p "Seleccione una opcion: " option

        case $option in
            1)
                bash scripts/preinstall.sh
                ;;
            2)
                bash scripts/git.sh
                ;;
            3)
                bash scripts/ssh.sh
                ;;
            4)
                bash scripts/zsh.sh
                ;;
            5)
                bash scripts/flathub.sh
                ;;
            0)
                clear
                print_msg success "Saliendo..."
                exit 0
                ;;
            *)
                clear
                print_msg error "Opción no válida. Por favor, intente de nuevo."
                ;;
        esac
    done
}

main "$@"