#! /bin/bash

function createDB {
    clear


    while true; do
        dbname=$(zenity --entry --title="➕ CREATE A NEW DATABASE " --text="Enter the database name or type 'exit' to return:" 2>/dev/null)

       

        if [[ "$dbname" == "exit" ]]; then
            dbMainMenu
            return
        fi

        validateDBName "$dbname"
        if [[ $? -ne 0 ]]; then
            continue  
        fi

        if [[ -d "$DB_MAIN_DIR/$dbname" ]]; then
            zenity --error --title="Error" --text="❌ Database '$dbname' already exists."
            continue
        fi

        mkdir "$DB_MAIN_DIR/$dbname"
        zenity --info --title="Success" --text="✅ Database '$dbname' has been created successfully! 🎉"
    done
}

