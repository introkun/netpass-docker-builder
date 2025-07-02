FROM debian:12-slim
LABEL version="0.2.4-alpha"
LABEL vendor1="DanteyPL"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.source="https://github.com/introkun/netpass-docker-builder"
LABEL org.opencontainers.image.version="0.2.4-alpha-fork1"
LABEL vendor2="introkun"

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /build

# Install apt dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget unzip && \
    rm -rf /var/lib/apt/lists/*

# Install devkitpro pacman
RUN wget https://apt.devkitpro.org/install-devkitpro-pacman && \
    chmod +x ./install-devkitpro-pacman && \
    sed -i -e 's/apt-get install/apt-get install -y/' ./install-devkitpro-pacman && \
    ./install-devkitpro-pacman && \
    ln -s /proc/self/mounts /etc/mtab

# Install SDK and tools
RUN dkp-pacman --noconfirm -S 3ds-dev 3ds-curl 3ds-libvorbisidec 3ds-opusfile 3ds-pkg-config && \
    dkp-pacman -Scc --noconfirm

# Set environment
ENV DEVKITPRO=/opt/devkitpro \
    DEVKITARM=/opt/devkitpro/devkitARM \
    PATH="$PATH:/opt/devkitpro/devkitARM/bin"

# Install dev dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg git python3 python3-pip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python package
RUN pip install PyYAML --break-system-packages

# Link python
RUN ln -s $(which python3) /usr/bin/python

# Download & install makerom
RUN wget https://github.com/3DSGuy/Project_CTR/releases/download/makerom-v0.18.4/makerom-v0.18.4-ubuntu_x86_64.zip && \
    unzip makerom-v0.18.4-ubuntu_x86_64.zip -d $DEVKITPRO/tools/bin/ && \
    chmod +x $DEVKITPRO/tools/bin/makerom && \
    rm makerom-v0.18.4-ubuntu_x86_64.zip

# Download & install bannertool
RUN wget https://github.com/diasurgical/bannertool/releases/download/1.2.0/bannertool.zip && \
    unzip bannertool.zip -d ./ && \
    cp ./linux-x86_64/bannertool $DEVKITPRO/tools/bin/ && \
    rm bannertool.zip

COPY ./docker-entrypoint.sh ./
RUN chmod +x /build/docker-entrypoint.sh

WORKDIR /build/source
ENTRYPOINT ["/build/docker-entrypoint.sh"]
