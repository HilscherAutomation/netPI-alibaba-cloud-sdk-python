#use latest armv7hf compatible raspbian OS version from group resin.io as base image
FROM balenalib/armv7hf-debian:stretch

#enable building ARM container on x86 machinery on the web (comment out next line if built on Raspberry)
RUN [ "cross-build-start" ]

#labeling
LABEL maintainer="netpi@hilscher.com" \
      version="V1.0.0" \
      description="Alibaba Cloud SDK Python"

#version
ENV HILSCHERNETPI_ALIBABA_CLOUD_SDK_PYTHON 1.0.0

#copy files
COPY "./init.d/*" /etc/init.d/

RUN apt-get update \
    && apt-get install -y openssh-server \
    && echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd \
    && mkdir /var/run/sshd \
    && apt-get install apt-transport-https lsb-release build-essential libssl-dev libffi-dev python-dev python-pip git nano wget

#install Python Cloud SDK
RUN pip install --upgrade pip==9.0.3 \
    && pip install --upgrade setuptools \
    && pip install aliyun-python-sdk-core \
    && pip install aliyun-python-sdk-iot

#remove package lists
RUN rm -rf /var/lib/apt/lists/*

#set the entrypoint
ENTRYPOINT ["/etc/init.d/entrypoint.sh"]

#SSH port
EXPOSE 22

#set STOPSGINAL
STOPSIGNAL SIGTERM

#stop processing ARM emulation (comment out next line if built on Raspberry)
RUN [ "cross-build-end" ]
