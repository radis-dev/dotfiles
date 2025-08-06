#!/bin/bash
set -e

source lib/env.sh
source lib/print.sh
source lib/utils.sh

print_menu() {
    echo "1) Instalar Flatpak" 
    echo "2) Instalar aplicaciones de Flathub"
    echo "3) Actualizar aplicaciones de Flathub"
    echo "0) Volver al menú principal" 
}

install_flatpak() {
    if is_installed "flatpak"; then
        print_msg error "Flatpak ya está instalado."
        return 0
    fi

    print_msg info "Instalando Flatpak..."

    if ! { sudo apt update && sudo apt install flatpak -y; }; then
        print_msg error "Error al instalar Flatpak."
        return 1
    fi

    print_msg success "Flatpak instalado correctamente."

    print_msg info "Agregando Flathub..."

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

    print_msg success "Flathub agregado correctamente."
}

install_apps() {
    local apps=(
        "com.github.tchx84.Flatseal"
        "com.mattjakeman.ExtensionManager" 
        "com.bitwarden.desktop"
        "com.google.Chrome"
        "org.mozilla.Thunderbird"
        "org.gitfourchette.gitfourchette"
        "com.visualstudio.code"
        "io.dbeaver.DBeaverCommunity"
        "es.danirod.Cartero"
        "com.termius.Termius"
        "com.obsproject.Studio"
        "org.videolan.VLC"
        "org.libreoffice.LibreOffice"
        "org.qbittorrent.qBittorrent"
        "md.obsidian.Obsidian"
        "org.audacityteam.Audacity"
    )
    
    print_msg info "Instalando aplicaciones de Flathub..."

    if ! is_installed "flatpak"; then
        print_msg error "Flatpak no está instalado."
        return 0
    fi

    for app in "${apps[@]}"; do
        if flatpak list --app --columns=application | tail -n +1 | grep -Fxq "$app"; then
            print_msg warning "La aplicación $app ya está instalada con Flatpak."
            continue
        fi

        if ! flatpak remote-info flathub "$app" &> /dev/null; then
            print_msg error "La aplicación $app no está disponible en Flathub."
            continue
        fi

        print_msg info "Instalando $app..."

        if ! flatpak install -y flathub "$app"; then
            print_msg error "Error al instalar $app."
            continue
        fi

        print_msg success "$app instalada correctamente."
    done

    print_msg success "Todas las aplicaciones instaladas correctamente."
}

update_apps() {
    print_msg info "Actualizando aplicaciones de Flathub..."

    if ! is_installed "flatpak"; then
        print_msg error "Flatpak no está instalado."
        return 0
    fi

    if ! flatpak update -y; then
        print_msg error "Error al actualizar las aplicaciones de Flathub."
        return 1
    fi

    print_msg success "Todas las aplicaciones de Flathub han sido actualizadas correctamente."
}

main() {
    while true; do
        clear
        print_menu
        read -p "Seleccione una opción: " option

        case $option in
            1)
                clear
                install_flatpak
                ;;
            2)
                clear
                install_apps
                ;;
            3)
                clear
                update_apps
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
