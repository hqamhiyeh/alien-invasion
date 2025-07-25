import sys
from os import path
from os import getenv

def _base_resource_path():
    """Resolve base resource path, whether running from source or AppImage."""
    return path.dirname(path.realpath(sys.argv[0]))

def _base_save_path():
    """Resolve base save path, whether running from source or AppImage."""
    if getenv('APPIMAGE'):
        xdg_data_home = getenv('XDG_DATA_HOME',
            path.normpath(path.join(getenv('HOME'), '.local/share')))
        base_path = path.normpath(path.join(xdg_data_home, 'alien_invasion'))
    else:
        base_path = path.dirname(path.realpath(sys.argv[0]))

    return path.normpath(path.join(base_path, 'save'))

BASE_RESOURCE_PATH = _base_resource_path()
BASE_SAVE_PATH = _base_save_path()

def resource_path(relative_path: str) -> str:
    """Resolve resource path."""
    return path.normpath(path.join(BASE_RESOURCE_PATH, relative_path))

def save_path(relative_path: str) -> str:
    """Resolve save path."""
    return path.normpath(path.join(BASE_SAVE_PATH, relative_path))
