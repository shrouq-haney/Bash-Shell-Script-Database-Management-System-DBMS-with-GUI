#!/bin/bash

function validateColumnname {
    local columnname="$1"

    if [[ -z $columnname ]]; then
        zenity --error --text="❌ Error: Column name cannot be empty."
        return 1
    fi

    if [[ $columnname == *" "* ]]; then
        zenity --error --text="❌ Error: Column name cannot contain spaces."
        return 1
    fi

    if [[ $columnname == *['!''?'@\#\$%^\&*()'-'+\.\/';']* ]]; then
        zenity --error --text="❌ Error: Column name cannot contain special characters."
        return 1
    fi

    if [[ $columnname =~ ^[0-9] ]]; then
        zenity --error --text="❌ Error: Column name cannot start with a number."
        return 1
    fi

    return 0  
}

