FROM ubuntu:18.04

LABEL \
  gcc_arm.version=6.3 \
  gcc_arm.release=2017-q2 \
  nrf5_sdk.version=15.2.0

RUN apt-get update && apt-get install -y \
    wget \
    python-minimal \
    python-pip \
    unzip \
    dos2unix \
    git \
    build-essential \
    && apt-get purge

WORKDIR /opt

RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 | tar -xjf -

ENV \
  PATH="/opt/gcc-arm-none-eabi-6-2017-q2-update/bin/:${PATH}" \
  GNU_INSTALL_ROOT=/opt/gcc-arm-none-eabi-6-2017-q2-update/bin/ \
  GNU_VERSION=6.3 \
  GNU_PREFIX=arm-none-eabi

RUN wget -q https://www.nordicsemi.com/eng/nordic/download_resource/59011/94/79796501/116085 -O nRF5_SDK.zip && \
  unzip -q nRF5_SDK.zip && \
  rm nRF5_SDK.zip

WORKDIR /opt/nRF5_SDK_15.2.0_9412b96/external/micro-ecc

RUN dos2unix build_all.sh && \
    chmod +x build_all.sh && \
    ./build_all.sh

ENV SDK_ROOT=/opt/nRF5_SDK_15.2.0_9412b96

RUN pip install nrfutil

WORKDIR /opt


