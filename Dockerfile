FROM ubuntu:24.04

WORKDIR /app

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Toronto
ENV LOCOREPATH=$PWD/app
ENV COOL_SERVE_FROM_FS=1

RUN apt-get update && apt-get -y upgrade && \
    apt-get install -y --no-install-recommends curl && \
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y --no-install-recommends \
    wget \
    git \
    build-essential \
    libtool \
    automake \
    pkg-config \
    perl \
    nodejs \
    cpio \
    ca-certificates \
    tzdata \
    libpoco-dev \
    python3-polib \
    libcap-dev \
    libpam-dev \
    libzstd-dev \
    libcap2-bin \
    python3-lxml \
    libpng-dev \
    libgif-dev \
    libcppunit-dev \
    fontconfig \
    chromium-browser \
    fonts-montserrat \
    npm && \
    npm cache clean -f && \
    npm install -g n && \
    n 18.17.1 && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/CollaboraOnline/online/releases/download/for-code-assets/core-co-25.04-assets.tar.gz && \
    tar xvf core-co-25.04-assets.tar.gz && \
    rm core-co-25.04-assets.tar.gz

COPY . .

RUN groupadd -r -g 1001 cool && \
    useradd -m -r -u 1001 -g 1001 cool && \
    chown -R cool:cool /app

USER cool

RUN ./autogen.sh
RUN ./configure --enable-silent-rules --with-lokit-path=${LOCOREPATH}/include \
    --with-lo-path=${LOCOREPATH}/instdir \
    --enable-debug --enable-cypress
RUN make -j$(nproc)
EXPOSE 9980

CMD ["make", "run"]
