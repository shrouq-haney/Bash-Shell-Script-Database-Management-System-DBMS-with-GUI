#!/bin/bash

function dropDB {
    clear

    

    DB_LIST=$(ls -1 "$DB_MAIN_DIR" 2>/dev/null)
    
    if [[ -z "$DB_LIST" ]]; then
        zenity --error --title="Error" --text="❌ No databases found!"
        return
    fi

    DB_NAME=$(zenity --list --title="🗑️ Drop a Database" --text="Select Database to Drop" --column="📂 Available Databases:)" $DB_LIST)

    if [[ -z "$DB_NAME" ]]; then
        return
    fi

    DB_PATH="$DB_MAIN_DIR/$DB_NAME"

    if [[ ! -d "$DB_PATH" ]]; then
        zenity --error --title="Error" --text="❌ Database '$DB_NAME' does not exist!"
        return
    fi

    zenity --question --title="Confirm Deletion" --text="⚠️ Are you sure you want to delete '$DB_NAME'?\nThis action cannot be undone!" --ok-label="Yes" --cancel-label="No"
    
    if [[ $? -eq 0 ]]; then
        rm -rf "$DB_PATH"
        zenity --info --title="Success" --text="✅ Database '$DB_NAME' has been deleted successfully! 🎉"
    else
        zenity --info --title="Cancelled" --text="ℹ️ Operation cancelled."
    fi
}

