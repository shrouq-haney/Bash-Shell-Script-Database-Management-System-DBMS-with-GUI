#!/bin/bash

function dbMainMenu {
    while true; do
        choice=$(zenity --list --title="🚀 Database Main Menu" --width=450 --height=350 \
            --text="📌 Please choose an option from the menu below" \
            --column="Option" --column="Description" \
            "📂 Select Database" "Connect to an existing database" \
            "➕ Create Database" "Create a new database" \
            "✏️ Rename Database" "Rename an existing database" \
            "🗑️ Drop Database" "Delete an existing database" \
            "🗃️ Show Databases" "Show all existing databases" \
            "💻 Execute SQL Query" "Run an SQL query" \
            "🚪 Exit" "Close the program")
	
        case $choice in
            "📂 Select Database") selectDB ;;  
            "➕ Create Database") createDB ;;  
            "✏️ Rename Database") renameDB ;;  
            "🗑️ Drop Database") dropDB ;;  
            "🗃️ Show Databases") showDBs ;;  
            "💻 Execute SQL Query") executeSQL ;;  
            "🚪 Exit") zenity --info --text="👋 Exiting, Goodbye!"; exit 0 ;;  
            *)  welcomeScreen
                return
                ;; 
        esac
    done
}
