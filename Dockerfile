FROM scratch
#ARG LAUNCHPAD_BUILD_ARCH=amd-64
#ADD ubuntu-*-oci-$LAUNCHPAD_BUILD_ARCH-root.tar.gz /
ADD ubuntu-kinetic-oci-amd64-root.tar.gz /
CMD ["/bin/bash"]
