# syntax=docker/dockerfile:1
FROM debian:bullseye-slim AS base

# Install dependencies for building and running GPAC
# The following packages will be included in both the builder and the final image.
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    dvb-apps \
    liba52-0.7.4-dev \
    libasound2-dev \
    libavcodec-dev \
    libavdevice-dev \
    libavformat-dev \
    libavutil-dev \
    libfaad-dev \
    libfreetype6-dev \
    libgl1-mesa-dev \
    libjack-dev \
    libjpeg62-turbo-dev \
    libmad0-dev \
    libogg-dev \
    libpng-dev \
    libpulse-dev \
    libsdl2-dev \
    libssl-dev \
    libswscale-dev \
    libtheora-dev \
    libvorbis-dev \
    libxv-dev \
    libxvidcore-dev \
    mesa-utils \
    x11proto-gl-dev \
    x11proto-video-dev \
    zlib1g-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


FROM base AS builder
# Keep downloaded packages in the image cache
RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
# Install dependencies for building and packaging GPAC
# The following packages will only be included in the builder image.
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked\
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    DEBIAN_FRONTEND=noninteractive apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential pkg-config g++ git scons cmake yasm \
    fakeroot dpkg-dev devscripts debhelper ccache
# (No need to clean up, this is only a build image)

WORKDIR /build
# Clone repos, making sure to use the cache if the latest commit is the same
ADD "https://api.github.com/repos/gpac/deps_unix/commits?per_page=1" latest_deps_commit.json
RUN git clone https://github.com/gpac/deps_unix && \
    cd deps_unix && \
    git submodule update --init --recursive --force --checkout

ADD "https://api.github.com/repos/gpac/gpac/commits?per_page=1" latest_gpac_commit.json
RUN git clone https://github.com/gpac/gpac.git gpac_public

# Build dependencies
WORKDIR /build/deps_unix
RUN ./build_all.sh linux

# Build GPAC and create a deb package
WORKDIR /build/gpac_public
RUN ./configure
RUN make
RUN make deb

# Create a new image with only the built packages and the runtime dependencies
FROM base AS runtime
ENTRYPOINT [ "gpac" ]
CMD [ "-h" ]
# Install Debs
RUN --mount=type=bind,from=builder,src=/build,target=/build \
    dpkg -i /build/gpac_public/gpac_*.deb /build/gpac_public/libgpac*.deb
