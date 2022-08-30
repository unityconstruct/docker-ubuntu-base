FROM scratch
ARG LAUNCHPAD_BUILD_ARCH
ADD ubuntu-*-oci-$LAUNCHPAD_BUILD_ARCH-root.tar.gz /
CMD ["/bin/bash"]
