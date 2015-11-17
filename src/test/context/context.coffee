require '../dependencies'


cleanup = (test) ->
  Context.resetAll()
  test.end()


test "register", (test) ->
  context = Context.register
    name: 'test'
    applications: 'Atom'

  test.true context
  cleanup test
