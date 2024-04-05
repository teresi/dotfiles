#!/usr/bin/env bash

# add your user to the docker group
# so that you don't need sudo to run docker


_root_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
source $_root_dir/helpers.bash

set -ex

if [ $(getent group docker) ]; then
    notify "docker group exists... OK"
else
    notify "docker group exists... FAIL"
    notify "create docker group..."
    sudo groupadd docker
fi

if getent group docker | grep -qw "$USER"; then
    notify "$USER is in the docker group... OK"
else
    notify "$USER is in the docker group... FAIL"
    notify "adding $USER to docker group..."
    sudo usermod -aG docker $USER
fi

notify "testing docker..."
newgrp docker << END
	docker run hello-world
END

notify "you may need to re-log or run 'newgrp docker' \n\tfor the group membership to take affect"
