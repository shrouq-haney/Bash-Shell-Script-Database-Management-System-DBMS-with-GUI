#! /bin/bash

function DropTable {
    clear
    zenity --info --title="Drop Table" --text="🗑️ Drop Tables in $dbname 🗑️"

    available_tables=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//')

    if [[ -z "$available_tables" ]]; then
        zenity --error --title="Error" --text="❌ No tables found!"
        return
    fi

    # عرض قائمة الجداول لاختيار واحد منها
    tablename=$(zenity --list --title="Select Table to Drop" --column="Tables" --hide-header ${available_tables// / })

    if [[ -z "$tablename" ]]; then
        zenity --error --title="Error" --text="No table selected!"
        return
    fi

    TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
    META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

    if [[ -f "$TABLE_PATH" ]]; then
        zenity --question --title="Confirm Deletion" --text="⚠️ You are about to delete '$tablename'. This action cannot be undone!\nAre you sure?" --ok-label="Yes" --cancel-label="No"
        
        if [[ $? -eq 0 ]]; then
            rm -f "$TABLE_PATH"
            [[ -f "$META_PATH" ]] && rm -f "$META_PATH"
            zenity --info --title="Success" --text="✅ Table '$tablename' was deleted successfully."
        else
            zenity --info --title="Cancelled" --text="ℹ️ Deletion was canceled."
        fi
    else
        zenity --error --title="Error" --text="❌ Table '$tablename' was not found."
    fi
}

