function dropDB {
    clear
    zenity --info --title="Delete Database" --text="🗑️ DELETE A DATABASE"

    # عرض قائمة قواعد البيانات
    databases=$(ls -1 "$DB_MAIN_DIR")

    if [[ -z "$databases" ]]; then
        zenity --error --title="Error" --text="❌ No databases found!"
        return
    fi

    # اختيار قاعدة البيانات من القائمة
    DB_NAME=$(zenity --list --title="Select Database to Delete" --column="Databases" --hide-header ${databases// / })

    if [[ -z "$DB_NAME" ]]; then
        zenity --error --title="Error" --text="❌ No database selected!"
        return
    fi

    DB_PATH="$DB_MAIN_DIR/$DB_NAME"

    if [[ -d "$DB_PATH" ]]; then
        zenity --question --title="Confirm Deletion" --text="⚠️ You are about to delete '$DB_NAME'. This action cannot be undone!\nAre you sure?" --ok-label="Yes" --cancel-label="No"
        
        if [[ $? -eq 0 ]]; then
            rm -rf "$DB_PATH"
            zenity --info --title="Success" --text="✅ Database '$DB_NAME' has been deleted successfully!"
        else
            zenity --info --title="Cancelled" --text="ℹ️ Deletion was canceled."
        fi
    else
        zenity --error --title="Error" --text="❌ Database '$DB_NAME' does not exist!"
    fi
}

