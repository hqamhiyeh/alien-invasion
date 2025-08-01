#!/bin/env bash
set -ex

#: ${VENV:?"VENV is not set or is empty"}
: ${PYTHON:?"PYTHON is not set or is empty"}

arch="$1"
python_version="$2"
python_tag="$3"
python_abi_tag="$4"
platform_tag="$5"
recipe_dir="$6"
wheels_dir="$7"
dest_dir="$8"

if [ ! -d "$dest_dir" ]; then
    echo "Error: '$dest_dir' is not a valid directory."
    exit 1
fi

cd $dest_dir

#export PIP_TARGET=./pip_target
#export PIP_DRY_RUN=1
#export PIP_PLATFORM="$platform_tag"_"$arch"
#export PIP_PYTHON_VERSION=$python_version
#export PIP_IMPLEMENTATION=cp
#export PIP_ABI=$python_abi_tag
#export PIP_ONLY_BINARY=:all:
export PIP_FIND_LINKS=$wheels_dir
export PIP_NO_INDEX=1
$PYTHON -m python_appimage build app --python-version $python_version --python-tag "$python_tag"-"$python_abi_tag" --linux-tag "$platform_tag"_"$arch" $recipe_dir
