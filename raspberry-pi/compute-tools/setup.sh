#!/bin/bash

set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get upgrade -y
cat "${DIR}/requirements.txt" | xargs sudo apt-get install -y

ansible-playbook "${DIR}/setup.yaml"
