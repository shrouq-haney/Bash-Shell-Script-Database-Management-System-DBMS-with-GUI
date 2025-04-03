#!/bin/bash

function SpecificDB {
    while true; do
        dbname=$(zenity --entry --title="🔍 SEARCH FOR A DATABASE" \
                        --text="Enter the database name or type 'exit' to return:" \
                        --width=400)

        if [[ -z "$dbname" ]]; then
            showDBs
        fi

        validateDBName "$dbname"
        if [[ $? -ne 0 ]]; then
            continue
        fi

        if [[ "$dbname" == "exit" ]]; then
            dbMainMenu
            return
        elif [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
            db_contents=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//' | awk '{print "📄"$0}')

            zenity --list --title="📂 Database: $dbname" \
                   --column="Available Tables" ${db_contents[@]} --width=400 --height=300

            zenity --question --title="🔗 Connect to Database" \
                   --text="Do you want to connect to [$dbname]?" --width=300
            
            if [[ $? -eq 0 ]]; then
                TablesMainMenu
                return
            fi
        else
            zenity --error --title="❌ Error" \
                   --text="The database '$dbname' was not found." --width=300
        fi
    done
}

