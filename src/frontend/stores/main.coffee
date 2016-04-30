requireDirectory = require 'require-directory'
storeFactory = require './factory'
ducks = requireDirectory module, '../ducks/'
module.exports = storeFactory ducks
