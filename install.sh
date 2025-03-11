BASE_DIR=$(dirname "$(realpath "$0")")
source "$BASE_DIR/configuration.conf"
source "$BASE_DIR/fun.sh"
source "$BASE_DIR/installPackageAccordingToOS.sh"
mkdir -p /opt/ToDoListWithRofi
mkdir -p $LOG_LOCATION
check_requirements(){
	for requirement in $(cat $REQUIRED_PACKAGE_LIST)
	do
		if command -v $requirement &> /dev/null
		then
			echo "module \"$requirement\" already installed"
		else
			install_package $requirement
		fi
	done
}

if [ -e /opt/ToDoListWithRofi ]; then
    print_doggy
    echo "Existing installation found"
    
    exit $E_EXISTING_INSTALLATION_FOUND
else
    mkdir -p /opt/ToDoListWithRofi
    print_doggy
    echo "Copying files..."
    cp -r "$(dirname "$(realpath "$0")")"/* /opt/ToDoListWithRofi
    echo "Creating shortcuts..."
    mkdir -p /var/log/ToDoListWithRofi
    ln -s /opt/ToDoListWithRofi/ToDo.sh /usr/bin/ToDo 
    #echo -e "Execute \e[34m source /opt/ToDoListWithRofi/autoCompletion.sh \e[0m to enable tab completion"
    #echo "source /opt/ToDoListWithRofi/autoCompletion.sh" >> ~/.bashrc
    ## bash --rcfile <(cat ~/.bashrc; echo "source /opt/ToDoListWithRofi/autoCompletion.sh")
    #exec bash
fi
