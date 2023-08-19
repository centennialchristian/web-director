#!/bin/bash

if which apt 2>/dev/null; then
  apt -y update
  apt -y install podman podman-compose
elif which dnf 2>/dev/null; then
  dnf -y install epel-release
  dnf clean all
  dnf makecache
  dnf -y podman podman-compose
elif which yum 2>/dev/null; then
  yum -y install epel-release
  yum clean all
  yum makecache
  yum -y podman podman-compose
else
  echo "Could not determine package manager" >&2
  exit 1
fi

