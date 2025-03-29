#! /bin/bash
function ListTable {
    clear
    zenity --info --title="List Tables" --text="📋 Listing Tables in '$dbname' 📋"

    # التحقق من وجود قواعد البيانات والجداول
    if [[ ! -d "$DB_MAIN_DIR/$dbname" || -z $(ls -A "$DB_MAIN_DIR/$dbname" 2>/dev/null) ]]; then
        zenity --error --title="Error" --text="❌ No tables found in '$dbname'!"
        return
    fi

    # الحصول على قائمة الجداول بدون ملفات الـ meta
    tables=$(ls "$DB_MAIN_DIR/$dbname" | grep -E '^[^_]+\.xml$' | sed 's/.xml$//')

    # التحقق من وجود جداول بالفعل
    if [[ -z "$tables" ]]; then
        zenity --error --title="Error" --text="❌ No tables found in '$dbname'!"
        return
    fi

    # عرض قائمة الجداول باستخدام Zenity
    zenity --list --title="Available Tables" --column="Tables" --hide-header ${tables// / }

}

