#!/bin/bash

function selectDB {
    clear

    
    dbname=$(zenity --list --title="🔗 CONNECT TO DATABASE 🔗" --column="🗃️ Available databases:)" $(ls -1 "$DB_MAIN_DIR") --width=400 --height=300)
    
    if [[ -z "$dbname" ]]; then
        dbMainMenu
        return
    fi
    
    validateDBName "$dbname"
    if [[ $? -ne 0 ]]; then
        
        return
    fi

    if [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
        zenity --info --title="Success" --text="✅ Successfully connected to '$dbname'! 🎉" --width=300
        TablesMainMenu
    else
        zenity --error --title="Error" --text="❌ Database '$dbname' does not exist." --width=300
        
        to_create=$(zenity --question --title="Create Database" --text="Do you want to create a new database?" --width=300)
        if [[ $? -eq 0 ]]; then
            createDB
        fi
    fi
}

