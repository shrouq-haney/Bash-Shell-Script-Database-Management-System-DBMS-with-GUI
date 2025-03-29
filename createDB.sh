#!/bin/bash

function createDB {
    while true; do
        dbname=$(zenity --entry --title="📂 Create Database" --text="Enter the database name or 1 to return back")

        
        if [[ $? -ne 0 ]]; then  
            dbMainMenu
            return
        fi

        if [[ "$dbname" == "1" ]]; then
            return
        fi

        validateDBName "$dbname"
        if [[ $? -ne 0 ]]; then
            zenity --error --text="❌ Error: Invalid database name."
            continue
        fi

        if [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
            zenity --error --text="❌ Error: Database '$dbname' already exists."
            continue
        fi

        mkdir "$DB_MAIN_DIR/$dbname"
        zenity --info --title="🎉 congratulations" --text="✅ Database '$dbname' has been created successfully! 🎉"
        continue
    done
}

