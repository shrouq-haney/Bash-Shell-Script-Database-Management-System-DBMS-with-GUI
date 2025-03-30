#!/bin/bash

function showDBs { 
    while true; do
        choice=$(zenity --list --title="📂 AVAILABLE DATABASES 📂" \
                        --column="Option" --column="Description" \
                        1 "List all databases" \
                        2 "Search for a specific database" \
                        3 "Exit" \
                        --width=400 --height=250)


        case $choice in
            "1")
                if [[ ! -d "$DB_MAIN_DIR" || -z $(find "$DB_MAIN_DIR" -mindepth 1 -type d 2>/dev/null) ]]; then
                    zenity --error --text="❌ Sorry, no databases found!" --width=300
                else
                    db_list=$(ls -1 "$DB_MAIN_DIR" | awk '{print "📂 " $0}')
                    zenity --info --title="🗃️ Databases" --text="$db_list" --width=400 --height=300
                fi
                ;;
            "2")
                SpecificDB
                ;;
            "3")
                dbMainMenu
                return
                ;;
            *)
                dbMainMenu
                return
                ;;
        esac
    done
}

