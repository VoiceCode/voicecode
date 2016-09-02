require '../dependencies'

validPackage = ->
  Packages.register
    name: 'test'
    description: 'something'

cleanup = (test) ->
  Packages.resetAll()
  test.end()


test "register", (test) ->
  instance = validPackage()
  test.true instance
  cleanup test

test "validate", (test) ->
  instance = Packages.register
    description: 'something'
  test.false instance
  cleanup test

test "get", (test) ->
  instance = validPackage()
  other = Packages.get 'test'
  test.deepEqual instance, other
  cleanup test

test 'reset', (test) ->
  instance = validPackage()
  test.equal _.size(Packages.packages), 1
  Packages.resetAll()
  test.equal _.size(Packages.packages), 0
  cleanup test
  
