.\node_modules\.bin\electron-rebuild -f -v 1.4.4 -n 50 -p -m .\app\node_modules
cd app\node_modules\fibers
HOME=C:\.electron-gyp node-gyp rebuild --target=1.4.4 --arch=x64 --dist-url=https:\\atom.io\download\atom-shell
mkdir .\bin\darwin-x64-50\
move build\Release\fibers.node bin\darwin-x64-50\
cd ..\robotjs
set HOME=C:\.electron-gyp && node-gyp rebuild --target=1.4.4 --arch=x64 --dist-url=https:\\atom.io\download\atom-shell
