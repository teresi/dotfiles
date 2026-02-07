#!/usr/bin/env bash

# bash functions

notify() {
    # info message, green text prepended w/ "INFO  "
    echo -e "\e[32mINFO\t$1 \e[39m"
}

warn() {
    # warning message, yellow text prepended w/ "WARN  "
    echo -e "\e[33mWARN\t$1 \e[39m"
}

error() {
    # error message, red text prepended w/ "ERROR  "
    echo -e "\e[91mERROR\t$1 \e[39m"
}

update_repo_to_master() {
    # clone | fetch | reset to bring a git repo up to date
    #
    #	1	repo url
    #	2	target directory
    #	3	branch or tag (master)
    #
    # NB only call reset if it's not up to date,
    #    so that we can use the .git dir timestamp in Makefile rules,
    #    since the timestamp will change when git reset is called
    # NB do not use --depth, as this will prevent checkouts
    #    from working properly with tags

    notify "updating repository..."
    local _url=$1
    local _dest=$2
    local _branch=$3

    [ -z "$_branch" ] && _branch=master

    notify "    repo directory:  $_dest"
    notify "    repo url:        $_url"
    notify "    repo branch:     $_branch"

    if [ ! -d "$_dest" ]; then notify "cloning $url to $_dest"; fi
    if [ ! -d "$_dest" ]; then # NB not using depth, or cloning the branch directly, b/c it doesn't work well w/ tags
        # it gets into a weird situation where you can't fetch tags, (couldn't find remote ref refs/heads/...)
        # and then you can't checkout that tag b/c it doesn't exist
        git clone --recurse-submodules $_url $_dest &&
            git -C $_dest fetch origin --tags --force &&
            git -C $_dest checkout $_branch &&
            git -C $_dest submodule update --init --recursive
    fi
    # NB `git status` updates the .git folder for some reason,
    #    so don't call it here or else it will update even if there are no changes!

    notify "    fetching..."
    # fetch, checkout, reset if necessary
    # set the origin for the branch in case a shallow clone was used
    # fetch the branch specifically in case a shallow clone was used
    # fetch the tags in case new tags have been added
    git -C $_dest fetch --tags origin $_branch

    notify "    checking if branch $_branch is up to date..."
    _local=$(git -C $_dest rev-list -n 1 HEAD)
    # use ls-remote b/c we need to handle tags AND branches
    # TODO may need to use {branch}^{} for tags, else they point to the wrong commit
    _remote=$(git -C $_dest ls-remote origin refs/heads/${_branch} | cut -f1)
    if [ -z "$_remote" ]; then
        # dereference b/c we need the OID of the commit associated w/ the tag, not the object ID of the tag itself
        _remote=$(git -C $_dest rev-parse refs/tags/${_branch}^{})
    fi
    if [ -z "$_remote" ]; then
        warn "could not find commit for branch/tag: ${_branch} at ${_dest}"
    fi
    notify "    local commit is at  $_local"
    notify "    remote commit is at $_remote"
    if [ "${_local}" != "${_remote}" ]; then
        warn "    checking if branch $_branch is up to date... NO"
        git -C $_dest remote set-branches origin ${_branch}
        git -C $_dest fetch origin $_branch
        git -C $_dest fetch origin --tags --force || true
        git -C $_dest checkout $_branch
        git -C $_dest submodule update --init --recursive
        if [ "$?" != "0" ]; then
            error "failed to checkout branch $_branch for repo $_dest"
            return 1
        fi
        notify "    resetting ${_branch} to ${_remote}"
        git -C ${_dest} reset --hard ${_remote}
    else
        notify "    checking if branch $_branch is up to date... YES"
    fi
    echo ""
}

are_packages_missing() {
    # print warning if any package in array $1 is not installed

    local _pkgs=("$@")
    local _missing=()

    for pkg in ${_pkgs[@]}; do
        dpkg -s $pkg 2>/dev/null | grep -q "install ok installed" || _missing+=("$pkg")
    done
    if [ ${#_missing[@]} -eq 0 ]; then
        return 0
    fi

    error "you are missing packages!"
    error "    some targets may not succeed,"
    error "    or some important programs might be missing"
    error "please install:"
    echo ""
    echo "  ${_missing[@]}"
    echo ""
    sleep 4
    return 1
}

are_packages_missing_warn() {
    # print warning if any package in array $1 is not installed

    local _pkgs=("$@")
    local _missing=()

    for pkg in ${_pkgs[@]}; do
        dpkg -s $pkg 2>/dev/null | grep -q "install ok installed" || _missing+=("$pkg")
    done
    if [ ${#_missing[@]} -eq 0 ]; then
        return 0
    fi

    warn "missing package, the following is recommended:"
    echo ""
    echo "  ${_missing[@]}"
    echo ""
    sleep 4
    return 1
}
