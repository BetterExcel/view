FROM ubuntu:latest

RUN apt update 
RUN apt upgrade -y
RUN apt install -y dialog
RUN apt install -y \
    libpoco-dev \
    python3-polib \
    libcap-dev npm \
    libpam-dev \
    libzstd-dev \
    wget \
    git \
    build-essential \
    libtool \
    libcap2-bin \
    python3-lxml \
    libpng-dev \
    libgif-dev \
    libcppunit-dev \
    pkg-config \
    fontconfig \
    snapd \
    chromium-browser

RUN wget https://github.com/CollaboraOnline/online/releases/download/for-code-assets/core-co-25.04-assets.tar.gz
RUN tar xvf core-co-25.04-assets.tar.gz

RUN export LOCOREPATH=$(pwd)

COPY . .

RUN ./autogen.sh
RUN ./configure --enable-silent-rules --with-lokit-path=${LOCOREPATH}/include \
    --with-lo-path=${LOCOREPATH}/instdir \
    --enable-debug --enable-cypress

RUN make -j $(nproc)
RUN make run
