#!/bin/bash

function renameDB {
    old_name=$(zenity --entry --title="🔄 Rename Database" --text="Enter the database name to rename or exit to return back")

        if [[ $? -ne 0 ]]; then  
            dbMainMenu
            return
        fi
    if [[ -z "$old_name" ]]; then
        return
    fi

    if [[ ! -d "$DB_MAIN_DIR/$old_name" ]]; then
        zenity --error --text="❌ Error: Database '$old_name' does not exist!"
        return
    fi

    new_name=$(zenity --entry --title="🔄 Rename Database" --text="Enter the new database name:")

    if [[ -z "$new_name" ]]; then
        return
    fi

    if [[ -d "$DB_MAIN_DIR/$new_name" ]]; then
        zenity --error --text="❌ Error: Database '$new_name' already exists!"
        return
    fi

    zenity --question --text="Are you sure you want to rename '$old_name' to '$new_name'?" --title="Confirm Rename"
    if [[ $? -eq 0 ]]; then
        mv "$DB_MAIN_DIR/$old_name" "$DB_MAIN_DIR/$new_name"
        zenity --info --text="✅ Database renamed successfully from '$old_name' to '$new_name'!"
    else
        zenity --warning --text="⚠️ Operation canceled!"
    fi
}

