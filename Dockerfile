# syntax=docker/dockerfile:1

FROM ubuntu:22.04 as base

WORKDIR /root/dotfiles
RUN --mount=type=cache,target=/var/cache/apt \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        build-essential \
        dconf-editor dconf-cli \
        libssl-dev \
        git git-lfs \
        screen \
        libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev \
        curl wget zip unzip \
        vim ranger \
        python3 \
        xsel xclip wmctrl xdotool \
        gconf2 gnome-shell-extensions

RUN git-lfs install

FROM base as test

WORKDIR /root/dotfiles
RUN git clone https://github.com/teresi/dotfiles .
RUN make vim
RUN make all
