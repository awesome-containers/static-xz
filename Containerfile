# https://github.com/awesome-containers/static-bash
ARG STATIC_BASH_VERSION=5.2.15
ARG STATIC_BASH_IMAGE=ghcr.io/awesome-containers/static-bash

# https://github.com/awesome-containers/alpine-build-essential
ARG BUILD_ESSENTIAL_VERSION=3.17
ARG BUILD_ESSENTIAL_IMAGE=ghcr.io/awesome-containers/alpine-build-essential


FROM $STATIC_BASH_IMAGE:$STATIC_BASH_VERSION AS static-bash
FROM $BUILD_ESSENTIAL_IMAGE:$BUILD_ESSENTIAL_VERSION AS build

# hadolint ignore=DL3018
RUN apk add --no-cache clang

# https://tukaani.org/xz/
ARG XZ_VERSION=5.4.1

WORKDIR /src/xz
RUN set -xeu; \
    curl -#Lo xz.tar.xz \
        "https://tukaani.org/xz/xz-$XZ_VERSION.tar.xz"; \
    tar -xvf xz.tar.xz --strip-components=1; \
    rm -f xz.tar.xz

ARG CC=clang
ARG LDFLAGS="-static -all-static"
ARG PKG_CONFIG="pkg-config --static"
ARG CFLAGS='-w -g -Os -static'

RUN set -xeu; \
    ./configure --prefix=/src/xz/dist \
        --disable-debug --disable-dependency-tracking \
        --disable-silent-rules --disable-shared --disable-nls; \
    make -j"$(nproc)" install

WORKDIR /src/xz/dist/bin
# hadolint ignore=SC2044,DL4006
RUN set -xeu; \
    for bin in $(find ./ -executable -type f); do \
        file "$bin" -b --mime-type | grep -qw 'application/x-executable' || \
            continue; \
        ! ldd "$bin" && :; \
        strip -s -R .comment --strip-unneeded "$bin"; \
    done; \
    chmod -cR 755 ./*; \
    chown -cR 0:0 ./*; \
    ./xz --version; \
    ln -s bash sh

# static xz image
FROM static-bash
COPY --from=build /src/xz/dist/bin/ /bin/
