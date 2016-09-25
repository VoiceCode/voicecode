#!/bin/bash
./node_modules/.bin/electron-rebuild -v 0.37.8 -n 47 -m ./app/node_modules
cd app/node_modules/fibers &&
HOME=~/.electron-gyp node-gyp rebuild --target=0.37.8 --arch=x64 --dist-url=https://atom.io/download/atom-shell &&
mkdir ./bin/darwin-x64-v8-4.9/ &&
mv build/Release/fibers.node bin/darwin-x64-v8-4.9/
