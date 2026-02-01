# syntax=docker/dockerfile:1

# test dotfiles

FROM ubuntu:22.04 as base

WORKDIR /root/dotfiles
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        make \
        git \
        curl \
        wget \
        gcc \
        g++ \
        gpg

# not strictly necessary but they take a long time to compile
# remove if testing those packages
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get install -y --no-install-recommends \
        clang \
        cmake

RUN git-lfs install

WORKDIR /root/dotfiles

RUN git clone https://github.com/teresi/dotfiles .

FROM base as test
RUN make all
