#!/bin/bash
#
# Build script to create Docker Image from the Dockerfile
#  Prompt for IMAGE name & build
#  Prmopt for CONTAINER name & run
#  Status running containers
#  Output 'docker stop' command for the container
#


#__DEFAULT_IMAGE_NAME=docker-ubuntu-base:latest
__DEFAULT_IMAGE_NAME=docker-ubuntu-base:dev
__DEFAULT_CONTAINER_NAME=dub
__IMAGE_NAME=null
__CONTAINER_NAME=null


__prompt_for_image_name() {
	# show DEFAULT name, prompt for a new one... 
	# assign it if provided otherwise keep the default
	echo "CURRENT IMAGE NAME:  ${__DEFAULT_IMAGE_NAME}"
	read -p "Enter IMAGE name and tag[optional]" __RESP
	if [ "${__RESP}" == "" ]; then
		__IMAGE_NAME=${__DEFAULT_IMAGE_NAME}
		echo "keeping default IMAGE name..."
	else
		__IMAGE_NAME=${__RESP}
		echo "using NEW IMAGE name..."
	fi
	echo "CURRENT IMAGE NAME: [${__IMAGE_NAME}]"
	read -p "press ENTER to CONTINUE or CTRL-C to ABORT...." __PAUSED
	
	echo "building image...START"
	#docker build --build-arg MYUSER=setup --build-arg MYPASS=setup --build-arg MYUSERID=222 -t docker-ubuntu-base:latest .
	docker build --build-arg MYUSER=setup --build-arg MYPASS=setup --build-arg MYUSERID=222 -t ${__IMAGE_NAME} .
	echo "building image...DONE"
	
}


__prompt_for_container_name(){
	# check if image name has been assigned yet, if not use default 
	if [ "${__IMAGE_NAME}" == "null" ]; then
		__IMAGE_NAME="${__DEFAULT_IMAGE_NAME}"
	fi
	
	# show DEFAULT name, prompt for a new one... 
	# assign it if provided otherwise keep the default
	echo "CURRENT CONTAINER NAME:  ${__DEFAULT_CONTAINER_NAME}"
	read -p "Enter container name and tag[optional]" __RESP
	if [ "${__RESP}" == "" ]; then
		__CONTAINER_NAME=${__DEFAULT_CONTAINER_NAME}
		echo "keeping default container name..."
	else
		__CONTAINER_NAME=${__RESP}
		echo "using NEW container name..."
	fi
	
	# data validation before run
	echo "CURRENT IMAGE NAME: [${__IMAGE_NAME}]"
	echo "CURRENT CONTAINER NAME: [${__CONTAINER_NAME}]"
	read -p "press ENTER to CONTINUE or CTRL-C to ABORT...." __PAUSED
	
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

__run(){
	__prompt_for_image_name
	__prompt_for_container_name
}

echo "PASSED ARGS: [$@]"


if [ "${1}" == "build" ]; then
	read -p "build image ( press ENTER to CONTINUE, CTRL-C to ABORT)" __PAUSED
	__prompt_for_image_name
elif [ "${1}" == "run" ]; then
	read -p "spawn/run container ( press ENTER to CONTINUE, CTRL-C to ABORT)" __PAUSED
	__prompt_for_container_name
else
	read -p "buildimage, then run it ( press ENTER to CONTINUE, CTRL-C to ABORT)" __PAUSED
	__run
fi

echo "done exiting..."
exit 0


