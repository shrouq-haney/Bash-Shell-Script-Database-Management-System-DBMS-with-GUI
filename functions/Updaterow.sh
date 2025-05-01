#!/bin/bash

function UpdateTable {
    clear
    zenity --info --title="Update Table - $dbname" \
           --text="✏️ Update Data in Table - $dbname"

    while true; do
        tables=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//')
        tablename=$(zenity --entry --title="Select Table" \
                           --text="📌 Available Tables in '$dbname':\n\n$(echo "$tables" | awk '{print "📄 " $0}')\n\nEnter table name:")

        [[ -z "$tablename" ]] && return

        TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

        if [[ ! -f "$TABLE_PATH" ]]; then
            zenity --error --text="❌ Table '$tablename' does not exist!"
            continue
        fi
        break
    done

    column_names=()
    column_types=()
    primary_key=""

    while read -r line; do
        col_name=$(echo "$line" | grep -oP 'name="\K[^"]+')
        col_type=$(echo "$line" | grep -oP 'type="\K[^"]+')
        is_primary=$(echo "$line" | grep -oP 'primaryKey="\K[^"]+')

        if [[ -n "$col_name" && "$col_name" != "$tablename" ]]; then
            column_names+=("$col_name")
            column_types+=("$col_type")
            [[ "$is_primary" == "true" ]] && primary_key="$col_name"
        fi
    done < "$META_PATH"

    if [[ -z "$primary_key" ]]; then
        zenity --error --text="❌ No primary key defined!"
        return
    fi

    columns_display=$(for i in "${!column_names[@]}"; do
        printf "📌 %-15s | %-10s\n" "${column_names[$i]}" "${column_types[$i]}"
    done)

    zenity --info --title="Table Columns" \
           --text="🔍 Columns in '$tablename':\n\n$columns_display"

    while true; do
        pk_value=$(zenity --entry --title="Find Row" --text="Enter value of Primary Key ($primary_key) to update:")
        [[ -z "$pk_value" ]] && return

        row=$(awk -v pk="$pk_value" -v key="$primary_key" '
            BEGIN { RS="</Row>"; ORS="" }
            $0 ~ "<"key">"pk"</"key">" {
                print $0"</Row>"
            }
        ' "$TABLE_PATH")

        if [[ -z "$row" ]]; then
            choice=$(zenity --list --radiolist --title="No Row Found" \
                --text="❌ No row found with $primary_key = $pk_value. Choose an option:" \
                --column="Select" --column="Option" TRUE "Try again" FALSE "Exit to Main Menu")
            case $choice in
                "Try again") continue ;;
                "Exit to Main Menu") TablesMainMenu; return ;;
                *) zenity --error --text="❌ Invalid choice."; continue ;;
            esac
        else
            break
        fi
    done

    row_display=$(echo "$row" | sed -E 's/<\/?Row>//g' | grep -oP '<[^>]+>[^<]+</[^>]+>' | while read -r line; do
        key=$(echo "$line" | grep -oP '^<\K[^>]+')
        value=$(echo "$line" | grep -oP '>\K[^<]+')
        echo "🔸 $key : $value"
    done)

    zenity --info --title="Row Found" --text="✅ Row found:\n\n$row_display"

    update_columns=$(for i in "${!column_names[@]}"; do
        if [[ "${column_names[$i]}" != "$primary_key" ]]; then
            printf "   %-15s | %-10s\n" "${column_names[$i]}" "${column_types[$i]}"
        fi
    done)

    zenity --info --title="Available Columns" --text="🛠 Available columns for update:\n\n$update_columns"

    while true; do
        col_to_update=$(zenity --entry --title="Column to Update" --text="Enter column name to update:")
        [[ -z "$col_to_update" ]] && return

        valid_col=false
        for name in "${column_names[@]}"; do
            if [[ "$name" == "$col_to_update" && "$name" != "$primary_key" ]]; then
                valid_col=true
                break
            fi
        done

        if [[ "$valid_col" != true ]]; then
            choice=$(zenity --list --radiolist --title="Invalid Column" \
                --text="❌ Invalid column! Choose an option:" \
                --column="Select" --column="Option" TRUE "Try again" FALSE "Exit to Main Menu")
            case $choice in
                "Try again") continue ;;
                "Exit to Main Menu") TablesMainMenu; return ;;
                *) zenity --error --text="❌ Invalid choice."; continue ;;
            esac
        else
            break
        fi
    done

    idx=-1
    for i in "${!column_names[@]}"; do
        [[ "${column_names[$i]}" == "$col_to_update" ]] && idx=$i && break
    done
    type="${column_types[$idx]}"
    old_val=$(echo "$row" | grep -oP "<$col_to_update>\K[^<]+")

    new_val=$(zenity --entry --title="New Value" --text="🔍 Current value: $old_val\nEnter new value:")
    [[ -z "$new_val" ]] && return

    if [[ "$type" == "int" && ! "$new_val" =~ ^[0-9]+$ ]]; then
        zenity --error --text="❌ Invalid input: Expected an integer!"
        return
    fi
    if [[ "$type" == "string" && -z "$new_val" ]]; then
        zenity --error --text="❌ Invalid input: String cannot be empty!"
        return
    fi

    new_row=$(echo "$row" | sed "s|<$col_to_update>$old_val</$col_to_update>|<$col_to_update>$new_val</$col_to_update>|")

    tmp_file=$(mktemp)
    awk -v old="$row" -v new="$new_row" '
        BEGIN { RS="</Row>"; ORS="" }
        {
            if ($0 "</Row>" == old) {
                print new
            } else {
                print $0"</Row>"
            }
        }
    ' "$TABLE_PATH" > "$tmp_file" && mv "$tmp_file" "$TABLE_PATH"

    choice=$(zenity --list --radiolist --title="Update Successful" \
        --text="✅ Successfully updated '$col_to_update' to '$new_val'!\n\nWhat do you want to do next?" \
        --column="Select" --column="Option" TRUE "Return to Main Menu" FALSE "Update Another Row")

    case $choice in
        "Return to Main Menu") TablesMainMenu; return ;;
        "Update Another Row") UpdateTable; return ;;
        *) zenity --error --text="❌ Invalid choice!" ;;
    esac
}

