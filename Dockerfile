FROM resin/rpi-raspbian:latest
MAINTAINER Shakil Thakur <shakil.thakur@gmail.com>

# this stops the entrypoint from rpi-raspbian?
ENTRYPOINT []

# install things we need
# first line is for ffmpeg, second is for info-beamer
# NOTE: the ffmpeg line is bare minimum to allow conversion of gif to pngs/hw-accel h264
RUN apt-get update && \
    apt-get -qy install autoconf automake build-essential pkg-config texinfo zlib1g-dev curl unzip libomxil-bellagio-dev libraspberrypi0 \
    libevent-2.0.5 libavformat56 libpng12-0 libfreetype6 libavresample2

# get ffmpeg and unzip it
RUN curl -O -L http://ffmpeg.org/releases/ffmpeg-3.3.tar.bz2 && tar -xvjf ffmpeg-3.3.tar.bz2

# try to build and install ffmpeg
RUN cd /ffmpeg-3.3 && ./configure --arch=armel --target-os=linux --enable-gpl --enable-omx --enable-omx-rpi --enable-nonfree && make -j4 && make install

# download and install info-beamer
RUN curl -O -L https://info-beamer.com/jump/download/player/info-beamer-pi-0.9.7-beta.fdb57f-jessie.tar.gz && tar xf info-beamer-pi-0.9.7-beta.fdb57f-jessie.tar.gz && cd info-beamer-pi && mv info-beamer /usr/bin

# re-set my entrypoint?
ENTRYPOINT ["/bin/bash"]

