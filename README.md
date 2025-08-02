<div align="center">
    <a href="https://github.com/hqamhiyeh/alien-invasion">
        <img src="alien_invasion/images/ship.bmp" alt="Logo" width="80" height="80">
    </a>
    <h3 align="center">Alien Invasion</h3>
    <p align="center">
        A simple shmup game developed in Python with Pygame-ce.
        <br />
    </p>
</div>

## About the game

Aliens are invading! Shoot down alien ships to destroy their fleet. For every alien fleet you clear, the game speeds up and increases in difficulty. Survive for as long as you can and rack up points for a high score.

<p float="left">
  <img src="alien_invasion/images/alien_invasion.gif" width="600" />
</p>

#### Controls

`P` &nbsp; Play &nbsp;&nbsp;&nbsp;&nbsp; `Q` &nbsp; Quit

`←` &nbsp; Left &nbsp;&nbsp;&nbsp;&nbsp; `→` &nbsp; Right &nbsp;&nbsp;&nbsp;&nbsp; `Spacebar` &nbsp; Shoot

## How can I play it?

An AppImage is available for linux systems on x86-64. It can be downloaded from the [releases](https://github.com/hqamhiyeh/alien-invasion/releases) page.

Otherwise, the game can be played by downloading the latest release source and running it with Python.

### Playing the game from source

To play the game from source, you will need Python installed on your system.

#### 1. Download the latest release source code

The latest release source code can be downloaded from the [Releases](https://github.com/hqamhiyeh/alien-invasion/releases) page.

- Under **Assets**, click on the source code file to download it. This will be a `.tar.gz` or `.zip` file depending your preference.

- Once downloaded, extract it to your desired location.

#### 2. Set up a Virtual Environment

It's good practice to use a virtual environment to isolate your dependencies from the global Python environment. Here's how you can set it up:

1. In a terminal, navigate to the extracted source code folder.

2. Create a virtual environment:

    - On **Linux**/**Mac**: `python3 -m venv venv`

    - On **Windows**: `python -m venv venv`

3. Activate the virtual environment:

    - On **Linux**/**Mac**: `source venv/bin/activate`

    - On **Windows**: `.\venv\Scripts\activate`

When activated, you'll see the environment name (`venv`) appear in your terminal prompt, indicating that you're working inside the virutal environment.

#### 3. Install dependencies

Once your virtual environment is set up and activated, you'll need to install the required dependencies for the game. Run the following command to install them:

`pip install .`

#### 4. Run the game

Once your dependencies are installed, you can run the game using the following command:

`python alien_invasion/alien_invasion.py`

## Developers' corner

### Building and packaging the game as an AppImage

This project demonstrates how to package a simple Python game along with a Python interpreter into an AppImage with [python-appimage](https://github.com/niess/python-appimage).

The [AppImage](https://github.com/AppImage/AppImageKit) format provides an easy-to-use and highly compatible distribution for end users across different Linux systems.

To ensure that the AppImage is portable, I set up the build process to target a 'manylinux' platform tag, as described in [PEP 513](https://peps.python.org/pep-0513/).

In this project, the Makefile and build scripts automate the entire build and package process. From creating the necessary environment to bundling the game and its dependencies, everything can be done with a simple make command.

This setup provides an easy, reproducible way to distribute Python games and applications, and serves as a good example of how to bundle and distribute Python projects in a highly portable format.

Feel free to explore the Makefile and build scripts to learn how to integrate similar packaging into your own Python projects!

## Attributions

### Art

- [Purple Space Ship](https://opengameart.org/content/purple-space-ship)
- Created by: [Tummyache](https://opengameart.org/users/tummyache)
- License: [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)

### Sound Effects

- [Sci-Fi SFX](https://opengameart.org/content/50-cc0-sci-fi-sfx)
- Created by: [rubberduck](https://opengameart.org/users/rubberduck)
- License: [CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/)
