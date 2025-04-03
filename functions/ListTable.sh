#! /bin/bash

function ListTable {
    while true; do
        choose=$(zenity --list --title="Tables List in $dbname" \
                      --text="Choose an option:" \
                      --column="Option" --column="Description" \
                      "1" "List all tables" \
                      "exit" "Return to main menu" --width=400 --height=250)
        
        case $choose in
            "exit")
                TablesMainMenu
                return
                ;;
            "1")
                if [[ ! -d "$DB_MAIN_DIR/$dbname" || -z $(ls -A "$DB_MAIN_DIR/$dbname" 2>/dev/null) ]]; then
                    zenity --error --title="Error" --text="No tables found in '$dbname'!" --width=300
                else
                    tables=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//')
                    zenity --info --title="Available Tables" --text="$(echo "$tables" | awk '{print "📄 " $0}')" --width=300 --height=300
                fi
                ;;
            *)
                zenity --error --title="Error" --text="Invalid option! Please try again." --width=300
                ;;
        esac
    done
}

