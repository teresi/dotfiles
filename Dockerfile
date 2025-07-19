# syntax=docker/dockerfile:1

FROM ubuntu:22.04 as base


# NB installing cmake b/c it takes a lot time to compile
#    remove if it needs testing here
WORKDIR /root/dotfiles
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
    && apt-get update -y \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg \
        build-essential \
        libreadline-dev \
        libssl-dev \
        screen \
        dconf-editor dconf-cli \
        git git-lfs \
        libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev \
        libx11-dev libxmu-dev \
        llvm clang \
        curl wget zip unzip \
        vim ranger \
        python3 \
        xsel xclip wmctrl xdotool \
        gconf2 gnome-shell-extensions\
        rxvt-unicode

RUN git-lfs install

WORKDIR /root/dotfiles

RUN git clone https://github.com/teresi/dotfiles .

FROM base as test
RUN make all
