#!/bin/bash

function validateDBName {
    local dbname="$1"

    if [[ -z $dbname ]]; then
        zenity --error --text="❌ Error: Database name cannot be empty."
        return 1
    fi

    if [[ $dbname == *" "* ]]; then
        zenity --error --text="❌ Error: Database name cannot contain spaces."
        return 1
    fi

    if [[ $dbname == *['!''?'@\#\$%^\&*()'-'+\.\/';']* ]]; then
        zenity --error --text="❌ Error: Database name cannot contain special characters."
        return 1
    fi

    if [[ $dbname =~ ^[0-9] ]]; then
        zenity --error --text="❌ Error: Database name cannot start with a number."
        return 1
    fi

    return 0  
}

