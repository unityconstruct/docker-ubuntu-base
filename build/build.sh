#!/bin/bash
#
# Build script to create Docker Image from the Dockerfile
#  Prompt for IMAGE name & build
#  Prmopt for CONTAINER name & run
#  Status running containers
#  Output 'docker stop' command for the container
#


# GLOBAL VARS
__DEFAULT_IMAGE_NAME=docker-ubuntu-base:latest
__IMAGE_NAME=null
__DEFAULT_CONTAINER_NAME=dub
__CONTAINER_NAME=null
__DEFAULT_SAVE_PATH_FILENAME=/var/tmp/docker-save-image.tar
__SAVE_PATH_FILENAME=null
__MYUSER=setup
__MYPASS=setup
__MYUSERID=222


#
### IMAGE FUNCTIONS
#

__prompt_for_image_name() {
	# show DEFAULT name, prompt for a new one... 
	# assign it if provided otherwise keep the default
	echo "DEFAULT IMAGE NAME:  [${__DEFAULT_IMAGE_NAME}]"
	echo "CURRENT IMAGE NAME:  [${__IMAGE_NAME}]"
	read -p "Enter IMAGE name and tag[optional]" __RESP
	if [ "${__RESP}" == "" ]; then
		__IMAGE_NAME=${__DEFAULT_IMAGE_NAME}
		echo "keeping default IMAGE name: [${__IMAGE_NAME}]"
	else
		__IMAGE_NAME=${__RESP}
		echo "using NEW IMAGE name: [${__IMAGE_NAME}]"
	fi

}

__show_image_info() {
	echo "CURRENT IMAGE NAME: [${__IMAGE_NAME}]"
	read -p "press ENTER to CONTINUE or CTRL-C to ABORT...." __PAUSED

}

__check_image_is_named() {
	# check if image name has been assigned yet, if not use default
	if [ "${__IMAGE_NAME}" == "null" ]; then
		__IMAGE_NAME="${__DEFAULT_IMAGE_NAME}"
	fi
	
}

__build_image() {

	__check_image_is_named
	__show_image_info
	
	echo "building image...START"
	#docker build --build-arg MYUSER=setup --build-arg MYPASS=setup --build-arg MYUSERID=222 -t docker-ubuntu-base:latest .
	docker build --build-arg MYUSER="${__MYUSER}" --build-arg MYPASS="${__MYPASS}" --build-arg MYUSERID="${__MYUSERID}" -t "${__IMAGE_NAME}" .
	echo "building image...DONE"
	
}


#
### CONTAINER FUNCTIONS
#

__prompt_for_container_name(){
	# show DEFAULT name, prompt for a new one... 
	# assign it if provided otherwise keep the default
	echo "DEFAULT CONTAINER NAME:  [${__DEFAULT_CONTAINER_NAME}]"
	echo "CURRENT CONTAINER NAME:  [${__CONTAINER_NAME}]"
	read -p "Enter container name and tag[optional]" __RESP
	if [ "${__RESP}" == "" ]; then
		__CONTAINER_NAME=${__DEFAULT_CONTAINER_NAME}
		echo "keeping default container name: [${__CONTAINER_NAME}]."
	else
		__CONTAINER_NAME=${__RESP}
		echo "using NEW container name: [${__CONTAINER_NAME}]"
	fi

}

__show_container_info(){
	# data validation before run
	echo "CURRENT IMAGE NAME: [${__IMAGE_NAME}]"
	echo "CURRENT CONTAINER NAME: [${__CONTAINER_NAME}]"
	read -p "press ENTER to CONTINUE or CTRL-C to ABORT...." __PAUSED
}

__check_container_is_named() {
	# check if container name has been assigned yet, if not use default
	if [ "${__CONTAINER_NAME}" == "null" ]; then
		__CONTAINER_NAME="${__DEFAULT_CONTAINER_NAME}"
	fi
	
}

__run_container() {
	# validation on image/container name, then show info
	__check_image_is_named
	__check_container_is_named
	__show_container_info
	
	# now run....
	echo "spawning new container..START"
	docker run -d --rm -it -p 2227:22 --name=${__CONTAINER_NAME} ${__IMAGE_NAME}
	docker build --build-arg MYUSER=setup --build-arg MYPASS=setup --build-arg MYUSERID=222 -t ${__CONTAINER_NAME} .
	#docker build --build-arg MYUSER=setup --build-arg MYPASS=setup --build-arg MYUSERID=222 -t docker-ubuntu-base:latest .
	echo "spawning new container...DONE"
	read -p "press ENTER to CONTINUE or CTRL-C to ABORT...." __PAUSED
	echo "Stop container with: [ docker stop '${__CONTAINER_NAME}' ]"
	echo "Showing running containers [docker ps]"
	docker ps
	
}


#
### SAVE IMAGE FUNCTIONS 
#

__prompt_for_save_path_filename() {
	# show DEFAULT SAVE PATH+FILENAME, prompt for a new one... 
	# assign it if provided otherwise keep the default
	echo "DEFAULT SAVE PATH+FILENAME:  [${__DEFAULT_SAVE_PATH_FILENAME}]"
	echo "CURRENT SAVE PATH+FILENAME:  [${__SAVE_PATH_FILENAME}]"
	read -p "Enter SAVE PATH+FILENAME[optional]" __RESP
	if [ "${__RESP}" == "" ]; then
		__SAVE_PATH_FILENAME=${__DEFAULT_SAVE_PATH_FILENAME}
		echo "keeping SAVE PATH+FILENAME: [${__SAVE_PATH_FILENAME}]."
	else
		__SAVE_PATH_FILENAME=${__RESP}
		echo "using NEW SAVE PATH+FILENAME: [${__SAVE_PATH_FILENAME}]"
	fi

}

__check_save_path_filename_is_named() {
	# check if PATH+FILENAME has been assigned yet, if not use default
	if [ "${__SAVE_PATH_FILENAME}" == "null" ]; then
		__SAVE_PATH="${__DEFAULT_SAVE_PATH_FILENAME}"
	fi
	
}

__show_save_path_filename_info(){
	# data validation before run
	echo "CURRENT IMAGE NAME: [${__SAVE_PATH_FILENAME}]"
	read -p "press ENTER to CONTINUE or CTRL-C to ABORT...." __PAUSED

}

__save_image() {
	__check_save_path_filename_is_named
	__check_image_is_named
	__show_image_info
	__show_save_path_filename_info
	echo "'docker save -o ${__SAVE_PATH_FILENAME} ${__IMAGE_NAME}"
	docker save -o "${__SAVE_PATH_FILENAME}" "${__IMAGE_NAME}"
	
}


#
### MAIN ENTRANCE FUNCTIONS
#

__run(){
	__prompt_for_image_name
	__prompt_for_container_name
	
}

__parse_args() {
	case "${1}" in
	"build")
		read -p "build image ( press ENTER to CONTINUE, CTRL-C to ABORT)" __PAUSED
		__prompt_for_image_name
		__build_image
		
		;;
	"run")
		read -p "spawn/run container ( press ENTER to CONTINUE, CTRL-C to ABORT)" __PAUSED
		__prompt_for_container_name
		__run_container
		;;
	"save")
		read -p "save image, then run it ( press ENTER to CONTINUE, CTRL-C to ABORT)" __PAUSED
		__prompt_for_image_name
		__prompt_for_save_path_filename
		__save_image
		;;
	*)
		__run
		;;
	esac

}


# script can be controlled by passing in a single argument
# if no match found, script will build image, then run container
echo "PASSED ARGS: [$@]"
__parse_args "${1}"
echo "done exiting..."
exit 0
