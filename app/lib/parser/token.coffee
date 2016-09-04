module.exports = class Token
  constructor: (input) ->
    if _.isArray input
      @initializeFromArray input
    else if _.isString input
      @initializeFromString input
  initializeFromArray: (input) ->
    @input = input
  initializeFromString: (input) ->
    @input = @destructure input

  # convert all kinds of formats into an array of parts
  # userId => [user, id]
  # user_id => [user, id]
  # User id => [user, id]
  # etc
  destructure: (string) ->
