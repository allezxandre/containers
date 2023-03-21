FROM ubuntu:22.04

LABEL org.opencontainers.image.title="gpac"
LABEL org.opencontainers.image.description="Ubuntu LTS with a full gpac install"
LABEL org.opencontainers.image.authors="alexandre@jouandin.eu"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential pkg-config g++ git scons cmake yasm \
    zlib1g-dev libfreetype6-dev libjpeg62-dev libpng-dev libmad0-dev libfaad-dev libogg-dev libvorbis-dev libtheora-dev liba52-0.7.4-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavdevice-dev libxv-dev x11proto-video-dev libgl1-mesa-dev x11proto-gl-dev libxvidcore-dev libssl-dev libjack-dev libasound2-dev libpulse-dev libsdl2-dev dvb-apps mesa-utils &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Clone repos, making sure to use the cache if the latest commit is the same
ADD "https://api.github.com/repos/gpac/deps_unix/commits?per_page=1" latest_deps_commit
RUN git clone https://github.com/gpac/deps_unix && \
    cd deps_unix && \
    git submodule update --init --recursive --force --checkout

ADD "https://api.github.com/repos/gpac/gpac/commits?per_page=1" latest_gpac_commit
RUN git clone https://github.com/gpac/gpac.git gpac_public

# Build and install
RUN cd deps_unix && \
    ./build_all.sh linux
RUN cd gpac_public && \
    ./configure && \
    make && \
    make install

ENTRYPOINT [ "gpac" ]