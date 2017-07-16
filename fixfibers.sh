#!/bin/bash
./node_modules/.bin/electron-rebuild -f -v 1.6.7 -n 53 -p -m ./app/node_modules
cd app/node_modules/fibers
HOME=~/.electron-gyp node-gyp rebuild --target=1.6.7 --arch=x64 --dist-url=https://atom.io/download/atom-shell
mkdir ./bin/darwin-x64-53/
mv build/Release/fibers.node bin/darwin-x64-53/
cd ../robotjs
HOME=~/.electron-gyp node-gyp rebuild --target=1.4.3 --arch=x64 --dist-url=https://atom.io/download/atom-shell
