FROM nvidia/cuda:10.0-cudnn7-devel

ENV DEBIAN_FRONTEND noninteractive
ENV NVIDIA_VISIBLE_DEVICES all
ENV NVIDIA_DRIVER_CAPABILITIES video,compute,utility
ENV CMAKE_VER="3.13.4"

# Install required Packages

RUN set -xe && \
    apt-get update && \
    apt-get install -y \
    	    git sudo wget \
	    qtbase5-dev \
	    build-essential \
	    gdebi \
	    libopencv-dev

# Build & Install CMake

WORKDIR /usr/local
RUN set -xe && \
    wget -O /tmp/cmake.tar.gz https://github.com/Kitware/CMake/releases/download/v${CMAKE_VER}/cmake-${CMAKE_VER}.tar.gz && \
    mkdir -p /usr/local/cmake && tar xzvf /tmp/cmake.tar.gz -C /usr/local/cmake --strip-components 1 && \
    cd /usr/local/cmake && \
    ./configure --qt-gui && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install

# Build OpenPose

WORKDIR /usr/local
RUN set -xe && \
    git clone https://github.com/CMU-Perceptual-Computing-Lab/openpose && \
    cd /usr/local/openpose && \
    bash ./scripts/ubuntu/install_deps.sh && \
    mkdir -p /usr/local/openpose/build && \
    cd /usr/local/openpose/build && \
    cmake .. && \
    make -j${nproc} && \
    make install

# Cleanup

WORKDIR /usr/local
RUN set -xe && \
    apt-get clean && \
    rm -rf /tmp/cmake.tar.gz && \
    ln -s /usr/local/openpose/build/examples/openpose/openpose.bin /usr/local/bin/openpose.bin

ENTRYPOINT ["/usr/local/bin/openpose.bin"]
CMD ["--help"]

