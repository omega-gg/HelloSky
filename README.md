HelloSky
---
[![azure](https://dev.azure.com/bunjee/HelloSky/_apis/build/status/omega-gg.HelloSky)](https://dev.azure.com/bunjee/HelloSky/_build)
[![GPLv3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl.html)

[HelloSky](http://omega.gg/HelloSky) is a "Hello World" application built for Sky kit.<br>

## Technology

HelloSky is built in C++ with [Sky kit](http://omega.gg/Sky/sources).<br>

## Platforms

- Windows XP and later.
- macOS 64 bit.
- Linux 32 bit and 64 bit.
- Android 32 bit and 64 bit (experimental).

## Requirements

- [Sky](http://omega.gg/Sky/sources) latest version.
- [Qt](http://download.qt.io/official_releases/qt) 4.8.0 / 5.5.0 or later.
- [OpenSSL](http://www.openssl.org/source) / [Win32OpenSSL](http://slproweb.com/products/Win32OpenSSL.html) 1.0.1 or later.

On Windows:
- [MinGW](http://sourceforge.net/projects/mingw) or [Git for Windows](http://git-for-windows.github.io) with g++ 4.9.2 or later.

Recommended:
- [Qt Creator](http://download.qt.io/official_releases/qtcreator) 3.6.0 or later.

## Install

You can install third party libraries with:

    sh 3rdparty.sh <win32 | win64 | macOS | linux | android>

## Configure

You can configure HelloSky with:

    sh configure.sh <qt4 | qt5 | clean> <win32 | win64 | macOS | linux | android>

## Build

You can build HelloSky with Qt Creator:
- Open [HelloSky.pro](HelloSky.pro).
- Click on "Build > Build all".

Or the build script:

    sh build.sh <qt4 | qt5 | clean> <win32 | win64 | macOS | linux> [deploy]

Or the console:

    qmake -r
    make (mingw32-make on Windows)

## Deploy

1\. Generate the qrc file:

    cd dist
    sh qrc.sh <qt4 | qt5 | clean> <win32 | win64 | macOS | linux> [deploy]

2\. Build HelloSky:

    qmake -r "DEFINES += SK_DEPLOY" "RESOURCES = dist/HelloSky.qrc"
    make (mingw32-make on Windows)

3\. Deploy HelloSky:

    sh deploy.sh <qt4 | qt5 | clean> <win32 | win64 | macOS | linux>

## License

Copyright (C) 2015 - 2017 HelloSky authors united with [omega](http://omega.gg/about).

### Authors

- Benjamin Arnaud aka [bunjee](http://bunjee.me) | <bunjee@omega.gg>

### GNU General Public License Usage

HelloSky may be used under the terms of the GNU General Public License version 3 as published
by the Free Software Foundation and appearing in the LICENSE.md file included in the packaging
of this file. Please review the following information to ensure the GNU General Public License
requirements will be met: https://www.gnu.org/licenses/gpl.html.
