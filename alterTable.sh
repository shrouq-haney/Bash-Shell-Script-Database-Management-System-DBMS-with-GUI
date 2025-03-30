#! /bin/bash

function alterTable {
    clear
    zenity --info --title="Alter Table" --text="🛠️ Alter Table in $dbname 🛠️\n\n📌 Available Tables in $dbname:" --width=400
    
    tables=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//')
    if [[ -z "$tables" ]]; then
        zenity --error --title="Error" --text="❌ No tables found in '$dbname'!"
        TablesMainMenu
        return
    fi

    while true; do
        dtb=$(zenity --list --title="Select Table" --column="Tables" $tables)
        [[ -z "$dtb" ]] && TablesMainMenu && return

        TABLE_PATH="$DB_MAIN_DIR/$dbname/$dtb.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${dtb}_meta.xml"

        if [[ ! -f "$TABLE_PATH" || ! -f "$META_PATH" ]]; then
            zenity --error --title="Error" --text="❌ Table '$dtb' does not exist!"
            continue
        fi

        while true; do
            choice=$(zenity --list --title="Alter Table" --text="What do you want to do?" --column="Options" "Add a new column" "Delete an existing column" "Go back")
            [[ "$choice" == "Go back" ]] && break
            [[ -z "$choice" ]] && TablesMainMenu && return

            case "$choice" in
                "Add a new column")
                    new_col=$(zenity --entry --title="New Column" --text="Enter new column name:")
                    [[ -z "$new_col" ]] && continue
                    default_value=$(zenity --entry --title="Default Value" --text="Enter default value (or leave empty):")
                    
                    echo "    <Column name=\"$new_col\" type=\"string\" />" >> "$META_PATH"
                    sed -i "/<\/Row>/ i\    <$new_col>$default_value</$new_col>" "$TABLE_PATH"
                    zenity --info --title="Success" --text="✅ Column '$new_col' added successfully! 🎉"
                    ;;
                
                "Delete an existing column")
                    del_col=$(zenity --entry --title="Delete Column" --text="Enter column name to delete:")
                    [[ -z "$del_col" ]] && continue
                    
                    if ! grep -q "<Column name=\"$del_col\"" "$META_PATH"; then
                        zenity --error --title="Error" --text="❌ Column '$del_col' not found in table '$dtb'."
                        continue
                    fi
                    
                    sed -i "/<Column name=\"$del_col\"/d" "$META_PATH"
                    sed -i "s/<$del_col>.*<\/$del_col>//g" "$TABLE_PATH"
                    zenity --info --title="Success" --text="✅ Column '$del_col' deleted successfully! 🎉"
                    ;;
                
                *)
                    zenity --error --title="Error" --text="❌ Invalid choice!"
                    ;;
            esac
        done
    done
}

