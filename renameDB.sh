#!/bin/bash

function renameDB {
    clear


    while true; do
    
        old_name=$(zenity --entry --title="✏️ RENAME DATABASE"\
        --text="Enter the database name to rename or type 'exit' to return:")

	
        if [[ $? -ne 0 || $old_name == "exit" ]]; then
            dbMainMenu
            return
        fi

        if [[ ! -d "$DB_MAIN_DIR/$old_name" ]]; then
            zenity --error --title="❌ Error" --text="Database '$old_name' does not exist!"
            continue
        fi

        new_name=$(zenity --entry --title="Enter New Database Name" --text="Enter the new database name:")

        validateDBName "$new_name"
        if [[ $? -ne 0 ]]; then
            continue
        fi
        
        if [[ -d "$DB_MAIN_DIR/$new_name" ]]; then
            zenity --error --title="❌ Error" --text="Database '$new_name' already exists!"
            continue
        fi
        
        
        mv "$DB_MAIN_DIR/$old_name" "$DB_MAIN_DIR/$new_name"
        
        zenity --info --title="✅ Success" --text="Database renamed successfully from '$old_name' to '$new_name'! 🎉"
    done
}

