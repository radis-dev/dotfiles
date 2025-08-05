#!/bin/bash
set -e

source lib/env.sh
source lib/print.sh
source lib/utils.sh

print_menu() {
    echo "1) Actualizar el sistema" 
    echo "2) Instalar paquetes básicos" 
    echo "3) Limpieza y optimización" 
    echo "0) Volver al menú principal" 
}

update_system() {
    print_msg info "Actualizando el sistema..."

    if ! { sudo apt update && sudo apt upgrade -y; }; then
        print_msg error "Error al actualizar el sistema"
        return 1
    fi

    print_msg success "Sistema actualizado correctamente."
}

install_basic_packages() {
    print_msg info "Instalando paquetes básicos..."

    local packages=(
        "curl"
        "wget"
        "git"
    )

    for package in "${packages[@]}"; do
        if is_installed "${package}"; then
            print_msg warning "El paquete $package ya está instalado."
            continue
        fi

        print_msg info "Instalando $package..."

        if ! sudo apt install -y "$package"; then
            print_msg error "Error al instalar $package."
        fi

        print_msg success "$package instalada correctamente."
    done

    print_msg success "Todos los paquetes básicos han sido instalados."
}

clear_system() {
    print_msg info "Limpiando el sistema..."

    print_msg info "Eliminando paquetes innecesarios..."
    if ! sudo apt autoremove -y; then
        print_msg error "Fallo al ejecutar autoremove."
        return 1
    fi

    print_msg info "Limpiando archivos de paquetes descargados..."
    if ! sudo apt autoclean -y; then
        print_msg error "Fallo al ejecutar autoclean."
        return 1
    fi

    print_msg success "Sistema limpiado correctamente."
}

main() {
    while true; do
        clear
        print_menu
        read -p "Seleccione una opción: " option

        case $option in
            1)
                clear
                update_system
                ;;
            2)  
                clear
                install_basic_packages
                ;;
            3)
                clear
                clear_system
                ;;
            0)
                clear
                return 0
                print_msg success "Volviendo al menú principal..."
                ;;
            *)
                clear
                print_msg error "Opción no válida. Por favor, intente de nuevo."
                ;;
        esac
    done
}

main "$@"