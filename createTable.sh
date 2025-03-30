#!/bin/bash

function createTable {
    clear


    while true; do 
        tablename=$(zenity --entry --title="➕ Create Table ➕" --text="Enter table name or type 'exit':")
        [[ "$tablename" == "exit" ]] && TablesMainMenu && return
        	[[ -z "$tablename" ]] &&TablesMainMenu && return
        validatetablename "$tablename"
        [[ $? -ne 0 ]] && continue  

        TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

        if [[ -f "$TABLE_PATH" ]]; then
            zenity --error --text="Table '$tablename' already exists!"
            continue
        fi

        col_count=$(zenity --entry --title="Column Count" --text="Enter number of columns:")
        if ! [[ "$col_count" =~ ^[1-9][0-9]*$ ]]; then
            zenity --error --text="Column Count must be an integer!"
            continue
        fi

        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$TABLE_PATH"
        echo "<Table name=\"$tablename\">" >> "$TABLE_PATH"
        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$META_PATH"
        echo "<TableMeta name=\"$tablename\">" >> "$META_PATH"
        echo "  <Columns count=\"$col_count\">" >> "$META_PATH"

        primary_key_count=0  
        
        for ((j = 1; j <= col_count; j++)); do
            while true; do
                col_name=$(zenity --entry --title="Column Name" --text="Enter column name:")
                validateColumnname "$col_name"
                [[ $? -ne 0 ]] && continue  
                
                col_type=$(zenity --list --title="Column Type" --text="Choose data type:" --column="Type" string int)
                [[ -z "$col_type" ]] && zenity --error --text="Invalid choice, please select 'string' or 'int'" && continue
                break
            done

            is_pk=$(zenity --question --title="Primary Key" --text="Is this the Primary Key?" && echo "true" || echo "false")
            [[ "$is_pk" == "true" ]] && ((primary_key_count++))

            is_unique=$(zenity --question --title="Unique" --text="Should this column be unique?" && echo "true" || echo "false")
            is_nullable=$(zenity --question --title="Nullable" --text="Can this column be NULL?" && echo "true" || echo "false")

            echo "<Column name=\"$col_name\" type=\"$col_type\" primaryKey=\"$is_pk\" unique=\"$is_unique\" nullable=\"$is_nullable\" />" >> "$META_PATH"
        done

        if [[ "$primary_key_count" -eq 0 ]]; then
            zenity --error --text="Error: No Primary Key defined! You must insert a PK."
            rm -f "$TABLE_PATH" "$META_PATH" 
            continue
        fi

        echo "  </Columns>" >> "$META_PATH"
        echo "</TableMeta>" >> "$META_PATH"
        echo "</Table>" >> "$TABLE_PATH"

        zenity --info --text="Table '$tablename' created successfully! 🎉"
        choice=$(zenity --list --title="Next Action" --text="What do you want to do next?" --column="Option" "Return to Main Menu" "Add Another Table")
        [[ "$choice" == "Return to Main Menu" ]] && TablesMainMenu && return
    done
}
