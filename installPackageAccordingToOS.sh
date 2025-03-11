#!/bin/bash

detect_os() {
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS_ID="$ID"
    elif command -v lsb_release &> /dev/null; then
        OS_ID=$(lsb_release -si | tr '[:upper:]' '[:lower:]')
    else
        echo "Unsupported OS"
        exit 1
    fi
}

install_package() {
	PACKAGE="$1"  # Get the package name from arguments
	detect_os
	case "$OS_ID" in
        ubuntu|debian|kali)
            echo "Detected Debian-based system: Installing $PACKAGE using apt..."
            sudo apt install -y "$PACKAGE"
            ;;
        arch|manjaro)
            echo "Detected Arch-based system: Installing $PACKAGE using pacman..."
            sudo pacman -Syu --noconfirm "$PACKAGE"
            ;;
        fedora)
            echo "Detected Fedora: Installing $PACKAGE using dnf..."
            sudo dnf install -y "$PACKAGE"
            ;;
        centos|rhel)
            echo "Detected CentOS/RHEL: Installing $PACKAGE using yum..."
            sudo yum install -y "$PACKAGE"
            ;;
        *)
            echo "Unsupported OS: $OS_ID"
	    echo "Please try installing the \"$PACKAGE\" manually according to the os"
            exit 1
            ;;
    esac
}



