require '../dependencies'


cleanup = (test) ->
  Scope.resetAll()
  test.end()


test "register", (test) ->
  scope = Scope.register
    name: 'test'
    applications: 'Atom'

  test.true scope
  cleanup test
