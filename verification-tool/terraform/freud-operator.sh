#!/bin/bash

if [ ! -f ~/config ];
then
	echo -e $(date)' > config file not found' 
	exit 1
fi

source ~/config

main() {

	case $1 in
		help)
			help
			;;
		run)
			manual_mode $2
			;;
		list)
			list_freud_containers
			;;
		logs) 
			show_freud_logs
			;;
		kill)
			stop_current_freud_execution
			;;
		auto) 
			auto_mode
			;;
		enable)
			enable_auto_mode
			;;
		disable)
			disable_auto_mode
			;;
		cron)
			add_to_cron
			;;
		delcron)
			remove_from_cron
			;;
		*) 
			echo -e $(date)' > no recognized command was supplied'
			help
			;;
	esac
}

help() {
	echo  "
	Usage:
		freud run 		-> runs freud with it's default settings - NOTICE this will stop any current freud execution
		freud run <command> 	-> runs a specific frued command - NOTICE this will stop any current freud execution
		freud list 		-> show current running freud containers
		freud logs 		-> show last freud execution logs (type ^c to exit)
		freud kill		-> kills current freud execution
		freud auto 		-> runs freud in auto mode - NOTICE this will only run if ALL the following conditions are met
						   - auto mode is enabled
						   - there is a new freud version 
						   - no other freud execution is currently running
		freud enable 		-> enable auto mode
		freud disable 		-> disable auto mode
		freud cron 		-> add auto mode to cron (auto scheduled)
		freud delcron 		-> remove auto mode from cron (auto scheduled)
	"
}

auto_mode() {
	if [ -e $AUTO_ENABLED_FILE ];
	then
		if ! is_freud_running;
		then
			if login_to_artifactory;
			then
				if pull_latest_image_from_artifcatory; 
				then
					run_freud
				fi
			fi
		fi
	else
		echo -e $(date)' > auto execution is not enabled'
	fi
}

enable_auto_mode() {
	mkdir -p $FREUD_OUTPUT_DIR &>/dev/null
	touch $AUTO_ENABLED_FILE
	echo -e $(date)' > auto execution is enabled'
}

disable_auto_mode() {
	rm $AUTO_ENABLED_FILE &>/dev/null
	echo -e $(date)' > auto execution is disabled'
}

manual_mode() {
	stop_current_freud_execution
	if login_to_artifactory;
		then
			pull_latest_image_from_artifcatory; 
			run_freud $1
			show_freud_logs
		fi
}

is_freud_running() {
	echo -e $(date)' > checking if freud is currently running'
	CONTAINER_ID=$(docker ps -q)
	if [ -z "$CONTAINER_ID" ];
	then
		echo -e $(date)' > freud is not running'
		return 1
	else
		echo -e $(date)' > freud container '$CONTAINER_ID' is currently running'
		return 0
	fi 
}

login_to_artifactory() {
	echo -e $(date)' > logging into docker repository'
	local loginText=$(echo $ARTIFACTORY_PASSWORD | docker login $ARTIFACTORY --username $ARTIFACTORY_USER --password-stdin)
	if [[ $loginText != *"Login Succeeded"* ]];
	then
  		echo $loginText
  		return 1
  	else 
  		return 0
	fi
}

pull_latest_image_from_artifcatory() {
	echo -e $(date)' > pulling latest image from repository'
	local pullText=$(docker pull $FREUD_ARTIFACT 2>&1)
	## TODO DELETE THIS LOG
	##echo $pullText
	if [[ $pullText != *"Status: Image is up to date"* ]];
	then
		echo -e $(date)' > there is a new freud image'
  		return 0
  	else 
  		echo -e $(date)' > freud image has not changed'
  		return 1
	fi
}

run_freud() {
	echo -e $(date)' > running freud '$1
	if [[ $1 ]]; then FREUD_COMMAND='-e IDQ_SPRING_PROFILE='$1; else FREUD_COMMAND=''; fi
	docker run -d --cpus=0.000 \
	$FREUD_COMMAND \
	-e IDQ_LOGGING_EDGE_DOMAIN=$LOGGING_EDGE_DOMAIN \
	-e IDQ_LOGGING_AUTH_DOMAIN=$LOGGING_AUTH_DOMAIN \
	-e IDQ_LOGGING_AUTH_CLIENT_ID=$LOGGING_AUTH_CLIENT_ID \
	-e IDQS_LOGGING_AUTH_CLIENT_SECRET=$LOGGING_AUTH_CLIENT_SECRET \
	-v $FREUD_DIR/output/:/var/app/output \
	-v $FREUD_DIR/:/var/app/input \
	-it $FREUD_ARTIFACT
}

stop_current_freud_execution() {
	echo -e $(date)' > killing old freud containers if exist'
	docker kill $(docker ps -q) &>/dev/null
}

show_freud_logs() {
	echo -e $(date)' > showing logs for container: '$(docker ps -ql)
	echo -e $(date)' > you may exit (^c) at any time to stop seeing the logs - freud will continue to run in the background'
	echo '----------------------------------------------------------------------------------------------------'
	echo ''
	docker logs -f $(docker ps -ql)
}

list_freud_containers() {
	docker ps
}

add_to_cron() {
	echo "*/5 * * * * ~/freud-operator.sh auto > /tmp/freud-operator.log 2>&1" | crontab -
}

remove_from_cron() {
	echo "" | crontab -
}

main "$@"; exit