storeFactory = require './factory'
ducks =
  app: require('../ducks/app')
  chain: require('../ducks/chain')
module.exports = storeFactory ducks
