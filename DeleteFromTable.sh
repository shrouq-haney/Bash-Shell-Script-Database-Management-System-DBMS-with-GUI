#! /bin/bash

function deleteFromTable {
    clear
    zenity --info --title="Delete from Table" --text="🗑️ Delete from Table in [$dbname] 🗑️"
    
    choice=$(zenity --list --title="Choose Delete Option" --column="Option" --hide-header "Delete specific record" "Delete specific column")
    
    if [[ -z "$choice" ]]; then
        zenity --error --title="Error" --text="No option selected!"
        return
    fi

    table_list=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '\.xml$' | sed 's/.xml$//' | tr '\n' '|')
    
    dtb=$(zenity --list --title="Select Table" --column="Tables" --hide-header ${table_list//|/ })

    if [[ -z "$dtb" ]]; then
        zenity --error --title="Error" --text="No table selected!"
        return
    fi

    TABLE_PATH="$DB_MAIN_DIR/$dbname/$dtb.xml"
    META_PATH="$DB_MAIN_DIR/$dbname/${dtb}_meta.xml"

    if [[ ! -f "$TABLE_PATH" ]]; then
        zenity --error --title="Error" --text="Table '$dtb' does not exist!"
        return
    fi

    if [[ "$choice" == "Delete specific record" ]]; then
        coldel=$(zenity --entry --title="Column Name" --text="Enter column to delete record from:")
        vldel=$(zenity --entry --title="Value" --text="Enter value to delete:")

        if [[ -z "$coldel" || -z "$vldel" ]]; then
            zenity --error --title="Error" --text="Column or value cannot be empty!"
            return
        fi

        sed -i "/<$coldel>$vldel<\/$coldel>/d" "$TABLE_PATH"

        zenity --info --title="Success" --text="Record deleted successfully!"
    
    elif [[ "$choice" == "Delete specific column" ]]; then
        coldel=$(zenity --entry --title="Column Name" --text="Enter column name to delete:")

        if [[ -z "$coldel" ]]; then
            zenity --error --title="Error" --text="Column name cannot be empty!"
            return
        fi

        sed -i "/<$coldel>.*<\/$coldel>/d" "$TABLE_PATH"
        sed -i "/<Column name=\"$coldel\"/d" "$META_PATH"

        zenity --info --title="Success" --text="Column '$coldel' deleted successfully!"
    fi
}

