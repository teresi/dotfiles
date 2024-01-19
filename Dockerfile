# syntax=docker/dockerfile:1

FROM ubuntu:22.04 as base

RUN --mount=type=cache,target=/var/cache/apt \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        git git-lfs \
        curl wget zip unzip \
        build-essential cmake \
        tmux vim ranger \
        python3 \
        gconf2 gnome-shell-extensions

RUN git-lfs install

WORKDIR /root/dotfiles

FROM base as test

COPY * .
RUN make vim
RUN make all
