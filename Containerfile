FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    ffmpeg \
    file \
    g++-mipsel-linux-gnu \
    gcc-mipsel-linux-gnu \
    binutils-mipsel-linux-gnu \
    git \
    git-lfs \
    libavcodec-dev \
    libavfilter-dev \
    libavformat-dev \
    libavutil-dev \
    libswresample-dev \
    libswscale-dev \
    libtinyxml2-dev \
    meson \
    ninja-build \
    pkg-config \
    python3 \
    python3-pil \
    unzip \
    xz-utils \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /work
