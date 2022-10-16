FROM scratch
# base image for use in extending for other docker images
#         Repository:tag
# docker-ubuntu-base:latest
	# not used ---------------------------------
	#ARG LAUNCHPAD_BUILD_ARCH=amd-64
	#ADD ubuntu-*-oci-$LAUNCHPAD_BUILD_ARCH-root.tar.gz /
# ADD BASE UBUNTU OS IMAGE -------------
ADD add/ubuntu-kinetic-oci-amd64-root.tar.gz /
# TOOLS ---------------------------------
RUN apt-get update && apt-get install -y apt-utils htop nano net-tools iputils-ping sed less
# SSH SERVER -----------------------------
RUN apt-get update && apt-get install -y openssh-client openssh-server openssh-sftp-server
#RUN mkdir /var/run/sshd && \ # dir already exists
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
	### TODO: enabling ssh after the above config, not sure if needed, but couldn't ssh into this image on last check => RUN systemctl is-active ssh && systemctl is-enabled ssh
# CLEAN - apt packages and cache ---------------------------------
RUN apt-get --purge autoremove -y && apt-get clean
ENV TERM=xterm-256color
ENV COLORTERM=truecolor
CMD ["/bin/bash"]
