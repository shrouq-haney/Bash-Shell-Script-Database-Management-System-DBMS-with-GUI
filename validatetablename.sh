#!/bin/bash

function validatetablename {
    local tablename="$1"

    if [[ -z $tablename ]]; then
        zenity --error --text="❌ Error: Table name cannot be empty."
        return 1
    fi

    if [[ $tablename == *" "* ]]; then
        zenity --error --text="❌ Error: Table name cannot contain spaces."
        return 1
    fi

    if [[ $tablename == *['!''?'@\#\$%^\&*()'-'+\.\/';']* ]]; then
        zenity --error --text="❌ Error: Table name cannot contain special characters."
        return 1
    fi

    if [[ $tablename =~ ^[0-9] ]]; then
        zenity --error --text="❌ Error: Table name cannot start with a number."
        return 1
    fi

    return 0  
}

