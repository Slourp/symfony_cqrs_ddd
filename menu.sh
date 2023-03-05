#!/bin/bash
# A menu driven shell script sample template
## ----------------------------------
# Step #1: Define variables
# ----------------------------------
EDITOR=vim
PASSWD=/etc/passwd
RED='\033[0;41;30m'
STD='\033[0;0;39m'

# ----------------------------------
# Step #2: User defined function
# ----------------------------------
pause(){
    read -p "Press [Enter] key to continue...🐱‍🏍" fackEnterKey
}

createBackEndSymfonylProject(){
    
    DIR="$PWD/app/back"
    if [ -d "$DIR" ]; then
        
        if [ -e "$DIR" ]; then
            
            echo "Project directory "$DIR" is not empty."
            sleep 2
            show_menus
        fi
        mkdir -p $DIR
        return true
    fi
    docker run --rm --interactive --tty --volume $PWD:/app --user $(id -u):$(id -g)  --workdir=/app composer create-project symfony/skeleton:"6.1.*" .
    show_menus
}

# do something in two()
two(){
    echo "two() called"
    pause2
}

# do something in two()
buildDockerImagePROD(){
    echo "Compilation en cours..." & \
    USER=$USER USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f docker-compose.prod.yml build  --parallel &>/dev/null &&\
    docker-compose create web mysql php
    sleep 3
    show_menus
}

# do something in two()
buildDockerImageDEV(){
    echo "Compilation en cours..." & \
    USER=$USER USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f docker-compose.dev.yml build  --parallel &>/dev/null &&\
    docker-compose create web phpmyadmin mysql php
    sleep 3
    show_menus
}

# do something in two()
deleteDockerImage(){
    docker-compose stop
    docker system prune -a
    sleep 3
    show_menus
}

# do something in two()
composerInstall(){
    echo "INSTALL"
    if [ $( docker ps -a | grep POC_SYMFONY | wc -l ) -gt 0 ]; then
        # docker run --rm --interactive --tty --volume $PWD:/app --user $(id -u):$(id -g)  composer install
        docker run --user $(id -u):$(id -g)  -ti  -v $PWD:/app  --workdir=/app symfony_poc_php composer install
    else
        echo "😒POC_SYMFONY does not exist"
    fi
    sleep 3
    # show_menus
}

# do something in two()
startProjectDEV(){
    docker network create dev  &>/dev/null &&\
    USER=$USER USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f docker-compose.dev.yml up --remove-orphans   -V   -d
    sleep 3
    show_menus
}

# do something in two()
startProjectPROD(){
    docker network create traefik-proxy  &>/dev/null &&\
    USER=$USER USER_ID=$(id -u) GROUP_ID=$(id -g) docker-compose -f docker-compose.prod.yml up --remove-orphans   -V   -d
    sleep 3
    show_menus
}

# function to display menus
show_menus() {
    clear
    echo "~~~~~~~~~~~~~~~~~~~~~"
    echo " M A I N - M E N U"
    echo "~~~~~~~~~~~~~~~~~~~~~"
    echo "1. Create a Symfony BackEnd Project🐱‍🏍"
    echo "2. Build docker's images ( docker-build DEV )"
    echo "3. Build docker's images ( docker-build PROD )"
    echo "4. Start project ( DEV )"
    echo "5. Start project ( PROD )"
    echo "6. Delete docker's images 🤧"
    echo "7. Install backend's dependencies"
    echo "8. Kamolux😍"
    echo "0. Exit"
}
# read input from the keyboard and take a action
# invoke the one() when the user select 1 from the menu option.
# invoke the two() when the user select 2 from the menu option.
# Exit when user the user select 3 form the menu option.
read_options(){
    local choice
    read -p "Enter choice [ 1 - 8] " choice
    case $choice in
        0) exit 0;;
        1) createBackEndSymfonylProject ;;
        2) buildDockerImageDEV;;
        3) buildDockerImagePROD;;
        4) startProjectDEV;;
        5) startProjectPROD;;
        6) deleteDockerImage;;
        7) composerInstall;;
        8) telnet towel.blinkenlights.nl;;
        *) echo -e "${RED}Error...${STD}" && sleep 2
    esac
}

# ----------------------------------------------
# Step #3: Trap CTRL+C, CTRL+Z and quit singles
# ----------------------------------------------
trap '' SIGINT SIGQUIT SIGTSTP

# -----------------------------------
# Step #4: Main logic - infinite loop
# ------------------------------------
while true
do
    
    show_menus
    read_options
done
