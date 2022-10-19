FROM scratch
# base image for use in extending for other docker images
# ----------------------------------------
#         Repository:tag
# docker-ubuntu-base:latest
#
# DOCKER BUILD:
# docker build --build-arg MYUSER=setup --build-arg MYPASS=setup --build-arg MYUSERID=222 -t docker-ubuntu-base:latest .
# ----------------------------------------
# DOCKER RUN: example command to run image 
# docker run -d --rm -it -p 2227:22 --name=CONTAINER_NAME docker-ubuntu-base:latest <...>
#      -d : detached
#    --rm : remove container when stopped
#     -it : interactive with tty
#      -p : assign EXPOSE port(s), in this case SSH=22
#  --name : container name
# ----------------------------------------
# SSH LOGIN:
# ssh setup@<hostIP> -p 2227
# ----------------------------------------
# ADD BASE UBUNTU OS IMAGE (local file) --
#  this image has been downloaded locally to ensure availability at build-time
#  source:
# https://git.launchpad.net/cloud-images/+oci/ubuntu-base/diff/kinetic/ubuntu-kinetic-oci-amd64-root.tar.gz?h=dist-amd64
ADD add/ubuntu-kinetic-oci-amd64-root.tar.gz /
# SSH SERVER -----------------------------
RUN apt-get update && apt-get install -y openssh-client openssh-server openssh-sftp-server
# ARGs to allow user name/pass/id to be pass in from CLI at build-time
#  default values are assigned, so passing in from CLI is optional
ARG MYUSER=setup
ARG MYPASS=setup
ARG MYUSERID=222
RUN	echo 'root:root' | chpasswd && \
	# Add ${MYUSER} as id=${MYUSERID}
	useradd -rm -s /bin/bash -g root -G sudo -u ${MYUSERID} ${MYUSER} && \
	#echo 'setup:setup' | chpasswd && \
	echo ${MYUSER}:${MYPASS} | chpasswd && \
	sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
	sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd && \
	echo "export VISIBLE=now" >> /etc/profile
ENV NOTVISIBLE "in users profile"
# Expose ssh
EXPOSE 22
# TOOLS ( put common utils here so duplicates are needed for each extending image )
RUN apt-get update && apt-get install -y apt-utils htop nano net-tools iputils-ping \
	sed less curl software-properties-common lsb-release git
# CLEAN - apt packages and cache ------------
RUN apt-get --purge autoremove -y && apt-get clean
# SET ENV VARS
ENV TERM=xterm-256color
ENV COLORTERM=truecolor
WORKDIR /var
# SHELL session to start sshd and persist container once started
#CMD /usr/sbin/sshd && /bin/bash # don't start the sshd service yet... do it in the final extending image
CMD /bin/bash
