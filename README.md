ToDoList

ToDoList is a lightweight, Rofi-based to-do list manager for Linux.
Installation
Prerequisites

    Ensure you have the necessary dependencies installed before running the installation script.
    The required packages are listed in configuration.conf.

Steps to Install

    Clone the repository:

    bash

git clone https://github.com/krishnaprasad-2001/ToDoList.git

cd ToDoList

Make the installation script executable:

bash

chmod +x install.sh

Run the installation script:

bash

    ./install.sh

What the Installer Does

    Creates necessary directories:
        /opt/ToDoList
        /var/log/ToDoList

    Installs missing dependencies.

    Copies files to /opt/ToDoList.

    Creates a symbolic link /usr/bin/ToDo for easy execution.

Usage

Once installed, you can use the application by running:

bash

ToDo

Uninstallation

To remove ToDoList completely, run the following commands:

bash

rm -rf /opt/ToDoList

rm -rf /var/log/ToDoList

rm -f /usr/bin/ToDo

Contributing

Feel free to submit issues or pull requests to improve this project.
