#!/usr/bin/env bash

# Minimum required Python version
: ${MIN_PYTHON_VERSION:?"MIN_PYTHON_VERSION is not set or is empty"}

# Try to find python3 using env (cross-platform)
PYTHON=$(command -v python3 || env python3)

# If not found, try to check on Windows using 'where'
if [ -z "$PYTHON" ] && (uname -s | grep -i "cygwin\|mingw\|msys" > /dev/null); then
    PYTHON=$(where python) # Windows installation default is 'python'
fi

# Ensure python is found
if [ -z "$PYTHON" ]; then
    echo "Error: Python not found!" >&2
    exit 1
fi

# Verify it's at least the minimum version required
PYTHON_VERSION=$($PYTHON --version 2>&1)
if [[ "$PYTHON_VERSION" =~ Python\ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
    INSTALLED_MAJOR="${BASH_REMATCH[1]}"
    INSTALLED_MINOR="${BASH_REMATCH[2]}"
    INSTALLED_PATCH="${BASH_REMATCH[3]}"
    INSTALLED_VERSION="$INSTALLED_MAJOR.$INSTALLED_MINOR.$INSTALLED_PATCH"

    # Handle cases where MIN_PYTHON_VERSION is just major (like "3") or major.minor (like "3.13")
    MINIMUM_VERSION="$MIN_PYTHON_VERSION"

    # If MINIMUM_VERSION is just the major number (like "3"), append ".0.0"
    if [[ "$MINIMUM_VERSION" =~ ^([0-9]+)$ ]]; then
        MINIMUM_VERSION="$MINIMUM_VERSION.0.0"  # Add minor and patch parts (e.g., "3" becomes "3.0.0")
    # If MINIMUM_VERSION is major.minor (like "3.13"), add a patch version of ".0"
    elif [[ "$MINIMUM_VERSION" =~ ^([0-9]+)\.([0-9]+)$ ]]; then
        MINIMUM_VERSION="$MINIMUM_VERSION.0"  # Add patch version if missing (e.g., "3.13" becomes "3.13.0")
    fi

    # Compare the installed version with the minimum version
    if [[ "$(echo -e "$MINIMUM_VERSION\n$INSTALLED_VERSION" | sort -V | head -n1)" != "$MINIMUM_VERSION" ]]; then
        echo "Error: Python $INSTALLED_VERSION is installed, but version $MINIMUM_VERSION or higher is required!" >&2
        exit 1
    fi
else
    echo "Error: Found $PYTHON, but the version string is in an unexpected format." >&2
    exit 1
fi

# Output the path
echo $PYTHON
