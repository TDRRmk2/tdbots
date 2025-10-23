# TDBots
TDBots is a custom bot mod for Zandronum and Q-Zandronum. It supports many interesting features over the native bots such as:
* Waypoints
* Better scripting capabilities (per-weapon parameters and custom scripts)
* Crouching, reloading, and so on
* Better navigation with and without waypoints

# Building
The TDBots require the following tools to compile:
* Lua
* Latest zt-bcc
* GNU M4 macro processor
* BotC (included)

Go into the BotSource folder and use `lua build.lua` on POSIX platforms or `build.bat` on Windows.
The build script supports passing arguments to it, which are interpreted as defines for zt-bcc and m4.
Currently available defines are:
* `QZANDRONUM`: Enables the use of Q-Zandronum exclusive features (used in `build_qzan.bat`).
* `DEBUG_MODE`: Enables debug logging.

Windows users, please remember to fill out the environment variables in `build.bat`/`build_qzan.bat` so the build script knows where to find the programs. Lua must be in system `PATH` to work.
