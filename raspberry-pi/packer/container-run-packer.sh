#!/bin/bash

mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc
packer "$@"
