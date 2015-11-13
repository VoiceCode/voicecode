test = require "tape"
global.Packages = require '../../lib/packages/packages'
Commands = require '../../lib/commands'

test "register", (test) ->
  test.equal "hello", "hello"
  instance = Packages.register
    name: 'test'
    description: 'something'

  test.true instance

  test.end()
