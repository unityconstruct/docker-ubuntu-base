# docker-ubuntu-base:latest

Main Docker image that serves as the foundation for the rest of the development images with specific purposes

- Repository:tag

	docker-ubuntu-base:latest

# Dependencies

- BASE UBUNTU OS IMAGE is available here:
- Ubuntu base OCI/docker images: 

This git repo is used by launchpad to build and upload OCI/docker images.
The different series are in different branches.
base image for use in extending for other docker images

- amd64 main page

<https://git.launchpad.net/cloud-images/+oci/ubuntu-base/commit/?h=dist-amd64>

- kinetic oci image/manifest

<https://git.launchpad.net/cloud-images/+oci/ubuntu-base/diff/kinetic/ubuntu-kinetic-oci-amd64-root.manifest?h=dist-amd64>

<https://git.launchpad.net/cloud-images/+oci/ubuntu-base/diff/kinetic/ubuntu-kinetic-oci-amd64-root.tar.gz?h=dist-amd64>

- this image has been downloaded locally to ensure availability at build-time
- Dockerfile ADD will import this base image

	ADD add/ubuntu-kinetic-oci-amd64-root.tar.gz /

# DOCKER ARG

- ARGs are included in the Dockerfile to allow for passing the values from CLI when the image is built
- default values are assigned, so passing in from CLI is optional

```
ARG MYUSER=setup
ARG MYPASS=setup
ARG MYUSERID=222

RUN	echo 'root:root' | chpasswd && \
	# Add ${MYUSER} as id=${MYUSERID}
	useradd -rm -s /bin/bash -g root -G sudo -u ${MYUSERID} ${MYUSER} && \
	#echo 'setup:setup' | chpasswd && \
	echo ${MYUSER}:${MYPASS} | chpasswd && \
```

# DOCKER BUILD

	docker build --build-arg MYUSER=setup --build-arg MYPASS=setup --build-arg MYUSERID=222 -t docker-ubuntu-base:latest .
	
# DOCKER RUN
- example command to run image
- extending images will have different CONTAINER_NAME and append this command

```
docker run -d --rm -it -p 2227:22 --name=CONTAINER_NAME docker-ubuntu-base:latest <...>
      -d : detached
    --rm : remove container when stopped
     -it : interactive with tty
      -p : assign EXPOSE port(s), in this case SSH=22
  --name : container name
```

# SSH Login

- after spawning a container with 'docker run', run 'netstat -ntl' on the same host to verify the exposed port is listening
- this verifies that SSH is running in the container

```
$ netstat -ntl
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 0.0.0.0:2227            0.0.0.0:*               LISTEN
```

- now test the ssh connection

	ssh setup@<hostIP> -p 2227
	
```
$ ssh setup@192.168.0.12 -p 2227

The authenticity of host '[192.168.0.12]:2227 ([192.168.0.12]:2227)' can't be established.
ECDSA key fingerprint is SHA256:+32tG92LzIUTTIbdmgnZ3gQ//2FAE90twdkDaw6+JRY.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '[192.168.0.12]:2227' (ECDSA) to the list of known hosts.
setup@192.168.0.12's password:
Welcome to Ubuntu Kinetic Kudu (development branch) (GNU/Linux 4.15.0-20-generic x86_64)
```
