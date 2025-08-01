#!/bin/env bash
set -ex

: ${PIP:?"PIP is not set or is empty"}

arch="$1"
python_version="$2"
python_implementation="$3"
python_abi="$4"
platform_tag="$5"
wheels_dir="$6"
source_dir="$7"

wheels_parent_dir=$(dirname "$wheels_dir")
if [ ! -d "$wheels_parent_dir" ]; then
    echo "Error: '$wheels_parent_dir' is not a valid directory."
    exit 1
fi

$PIP wheel --no-deps -w $wheels_dir $source_dir
$PIP download --only-binary :all: --python-version $python_version --implementation $python_implementation --abi $python_abi --platform "$platform_tag"_"$arch" --dest $wheels_dir $source_dir
