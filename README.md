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
	
# DOCKER RUN
- example command to run image
- extending images will have different CONTAINER_NAME and append this command

```
docker run -d --rm -it -p 2227:22 --name=CONTAINER_NAME ...
      -d : detached
    --rm : remove container when stopped
     -it : interactive with tty
      -p : assign EXPOSE port(s), in this case SSH=22
  --name : container name
```
