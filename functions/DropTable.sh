#!/bin/bash

function DropTable {
    clear



    available_tables=$(ls "$DB_MAIN_DIR/$dbname" 2>/dev/null | grep -E '^[^_]+\.xml$' | sed 's/.xml$//')

    if [[ -z "$available_tables" ]]; then
        zenity --error --title="Error" --text="❌ No tables found in '$dbname'!"
        return
    fi


    tablename=$(zenity --list --title="🗑️ Drop Tables in $dbname" --column="📂 Available Tables:)" $available_tables)

    if [[ -z "$tablename" ]]; then
        return
    fi

    TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
    META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

    if [[ ! -f "$TABLE_PATH" ]]; then
        zenity --error --title="Error" --text="❌ Table '$tablename' was not found!"
        return
    fi

    zenity --question --title="Confirm Deletion" --text="⚠️ Are you sure you want to delete '$tablename'?\nThis action cannot be undone!" --ok-label="Yes" --cancel-label="No"

    if [[ $? -eq 0 ]]; then
        rm -f "$TABLE_PATH"
        [[ -f "$META_PATH" ]] && rm -f "$META_PATH"
        zenity --info --title="Success" --text="✅ Table '$tablename' was deleted successfully! 🎉"
    else
        zenity --info --title="Cancelled" --text="ℹ️ Deletion was canceled."
    fi
}

