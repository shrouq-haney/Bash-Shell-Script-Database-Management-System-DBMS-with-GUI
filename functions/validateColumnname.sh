#!/bin/bash

function validateColumnname {
    local columnname="$1"

    if [[ -z $columnname ]]; then
        zenity --error --title="❌ Error" --text="Column name cannot be empty."
        return 1
    fi

    if [[ $columnname == *" "* ]]; then
        zenity --error --title="❌ Error" --text="Column name cannot contain spaces."
        return 1
    fi

    if [[ $columnname == *['!''?'@\#\$%^\&*()'-'+\.\/';']* ]]; then
        zenity --error --title="❌ Error" --text="Column name cannot contain special characters."
        return 1
    fi

    if [[ $columnname =~ ^[0-9] ]]; then
        zenity --error --title="❌ Error" --text="Column name cannot start with a number."
        return 1
    fi

    if [[ $columnname == "exit" ]]; then
        rm -f "$TABLE_PATH" "$META_PATH"
        TablesMainMenu
    fi	

    return 0  
}

