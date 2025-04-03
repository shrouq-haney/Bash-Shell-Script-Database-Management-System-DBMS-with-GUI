#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DB_MAIN_DIR="$SCRIPT_DIR/Databases"

for file in "$SCRIPT_DIR/functions/"*.sh; do
    source "$file"
done

if ! [[ -d "$DB_MAIN_DIR" ]]; then
    mkdir -p "$DB_MAIN_DIR"
fi

clear

zenity --info --title="👋 Welcome to our DBMS 👋" --width=400 --height=250 --no-wrap \
       --text="

          🚀 Bash Shell Script Database Management System 🚀
           
           ⭐ Telecom Application Development - Intake 45 ⭐
   
   
   
        👩‍💻 Developed by:  
        
          • Sara Yousrei
          • Shrouq Haney

       "


function welcomeScreen {
    while true; do
        choice=$(zenity --list --title="📌 Main Menu" --width=400 --height=250 \
            --text="Enter to your database or Exit"\
            --column="Option" \
            "Enter to your database" \
            "Exit")

        case $choice in
            "Enter to your database") dbMainMenu ;;  
            "Exit") zenity --info --text="👋 Exiting, Goodbye!"; exit 0 ;;  
            *) zenity --error --text="❌ Invalid option! Please try again." ;;  
        esac
    done
}

welcomeScreen

