#!/bin/bash

function SpecificDB {
    clear
    zenity --info --title="Search for Database" --text="🔍 SEARCH FOR A DATABASE"

    while true; do
        dbname=$(zenity --entry --title="Enter Database Name" --text="🔹 Enter the database name or type 'exit' to return:")

        if [[  "$dbname" == "exit" ]]; then
            dbMainMenu
            return
        fi

        validateDBName "$dbname"
        if [[ $? -ne 0 ]]; then
            continue
        fi

        if [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
            contents=$(ls -1 "$DB_MAIN_DIR/$dbname" | awk '{print "📄 " $0}')

            zenity --list --title="Database Contents" --column="Files in '$dbname'" --hide-header ${contents// / }

            to_connect=$(zenity --question --title="Connect to Database" --text="Do you want to connect to [$dbname]?")

            if [[ $? -eq 0 ]]; then
                TablesMainMenu
            fi
        else
            zenity --error --title="Database Not Found" --text="❌ Error: The database '$dbname' was not found."
        fi
    done
}

