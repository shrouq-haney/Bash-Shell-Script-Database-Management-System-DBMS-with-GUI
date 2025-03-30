#!/bin/bash

function deleteFromTable {
    clear
    zenity --info --title="Delete Row" --text="🗑️ Delete Row by Primary Key in $dbname"
    
    while true; do
        tables=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//')
        
        if [[ -z "$tables" ]]; then
            zenity --error --title="Error" --text="❌ No tables found in '$dbname'!"
            return
        fi

        dtb=$(zenity --list --title="Select Table" --column="Tables" $tables)
        [[ -z "$dtb" ]] && return

        TABLE_PATH="$DB_MAIN_DIR/$dbname/$dtb.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${dtb}_meta.xml"

        if [[ ! -f "$TABLE_PATH" || ! -f "$META_PATH" ]]; then
            zenity --error --title="Error" --text="❌ Table '$dtb' does not exist!"
            continue
        fi

        PK_COL=$(grep 'primaryKey="true"' "$META_PATH" | sed -n 's/.*name="\([^"]*\)".*/\1/p')

        if [[ -z "$PK_COL" ]]; then
            zenity --error --title="Error" --text="❌ No Primary Key found in '$dtb'."
            continue
        fi

        pk_value=$(zenity --entry --title="Delete Row" --text="Enter Primary Key value to delete the row")
        [[ -z "$pk_value" ]] && continue

        if ! grep -q "<$PK_COL>$pk_value</$PK_COL>" "$TABLE_PATH"; then
            zenity --error --title="Error" --text="❌ No matching record found with PK='$pk_value'!"
            continue
        fi

        awk -v pk_col="$PK_COL" -v pk_value="$pk_value" '
        BEGIN { inside_row=0; found=0; row_data="" }
        /<Row>/ { inside_row=1; row_data=$0; next }
        /<\/Row>/ {
            row_data = row_data ORS $0;
            if (found == 0) { print row_data }
            inside_row=0; found=0; row_data="";
            next
        }
        {
            row_data = row_data ORS $0;
            if ($0 ~ "<" pk_col ">" pk_value "</" pk_col ">") {
                found=1;
            }
        }
        ' "$TABLE_PATH" > temp.xml && mv temp.xml "$TABLE_PATH"

        zenity --info --title="Success" --text="✅ Row with PK='$pk_value' deleted successfully!"
    done
}

