#!/bin/bash

function selectDB {
    if [[ ! -d "$DB_MAIN_DIR" || -z "$(ls -A "$DB_MAIN_DIR")" ]]; then
        zenity --warning --text="⚠️ No databases found! Create one first."
        return
    fi

    dbname=$(zenity --list --title="🔗 Connect to Database" --column="🗃️Available Databases" $(ls -1 "$DB_MAIN_DIR") --height=300 --width=400)

        if [[ $? -ne 0 ]]; then  
            dbMainMenu
            return
        fi
    if [[ -z "$dbname" ]]; then
        return
    fi

    if [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
        zenity --info --text="✅ Successfully connected to '$dbname'!"
        TablesMainMenu
    else
        zenity --error --text="❌ Error: Database '$dbname' does not exist."
        zenity --question --text="Do you want to create a new database with this name?" --title="Create Database"
        
        if [[ $? -eq 0 ]]; then
            createDB "$dbname"
        fi
    fi
}

