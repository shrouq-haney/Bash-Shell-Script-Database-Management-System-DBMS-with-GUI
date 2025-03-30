#!/bin/bash

function insertTable {
    clear

    
    tables=$(ls "$DB_MAIN_DIR/$dbname" 2>/dev/null | grep -E '^[^_]+\.xml$' | sed 's/.xml$//')
    if [[ -z "$tables" ]]; then
        zenity --error --text="❌ No tables found in '$dbname'!"
        
        return
    fi
    
    tablename=$(zenity --list --title="📝 Insert Data into Table in $dbname " --column="📂 Available Tables:)" $tables)
    if [[ -z "$tablename" ]]; then
        TablesMainMenu
        return
    fi
    
    TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
    META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"
    
    column_names=()
    column_types=()
    column_constraints=()
    
    while IFS=' ' read -r line; do
        if [[ "$line" =~ name=\"([^\"]+)\" ]]; then
            column_names+=("${BASH_REMATCH[1]}")
        fi
        if [[ "$line" =~ type=\"([^\"]+)\" ]]; then
            column_types+=("${BASH_REMATCH[1]}")
        fi
        if [[ "$line" =~ unique=\"([^\"]+)\" ]]; then
            column_constraints+=("${BASH_REMATCH[1]}")
        fi
    done < <(grep "<Column " "$META_PATH")

    if [[ ${#column_names[@]} -eq 0 ]]; then
        zenity --error --text="❌ No columns found in '$tablename'!"
        return
    fi
    
    row_values=()
    for i in "${!column_names[@]}"; do
        col_name="${column_names[$i]}"
        col_type="${column_types[$i]}"
        is_unique="${column_constraints[$i]}"
        
        while true; do
            col_value=$(zenity --entry --title="Enter Data" --text="Enter value for $col_name ($col_type):")
            if [[ -z "$col_value" ]]; then
                zenity --error --text="❌ Input cannot be empty!"
                continue
            fi
            if [[ "$col_type" == "string" && ! "$col_value" =~ ^[a-zA-Z\ ]+$ ]]; then
                zenity --error --text="❌ $col_name must contain only letters and spaces!"
                continue
            elif [[ "$col_type" == "int" && ! "$col_value" =~ ^[0-9]+$ ]]; then
                zenity --error --text="❌ $col_name must contain only numbers!"
                continue
            fi
            if [[ "$is_unique" == "true" && -n "$col_value" && $(grep -q "<$col_name>$col_value</$col_name>" "$TABLE_PATH") ]]; then
                zenity --error --text="❌ Value for $col_name must be unique!"
                continue
            fi
            row_values+=("$col_value")
            break
        done
    done
    
    sed -i '$d' "$TABLE_PATH"
    echo "  <Row>" >> "$TABLE_PATH"
    for i in "${!column_names[@]}"; do
        echo "    <${column_names[$i]}>${row_values[$i]}</${column_names[$i]}>" >> "$TABLE_PATH"
    done
    echo "  </Row>" >> "$TABLE_PATH"
    echo "</Table>" >> "$TABLE_PATH"
    
    zenity --info --text="✅ Data inserted successfully into '$tablename' 🎉"
    
    choice=$(zenity --list --title="Next Action" --column="Options" "Return to Main Menu" "Insert Another Row")
    case "$choice" in
        "Return to Main Menu") TablesMainMenu ;;
        "Insert Another Row") insertTable ;;
    esac
}

