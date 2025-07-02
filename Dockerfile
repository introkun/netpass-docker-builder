FROM devkitpro/devkitarm
LABEL version="0.1.0"
LABEL maintainer="introkun"
LABEL org.opencontainers.image.licenses="GPL-3.0"
LABEL org.opencontainers.image.source="https://github.com/introkun/netpass-docker-builder"

WORKDIR /build

# Install Python, ffmpeg, and other needed tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 \
        python3-pip \
        ffmpeg \
        wget \
        unzip \
        ca-certificates \
    && pip3 install PyYAML --break-system-packages \
    && rm -rf /var/lib/apt/lists/*

# Link python3 to python (optional)
RUN ln -s $(which python3) /usr/bin/python

# Install makerom
RUN wget https://github.com/3DSGuy/Project_CTR/releases/download/makerom-v0.18.4/makerom-v0.18.4-ubuntu_x86_64.zip && \
    unzip makerom-v0.18.4-ubuntu_x86_64.zip -d /opt/devkitpro/tools/bin/ && \
    chmod +x /opt/devkitpro/tools/bin/makerom && \
    rm makerom-v0.18.4-ubuntu_x86_64.zip

# Install bannertool
RUN wget https://github.com/diasurgical/bannertool/releases/download/1.2.0/bannertool.zip && \
    unzip bannertool.zip && \
    cp ./linux-x86_64/bannertool /opt/devkitpro/tools/bin/ && \
    chmod +x /opt/devkitpro/tools/bin/bannertool && \
    rm -rf bannertool.zip linux-x86_64

# Add your entrypoint script
COPY ./docker-entrypoint.sh ./
RUN chmod +x /build/docker-entrypoint.sh

# Set working directory to source
WORKDIR /build/source

ENTRYPOINT ["/build/docker-entrypoint.sh"]
