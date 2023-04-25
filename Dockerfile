FROM		   ubuntu:18.04
MAINTAINER	gcccompil3r@gmail.com
LABEL 		authors="gcccompil3r@gmail.com"

#build with docker build --build-arg PETALINUX_INSTALLER=petalinux-v2019.2-final-installer.run -t petalinux

#RUN apt-get update -o Acquire::CompressionTypes::Order::=gz

ARG PETALINUX_INSTALLER
ARG PETALINUX

#ENV DEBIAN_FRONTEND=noninteractive

# add sourcelist
RUN sed -i 's/archive.ubuntu.com/kr.archive.ubuntu.com/g' /etc/apt/sources.list && \
    cat /etc/apt/sources.list && \
    dpkg --add-architecture i386
   
# Issue - https://forums.xilinx.com/t5/Embedded-Linux/petaconfig-c-kernel-error/td-p/764606
# Issue - https://forums.xilinx.com/t5/Embedded-Linux/Petalinux-2017-4-docker-container/td-p/825802
# Issue - If you wanna need some edit then you need editing tools like vim
# package update
RUN apt-get -y update

ENV TZ=Europe/Rome
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Apt-Utils
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends apt-utils

RUN apt-get -y install build-essential sudo expect emacs openssh-server gcc gawk diffstat xvfb chrpath socat xterm autoconf libtool libtool-bin python git net-tools zlib1g-dev libncurses5-dev libssl-dev xz-utils locales \
wget tftpd cpio gcc-multilib tofrodos iproute2 gnupg flex bison unzip make texinfo libsdl1.2-dev libglib2.0-dev zlib1g:i386 screen lsb-release vim libgtk2.0-dev libselinux1 tar rsync bc

# locale update
RUN locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8

# adduser vivado
RUN adduser --disabled-password --gecos '' vivado && \
    usermod -aG sudo vivado && \
    echo "vivado ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# create directory /opt/pkg
RUN mkdir -p /opt/pkg && \
    chown vivado /opt/pkg

# create vivado account
USER vivado
ENV HOME /home/vivado
ENV LANG en_US.UTF-8
WORKDIR /home/vivado

# install petalinux
COPY --chown=vivado:vivado accept-eula.sh /home/vivado/accept-eula.sh
COPY --chown=vivado:vivado ${PETALINUX_INSTALLER} /home/vivado/${PETALINUX_INSTALLER}
RUN chmod +x /home/vivado/accept-eula.sh
RUN chmod +x /home/vivado/${PETALINUX_INSTALLER}
RUN /home/vivado/accept-eula.sh /home/vivado/${PETALINUX_INSTALLER} /opt/pkg/petalinux
RUN echo "export TERM=linux" >> /home/vivado/.bashrc
RUN echo "source /opt/pkg/petalinux/settings.sh" >> /home/vivado/.bashrc
RUN rm -rf accept-eula.sh ${PETALINUX_INSTALLER}

# copy Zybo-Z7-10 BSP
#ADD https://github.com/Digilent/Petalinux-Zybo-Z7-10/releases/download/v2017.4-1/Petalinux-Zybo-Z7-10-2017.4-1.bsp /home/vivado
