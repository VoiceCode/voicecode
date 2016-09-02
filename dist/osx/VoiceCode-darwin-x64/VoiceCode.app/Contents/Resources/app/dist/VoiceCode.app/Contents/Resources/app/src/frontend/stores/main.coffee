requireDirectory = require 'require-directory'
storeFactory = require './factory'
ducks = requireDirectory module, '../ducks/'
delete ducks.chain
module.exports = storeFactory ducks
