FROM gcc:8.1

LABEL \
  gcc.version=6.3 \
  gcc.release=2017-q2 \
  nrf5sdk.version=15.0.0 \
  jlink.version=6.22g

RUN apt-get update && apt-get install -y \
  unzip \
  vim \
  python2.7 \
  && apt-get purge

WORKDIR /usr/local
RUN wget https://bootstrap.pypa.io/get-pip.py && python2.7 get-pip.py
RUN wget -qO- https://developer.arm.com/-/media/Files/downloads/gnu-rm/6-2017q2/gcc-arm-none-eabi-6-2017-q2-update-linux.tar.bz2 | tar -xjf -

# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF5-SDK
WORKDIR /nordic/
RUN wget -qO nRF5-SDK.zip https://www.nordicsemi.com/eng/nordic/download_resource/59011/71/77279059/116085 && \
  unzip nRF5-SDK.zip && \
  rm nRF5-SDK.zip

# Include the Nordic Command Line Tools
# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF52832/nRF5x-Command-Line-Tools-Linux64
RUN wget -qO- https://www.nordicsemi.com/eng/nordic/download_resource/51388/29/43703846/94917 | tar -xf -

# https://www.nordicsemi.com/eng/Products/Bluetooth-low-energy/nRF5-SDK-for-HomeKit
# The nRF5 SDK for HomeKit is available to MFI licensees only

# Download Segger JLink
WORKDIR /segger/
RUN wget -qO- https://www.segger.com/downloads/jlink/JLink_Linux_V622g_x86_64.tgz --post-data='submit=1&accept_license_agreement=accepted' | tar -xzf -

# Setting up the development kit for nRF52832
# https://infocenter.nordicsemi.com/index.jsp?topic=%2Fcom.nordic.infocenter.nrf52%2Fdita%2Fnrf52%2Fdevelopment%2Fsetting_up_new.html
# https://gustavovelascoh.wordpress.com/2017/01/23/starting-development-with-nordic-nrf5x-and-gcc-on-linux/
COPY Makefile.posix /nordic/nRF5_SDK_15.0.0_a53641a/components/toolchain/gcc/Makefile.posix

# Include python utilities
RUN pip install nrfutil pc-ble-driver-py

ENV \
  PATH="/usr/local/gcc-arm-none-eabi-6-2017-q2-update/bin/:/nordic/nrfjprog:/nordic/mergehex:/segger/JLink_Linux_V622g_x86_64:${PATH}" \
  SDK_ROOT="/nordic/nRF5_SDK_15.0.0_a53641a" \
  LD_LIBRARY_PATH="/nordic/nrfjprog:/nordic/mergehex:${LD_LIBRARY_PATH}"

WORKDIR /build
