#! /bin/bash

function TablesMainMenu {
    while true; do
        choice=$(zenity --list \
            --title="📋 Database [$dbname] Menu" \
            --column="Option" \
            --column="Description" \
            "➕ Create Table" "Create a new table" \
            "📜 List Tables" "View all tables in the database" \
            "❌ Drop Table" "Delete an existing table" \
            "📥 Insert into Table" "Add new data to a table" \
            "🔎 Select from Table" "Retrieve data from a table" \
            "🗑️ Delete from Table" "Remove records from a table" \
            "✏️ Update Table" "Modify existing data in a table" \
            "🛠️ Alter Table" "Modify the structure of a table" \
            "↩️ Go back to Database Main Menu" "Return to main menu" \
            "🚪 Exit" "Close the program" \
            --height=500 --width=500 --hide-header)

        if [[ -z "$choice" ]]; then
            return  
        fi

        case "$choice" in
            "➕ Create Table") createTable ;;
            "📜 List Tables") ListTable ;;
            "❌ Drop Table") DropTable ;;
            "📥 Insert into Table") insertTable ;;
            "🔎 Select from Table") selectFromTable ;;
            "🗑️ Delete from Table") deleteFromTable ;;
            "✏️ Update Table") UpdateTable ;;
            "🛠️ Alter Table") alterTable ;;  
            "↩️ Go back to Database Main Menu") dbMainMenu ;;
            "🚪 Exit") exit 0 ;;
            *) zenity --error --text="❌ Invalid choice! Please try again." ;;
        esac
    done
}

