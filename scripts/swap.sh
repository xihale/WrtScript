#!/bin/bash

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if the script is run with sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (using sudo)."
   exit 1
fi

SWAP_FILE="/swapfile"

create_swap() {
    read -p "Enter the desired size of the swap file in MB: " SWAP_SIZE_MB

    echo "Creating a swap file of ${SWAP_SIZE_MB}MB. This may take a while..."
    fallocate -l ${SWAP_SIZE_MB}M ${SWAP_FILE}
    if [ $? -ne 0 ]; then
        echo "Error creating swap file. Ensure you have enough free disk space and fallocate is installed."
        return 1
    fi

    chmod 600 ${SWAP_FILE}
    mkswap ${SWAP_FILE}
    if [ $? -ne 0 ]; then
        echo "Error setting up swap area."
        rm -f ${SWAP_FILE}
        return 1
    fi

    swapon ${SWAP_FILE}
    if [ $? -ne 0 ]; then
        echo "Error enabling swap."
        rm -f ${SWAP_FILE}
        return 1
    fi

    # Add to /etc/fstab to make it permanent
    echo "${SWAP_FILE} swap swap defaults 0 0" | sudo tee -a /etc/fstab > /dev/null
    echo "Swap file created and enabled successfully."
}

adjust_swap() {
    if ! swapon --show | grep -q "${SWAP_FILE}"; then
        echo "No swap file (${SWAP_FILE}) is currently active to adjust. Please create one first or check if SWAP_FILE variable is correctly set."
        return 1
    fi

    swapoff ${SWAP_FILE}
    if [ $? -ne 0 ]; then
        echo "Error disabling swap."
        return 1
    fi

    read -p "Enter the new desired size of the swap file in MB: " NEW_SWAP_SIZE_MB

    echo "Resizing swap file to ${NEW_SWAP_SIZE_MB}MB. This may take a while..."
    rm -f ${SWAP_FILE} # Remove the old swap file
    fallocate -l ${NEW_SWAP_SIZE_MB}M ${SWAP_FILE}
    if [ $? -ne 0 ]; then
        echo "Error creating new swap file."
        return 1
    fi
    chmod 600 ${SWAP_FILE}
    mkswap ${SWAP_FILE}
     if [ $? -ne 0 ]; then
        echo "Error setting up new swap area."
        rm -f ${SWAP_FILE}
        return 1
    fi
    swapon ${SWAP_FILE}
    if [ $? -ne 0 ]; then
        echo "Error enabling new swap."
        rm -f ${SWAP_FILE}
        return 1
    fi

    echo "Swap file resized and enabled successfully."
}

delete_swap() {
    if ! swapon --show | grep -q "${SWAP_FILE}"; then
        echo "No swap file (${SWAP_FILE}) is currently active to delete. Please create one first or check if SWAP_FILE variable is correctly set."
        return 1
    fi

    swapoff ${SWAP_FILE}
    if [ $? -ne 0 ]; then
        echo "Error disabling swap."
        return 1
    fi

    # Remove from /etc/fstab
    sudo sed -i "/${SWAP_FILE} swap swap/d" /etc/fstab
    rm -f ${SWAP_FILE}
    echo "Swap file deleted successfully."
}

show_menu() {
    echo -e "${GREEN}"
    cat << "EOF"
>>==============================================<<
||                                              ||
||                                   _          ||
||      _____      ____ _ _ __   ___| |__       ||
||     / __\ \ /\ / / _` | '_ \ / __| '_ \      ||
||     \__ \\ V  V / (_| | |_) |\__ \ | | |     ||
||     |___/ \_/\_/ \__,_| .__(_)___/_| |_|     ||
||                       |_|                    ||
||                                              ||
||                       -- GamerNoTitle        ||
||                          https://bili33.top  ||
>>==============================================<<
EOF
    echo -e "${NC}"
    
    echo -e "${YELLOW}Swap Management Script${NC}"
    echo -e "${YELLOW}-----------------------${NC}"
    echo -e "${YELLOW}1. Create Swap File${NC}"
    echo -e "${YELLOW}2. Adjust Swap File Size${NC}"
    echo -e "${YELLOW}3. Delete Swap File${NC}"
    echo -e "${YELLOW}4. Exit${NC}"
    echo -e "${YELLOW}-----------------------${NC}"
    
    echo -ne "${YELLOW}Enter your choice (1-4): ${NC}"
}

while true; do
    show_menu
    read choice
    case $choice in
        1)
            create_swap
            ;;
        2)
            adjust_swap
            ;;
        3)
            delete_swap
            ;;
        4)
            echo "Exiting."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 4."
            ;;
    esac
    echo ""
done
