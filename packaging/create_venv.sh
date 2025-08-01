#!/bin/env bash
set -ex

: ${PYTHON:?"PYTHON is not set or is empty"}

venv_dir="$1"
pyproject_path="$2"
dependency_group="$3"

venv_parent_dir=$(dirname "$venv_dir")
if [ ! -d "$venv_parent_dir" ]; then
    echo "Error: '$venv_parent_dir' is not a valid directory."
    exit 1
fi

$PYTHON -m venv $venv_dir

$venv_dir/bin/pip install --upgrade pip
$venv_dir/bin/pip install --group $pyproject_path:$dependency_group
