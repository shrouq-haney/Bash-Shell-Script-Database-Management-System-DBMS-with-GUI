#!/bin/bash

function showDBs { 
    if [[ ! -d "$DB_MAIN_DIR" || -z "$(find "$DB_MAIN_DIR" -mindepth 1 -type d 2>/dev/null)" ]]; then
        zenity --error --text="❌ Sorry, no databases found!"
        return
    fi

    choice=$(zenity --list --title="📂 Database Options" --column="Option" \
        "1) List all databases" "2) Search for a database" --height=250 --width=400)

    case "$choice" in
        "1) List all databases")
            db_list=$(ls -1 "$DB_MAIN_DIR")
            zenity --list --title="🗃️ Available Databases" --column="Databases" $db_list --height=300 --width=400
            ;;
        "2) Search for a database")
            dbname=$(zenity --entry --title="🔍 Search Database" --text="Enter database name:")
            if [[ -z "$dbname" ]]; then return; fi

            if [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
                zenity --info --text="✅ Database '$dbname' exists!"
            else
                zenity --error --text="❌ Database '$dbname' not found!"
            fi
            ;;
        *)
            return
            ;;
    esac
}

