#! /bin/bash

function createTable {
    clear
    echo "=========================================="
    echo "➕ Create Tables in [$dbname]  ➕"
    echo "=========================================="
	
    read -p "Enter the number of tables to create: " table_count                     #suggestion : to let him specify the number of tables he will enter
    if [[ "$table_count" -le 0 ]]; then
        echo -e "${RED} Invalid number of tables!${NC}"
        return
    fi

    for (( i = 1; i <= table_count; i++ )); 
    	do
        read -p "Enter table name or type 'exit' : " tablename
        [[ "$tablename" == "exit" ]] && return

        TABLE_PATH="$DB_MAIN_DIR/$dbname/$tablename.xml"
        META_PATH="$DB_MAIN_DIR/$dbname/${tablename}_meta.xml"

        if [[ -f "$TABLE_PATH" ]]; then
            echo -e "${RED}  Table '$tablename' already exists!${NC}"
            continue
        fi

        read -p "Enter number of columns: " col_count
        if [[ "$col_count" -le 0 ]]; then
            echo -e "${RED}  Invalid Column Count!${NC}"
            continue
        fi

        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$TABLE_PATH"
        echo "<Table name=\"$tablename\">" >> "$TABLE_PATH"
        echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" > "$META_PATH"
        echo "<TableMeta name=\"$tablename\">" >> "$META_PATH"
        echo "  <Columns count=\"$col_count\">" >> "$META_PATH"

        primary_key_count=0  						#count number of primar_ key because it can be either 1 pk or 0 (for week entity )

        for ((j = 1; j <= col_count; j++)); do
            col_name=""
            col_type=""

            while [[ -z "$col_name" ]]; do
                read -p "Column $j Name 'cannot be empty' : " col_name
                [[ "$col_name" == "exit" ]] && echo -e "${RED}  Table creation canceled.${NC}" && rm -f "$TABLE_PATH" "$META_PATH" && return
            done

            while [[ ! "$col_type" =~ ^(string|int)$ ]]; do
                read -p "Data Type (string/int): " col_type
                [[ "$col_type" == "exit" ]] && echo -e "${RED}  Table creation canceled.${NC}" && rm -f "$TABLE_PATH" "$META_PATH" && return
            done

            read -p "Is this the Primary Key? (Y/N): " is_pk
            if [[ "$is_pk" =~ ^[Yy]$ ]]; then
                if [[ "$primary_key_count" -eq 1 ]]; then
                    echo -e "${RED}  Error: Only one Primary Key is allowed!${NC}"
                    ((j--))
                    continue
                fi
                is_pk="true"
                ((primary_key_count++))
            else
                is_pk="false"
            fi

            read -p "Unique? (Y/N): " is_unique
            [[ "$is_unique" =~ ^[Yy]$ ]] && is_unique="true" || is_unique="false"

            read -p "Nullable? (Y/N): " is_nullable
            [[ "$is_nullable" =~ ^[Yy]$ ]] && is_nullable="true" || is_nullable="false"

            echo "<Column name=\"$col_name\" type=\"$col_type\" primaryKey=\"$is_pk\" unique=\"$is_unique\" nullable=\"$is_nullable\" />" >> "$META_PATH"
        done

        if [[ "$primary_key_count" -eq 0 ]]; 
        then
        echo -e "${YELLOW} Warning: No Primary Key defined! Continue without PK? (Y/N) ${NC}"
            read  choice
            [[ ! "$choice" =~ ^[Yy]$ ]] && echo -e "${RED}  Table creation canceled${NC}" && rm -f "$TABLE_PATH" "$META_PATH" && return
        fi

        echo "  </Columns>" >> "$META_PATH"
        echo "</TableMeta>" >> "$META_PATH"
        echo "</Table>" >> "$TABLE_PATH"

        echo -e "${GREEN} Table '$tablename' created successfully ${NC}"
        
       	return
    done
}

