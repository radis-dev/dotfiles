#!/bin/bash
set -e

source lib/env.sh
source lib/print.sh
source lib/utils.sh

print_menu() {
    echo "1) Instalar ZSH"
    echo "2) Instalar Oh My ZSH" 
    echo "3) Configurar ZSH" 
    echo "0) Volver al menú principal" 
}

install_zsh() {
    if is_installed "zsh"; then
        print_msg error "ZSH ya está instalado."
        return 0
    fi

    print_msg info "Instalando ZSH..."

    if ! { sudo apt update && sudo apt install zsh -y; }; then
        print_msg error "Error al instalar ZSH."
        return 1
    fi

    print_msg success "ZSH instalado correctamente."
}

install_oh_my_zsh() {
    if ! is_installed "zsh"; then
        print_msg error "ZSH no está instalado."
        return 0
    fi

    if ! is_installed "git"; then
        print_msg error "Git no está instalado."
        return 0
    fi

    if [[ -d "$USER_HOME/.oh-my-zsh" ]]; then
        print_msg error "Ya existe una instalación de Oh My Zsh."
        return 0
    fi

    print_msg info "Instalando Oh My Zsh..."

    if ! git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$USER_HOME/.oh-my-zsh"; then
        print_msg error "Error al instalar Oh My Zsh"
        return 0
    fi

    print_msg success "Oh My Zsh instalado correctamente."
}

configure_zsh() {
    if ! is_installed "zsh"; then
        print_msg error "ZSH no está instalado."
        return 0
    fi

    if ! [[ -f "$USER_HOME/.dotfiles/config/zsh/.zshrc" ]]; then
        print_msg error "No se encontró el archivo de configuración de ZSH"
        return 1
    fi

    print_msg info "Enlazando archivo de configuración de ZSH..."

    if ! ln -sf "$USER_HOME/.dotfiles/config/zsh/.zshrc" "$USER_HOME/.zshrc"; then
        print_msg error "Error al enlazar el archivo de configuracion de ZSH"
        return 0
    fi

    print_msg info "Cambiando la shell por defecto a ZSH..."

    if ! sudo chsh -s "$(command -v zsh)" "$SUDO_USER"; then
        print_msg error "Error al cambiar la shell por defecto a ZSH."
        return 1
    fi

    print_msg success "Configuración de ZSH aplicada correctamente. Abre una nueva terminal para ver los cambios."
}

main() {
    while true; do
        clear
        print_menu
        read -p "Seleccione una opción: " option

        case $option in
            1)
                clear
                install_zsh
                ;;
            2)
                clear
                install_oh_my_zsh
                ;;
            3)
                clear
                configure_zsh
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