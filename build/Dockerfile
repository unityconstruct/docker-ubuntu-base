FROM scratch
# base image for use in extending for other docker images
# ----------------------------------------
#         Repository:tag
# docker-ubuntu-base:latest
# ----------------------------------------
# DOCKER RUN: example command to run image 
# docker run -d --rm -it -p 2227:22 --name=CONTAINER_NAME ...
#      -d : detached
#    --rm : remove container when stopped
#     -it : interactive with tty
#      -p : assign EXPOSE port(s), in this case SSH=22
#  --name : container name
# ----------------------------------------
# ADD BASE UBUNTU OS IMAGE (local file) --
#  this image has been downloaded locally to ensure availability at build-time
#  source:
# https://git.launchpad.net/cloud-images/+oci/ubuntu-base/diff/kinetic/ubuntu-kinetic-oci-amd64-root.tar.gz?h=dist-amd64
ADD add/ubuntu-kinetic-oci-amd64-root.tar.gz /
# SSH SERVER -----------------------------
RUN apt-get update && apt-get install -y openssh-client openssh-server openssh-sftp-server
RUN	echo 'root:root' | chpasswd && \
	# Add setup as id=1002
	useradd -rm -s /bin/bash -g root -G sudo -u 1002 setup && \
	echo 'setup:putes' | chpasswd && \	
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
# SHELL session to persist container once started
CMD ["/bin/bash"]
