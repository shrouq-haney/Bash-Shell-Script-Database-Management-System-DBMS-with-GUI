#!/bin/bash

function selectFromTable {
    while true; do
        # 🟢 جلب أسماء الجداول
        tables=($(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//'))

        if [[ ${#tables[@]} -eq 0 ]]; then
            zenity --error --text "No tables found in database '$dbname'!"
            return
        fi

        # 🟢 عرض الجداول للاختيار
        tablename=$(zenity --list --title "Select a Table" --column "Tables" "${tables[@]}")
        [[ -z "$tablename" ]] && return  

        TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

        if [[ ! -f "$TABLE_PATH" || ! -f "$META_PATH" ]]; then
            zenity --error --text "Table '$tablename' does not exist!"
            continue
        fi

        # 🟢 استخراج أسماء الأعمدة
        column_names=()
        while IFS=' ' read -r line; do
            if [[ "$line" =~ name=\"([^\"]+)\" ]]; then
                column_names+=("${BASH_REMATCH[1]}")
            fi
        done < <(grep "<Column " "$META_PATH")

        [[ ${#column_names[@]} -eq 0 ]] && zenity --error --text "No columns found in '$tablename'!" && continue

        # 🟢 اختيار التصفية
        filter_choice=$(zenity --question --text "Do you want to filter by a specific column?" --ok-label "Yes" --cancel-label "No" && echo "yes" || echo "no")

        if [[ "$filter_choice" == "yes" ]]; then
            filter_col=$(zenity --list --title "Choose Column" --column "Columns" "${column_names[@]}")
            [[ -z "$filter_col" ]] && continue

            filter_value=$(zenity --entry --title "Filter Value" --text "Enter value to filter by:")
            [[ -z "$filter_value" ]] && continue

            results=$(awk -v col="$filter_col" -v val="$filter_value" -v columns="$(IFS=,; echo "${column_names[*]}")" '
            BEGIN { RS="<Row>"; FS="\n"; found=0; split(columns, cols, ","); }
            {
                match($0, "<" col ">" val "</" col ">")
                if (RSTART) {
                    row = "";
                    for (i in cols) {
                        field = cols[i];
                        value = "";
                        match($0, "<" field ">[^<]+</" field ">");
                        if (RSTART) {
                            value = substr($0, RSTART + length("<" field ">"), RLENGTH - length("<" field ">") - length("</" field ">"));
                        }
                        if (value == "") value = "N/A";
                        row = row value " ";
                    }
                    print row;
                    found=1;
                }
            }
            END { if (found==0) print "No matching records found!"; }
            ' "$TABLE_PATH")
        else
            results=$(awk -v columns="$(IFS=,; echo "${column_names[*]}")" '
            BEGIN { RS="<Row>"; FS="\n"; split(columns, cols, ","); }
            NR>1 {
                row = "";
                for (i in cols) {
                    field = cols[i];
                    value = "";
                    match($0, "<" field ">[^<]+</" field ">");
                    if (RSTART) {
                        value = substr($0, RSTART + length("<" field ">"), RLENGTH - length("<" field ">") - length("</" field ">"));
                    }
                    if (value == "") value = "N/A";
                    row = row value " ";
                }
                print row;	
            }
            ' "$TABLE_PATH")
        fi

        # 🟢 تحويل النتائج إلى جدول مضبوط
        if [[ -z "$results" || "$results" == "No matching records found!" ]]; then
            zenity --error --text "No matching records found!"
        else
            zenity --list --title "Table Data" --width=800 --height=500 \
                --text "This is the data stored in the table:" \
                $(for col in "${column_names[@]}"; do echo "--column=$col"; done) \
                $(echo "$results")
        fi
    done
}

