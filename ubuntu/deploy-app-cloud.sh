#!/bin/bash

# deploy - A script to deploy web application
# frojas		2018-10-19
#				Update deployment mode.

##### Constants
RED='\033[0;41;30m'
STD='\033[0;0;39m'
DEPLOY_MODE='all'

##### Functions

show_usage()
{
	echo "usage: deploy [[[-f file ] [-i]] | [-h]]"
	exit
}

show_system_info()
{
	DATE=$(date +"%x %r %Z")
	UPTIME=$(uptime -p)
	DISK=$(df / | grep / | awk '{ print $5}')
	MEM=$(df / | grep / | awk '{ print $5}' | sed 's/%//g')

	echo ""
	echo "####################################################"
	echo "System Information"
	echo "Date: $DATE"
	echo "Hostname: $HOSTNAME"
	echo "Uptime: $UPTIME"
	echo "User: $USER"
	echo "Use Disk: $DISK"
	echo "Free RAM: $MEM"
	echo "####################################################"
	echo ""
}

canceling()
{
	echo "Canceling...";
	exit 0
}

aborting()
{
	echo -e "${RED}Aborting...${STD}" && sleep 2
	exit 1
}

ending()
{
        echo "Ending..."
        exit
}

starting()
{
	echo "Starting...";
	show_system_info
	sudo service apache2 restart
	
	if [ "$DEPLOY_MODE" == "front" ]; then
	
		deploy_front
		
	elif [ "$DEPLOY_MODE" == "back" ]; then
	
		deploy_back
		
	elif [ "$DEPLOY_MODE" == "all" ]; then
	
		deploy_back
		deploy_front
		
	else	
		ending		
	fi
	
	
}

deploy_back(){

	echo "Backup folder $B_PUBLIC_PATH"
	# Backup folder
	if [ -d "$B_PUBLIC_PATH" ]; then
		cd $B_PUBLIC_PATH && php artisan down
        cd $B_APP_PATH && sudo rm -rf public_html_old
		sudo mv $PUBLIC_DIR public_html_old
	fi

	echo "Create folder $B_PUBLIC_PATH"
	# Create folder
	sudo mkdir -p $B_PUBLIC_PATH && cd $B_PUBLIC_PATH

	echo "Clone repository"
	# Clone repository
	sudo chown ubuntu:ubuntu -R . && git clone $B_REPOSITORY . && git checkout $RP_BRANCH

	echo "Copy enviroment file"
	# Copy enviroment file
	cp ../public_html_old/.env .

	echo "Compile back"
	# Compile back
	php composer.phar self-update && php composer.phar install 
	sudo chown ubuntu:www-data -R vendor
	php composer.phar update && php composer.phar diagnose && php composer.phar validate
	php artisan clear-compiled && php artisan cache:clear && php composer.phar clear-cache && php composer.phar dump-autoload
	php artisan config:cache && php artisan route:cache && php artisan optimize
	
	echo "Change owner"
	# Change owner
	cd $B_PUBLIC_PATH && sudo chown -R www-data:www-data .
}

deploy_front(){
	
	echo "Backup folder $F_PUBLIC_PATH"
	# Backup folder
	if [ -d "$F_PUBLIC_PATH" ]; then
        cd $F_APP_PATH && sudo rm -rf public_html_old
		sudo mv $PUBLIC_DIR public_html_old
	fi

	echo "Create folder $F_PUBLIC_PATH"
	# Create folder
	sudo mkdir -p $F_PUBLIC_PATH && cd $F_PUBLIC_PATH

	echo "Clone repository"
	# Clone repository
	sudo chown ubuntu:ubuntu -R . && git clone $F_REPOSITORY . && git checkout $RP_BRANCH

	echo "Compile front"
	# Compile front
	cd app && npm install && npm run $ENV 
	# && cp -r dist/static/ ../ && cp dist/index.html ../ && rm -rf dist
	
	echo "Change owner"
	# Change owner
	cd $F_PUBLIC_PATH && sudo chown -R www-data:www-data .
} 

###

# Verify parameter
#if [ $# -eq 0 ]
#  then
#    echo "No arguments supplied"
#fi

for i in "$@"
do
case $i in

    --help)           
    show_usage
    ;;
	--dm=*) 
	DEPLOY_MODE="${i#*=}"
	shift
    ;;	
    --default)
    DEFAULT=YES
    shift
    ;;
    *)
    # unknown option	
    ;;
esac
done

show_config()
{
		clear 

        echo ""
        echo "####################################################"
        echo "Configuration"
		echo "Deployment Mode: $DEPLOY_MODE"

		# Directorio publico
		WWW_PATH='/var/www'
		PUBLIC_DIR='public_html'		
		RP_BRANCH='staging'
		ENV='stg'
		
		# Codigo fuente
		RP_PROVIDER='git@github.com'
		
		B_APP_DIR='b.agileteams.co'	
		B_APP_PATH="$WWW_PATH/$B_APP_DIR"
		B_PUBLIC_PATH="$B_APP_PATH/$PUBLIC_DIR"
		B_RP_PATH='frojas-gfourmis/gf-atsuite-backend.git'
		B_REPOSITORY="$RP_PROVIDER:$B_RP_PATH"	
		
		F_APP_DIR='f.agileteams.co'
		F_APP_PATH="$WWW_PATH/$F_APP_DIR"
		F_PUBLIC_PATH="$F_APP_PATH/$PUBLIC_DIR"
		F_RP_PATH='frojas-gfourmis/gf-atsuite-frontend.git'					
		F_REPOSITORY="$RP_PROVIDER:$F_RP_PATH"
		
        echo "Backend  Public Path: $B_PUBLIC_PATH"
        echo "Backend  Repository:  $B_REPOSITORY ($RP_BRANCH)"								
        echo "Frontend Public Path: $F_PUBLIC_PATH"
        echo "Frontend Repository:  $F_REPOSITORY ($RP_BRANCH)"		
		echo "Frontend Build Mode:  $ENV"		
        echo "####################################################"
        echo ""
}

show_config

read -p "¿Are you sure you want to continue? (y|n): " confirm;

case $confirm in
        y|Y) starting;;
        n|N) canceling;;
        *) aborting;;
esac

ending

if [[ -n $1 ]]; then
	echo "Deployment..."
#    tail -1 $1
fi
