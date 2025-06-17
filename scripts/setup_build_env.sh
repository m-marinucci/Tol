#!/bin/bash
set -e

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root. Please run with sudo or as root user." 1>&2
  exit 1
fi

# Update package list and install build dependencies for TOL
apt-get update
apt-get install -y \
  autoconf automake libtool make cmake build-essential pkg-config \
  libgsl0-dev libfftw3-dev libatlas-base-dev libsuitesparse-dev \
  liblapack-dev libboost-all-dev libpoco-dev tcl-dev tk-dev
