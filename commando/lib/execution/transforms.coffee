@Transforms =
  identity: (textArray) ->
    textArray.join(' ').replace(/\s\.\s/g, ".").replace(/\.\s/, ".").replace(/\s\./, ".").replace(/\s:/, ":").replace(/\s'\s/, "'")
  literal: (textArray) ->
    switch Meteor.settings.defaultLiteralTransform
      when "snake"
        Transforms.snake(textArray)
      when "camel"
        Transforms.camel(textArray)
      else
        Transforms.identity(textArray)
  snake: (textArray) ->
    textArray.join('_').replace(/_\._/g, ".").replace(/\._/, ".")
  rubySymbol: (textArray) ->
    ":" + Transforms.snake(textArray)
  camel: (textArray) ->
    _.map(textArray, (item, index) ->
      if index is 0
        item.toLowerCase()
      else
        item.charAt(0).toUpperCase() + item.slice(1)
    ).join('')
  stud: (textArray) ->
    _.map(textArray, (item, index) ->
      item.charAt(0).toUpperCase() + item.slice(1)
    ).join('')
  spine: (textArray) ->
    _.slugify textArray.join(' ')
  lowerSlam: (textArray) ->
    textArray.join('')
  upperSlam: (textArray) ->
    _.map(textArray, (item, index) ->
      item.toUpperCase()
    ).join('')
  upperCase: (textArray) ->
    _.map(textArray, (item, index) ->
      item.toUpperCase()
    ).join(' ').replace(/\s\.\s/g, ".").replace(/\.\s/, ".")
  upperSnake: (textArray) ->
    _.map(textArray, (item, index) ->
      item.toUpperCase()
    ).join('_').replace(/_\._/g, ".").replace(/\._/, ".")
  upperSpine: (textArray) ->
    _.slugify(textArray.join(' ')).toUpperCase()
  dotsWay: (textArray) ->
    textArray.join('.').replace(/\.\.\./g, ".").replace(/\.\./, ".")
  pathway: (textArray) ->
    textArray.join('/')
  titleSentance: (textArray) ->
    _.map(textArray, (item, index) ->
      item.charAt(0).toUpperCase() + item.slice(1)
    ).join(' ').replace(/\s\.\s/g, ".").replace(/\.\s/, ".")
  titleFirstSentance: (textArray) ->
    _.map(textArray, (item, index) ->
      if index is 0
        item.charAt(0).toUpperCase() + item.slice(1)
      else
        item
    ).join(' ').replace(/\s\.\s/g, ".").replace(/\.\s/, ".")
  "@camelCase": (textArray) ->
    "@" + Transforms.camel(textArray)
  ".camelCase": (textArray) ->
    "." + Transforms.camel(textArray)
  firstLetters: (textArray) ->
    _.map(textArray, (item, index) ->
      item.charAt(0)
    ).join('')
  pluckThree: (string) ->
    if string.length
      string.slice(0, 3)
    else
      ""
