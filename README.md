# Database Management System with GUI (Zenity)

## 📌 Project Overview
This project is a **Database Management System (DBMS)** built using **Bash scripting** and **Zenity** for the graphical user interface (GUI). The system allows users to create, modify, and manage XML-based databases with an easy-to-use graphical interface.

## 🛠️ Features
- 📂 **Create & Delete Databases**
- 📄 **Create, View, Modify & Delete Tables**
- ➕ **Add, Update & Delete Columns**
- 🔍 **Insert, Select, Update & Delete Records**
- 📊 **Data Filtering & Search Functionality**
- 🎨 **User-Friendly GUI with Zenity**

## 🚀 Getting Started
### **🔹 Prerequisites**
Make sure you have the following installed on your system:
- **Bash (Default in Linux)**
- **Zenity** (for GUI dialogs)
- **awk, sed, grep** (for processing XML data)

To install Zenity, run:
```bash
sudo apt-get install zenity  # Debian-based (Ubuntu, Linux Mint, etc.)
sudo dnf install zenity      # Fedora
sudo yum install zenity      # CentOS, RHEL
```

### **🔹 Running the Project**
1. Clone the repository:
   ```bash
   git clone git@github.com:shrouq-haney/Bash-Shell-Script-Database-Management-System-DBMS-with-GUI.git
   ```
2. Give execution permissions:
   ```bash
   chmod +x main.sh
   ```
3. Run the project:
   ```bash
   ./main.sh
   ```

## 📜 How It Works
### **🔹 Main Menu**
When you launch the script, you will see a Zenity menu with the following options:
- **Manage Databases** (Create/Delete databases)
- **Manage Tables** (Create/Modify/Delete tables)
- **Manage Records** (Insert/Update/Delete data)
- **Exit** (Close the application)

### **🔹 Managing Databases**
- Create a new database by entering a name.
- Select a database to manage existing tables.
- Delete a database if it's no longer needed.

### **🔹 Managing Tables**
- Create a new table by specifying column names.
- View table structure and existing records.
- Modify table schema (add/delete columns).
- Delete a table when it's no longer needed.

### **🔹 Managing Records**
- Insert new records into a selected table.
- View all records or apply filters using Zenity dialogs.
- Update existing records by choosing a specific column and value.
- Delete records from a table with a simple selection.

## 🏗️ Project Structure
```
📂 database-gui
├── 📜 main.sh           # Main script to start the application
├── 📜 db_manager.sh     # Handles database creation/deletion
├── 📜 table_manager.sh  # Handles table operations
├── 📜 record_manager.sh # Handles record operations (CRUD)
├── 📂 databases/        # Directory where XML databases are stored
└── 📜 README.md         # This file
```

## 📌 Example XML Table Structure
An example of how the data is stored in XML format:
```xml
<Table name="employees">
    <Row>
        <id>1</id>
        <name>John Doe</name>
        <position>Software Engineer</position>
    </Row>
    <Row>
        <id>2</id>
        <name>Jane Smith</name>
        <position>Project Manager</position>
    </Row>
</Table>
```


---
🚀 **Enjoy managing your databases with this simple yet powerful GUI-based DBMS!**


