Transforms =
  identity: (textArray) ->
    textArray.join(' ')
    .replace(/\s\.\s/g, ".")
    .replace(/\.\s/, ".")
    .replace(/\s\./, ".")
    .replace(/\s:/, ":")
    .replace(/\s'\s/, "'")
    .replace(/-\s/, "-")
  literal: (textArray) ->
    Transforms[Settings.core.defaultLiteralTransform](textArray)
  snake: (textArray) ->
    textArray.join('_').replace(/_\._/g, ".").replace(/\._/, ".")
  camel: (textArray) ->
    _.camelCase textArray.join ' '
  stud: (textArray) ->
    _.map(textArray, (item, index) ->
      item.charAt(0).toUpperCase() + item.slice(1)
    ).join('')
  spine: (textArray) ->
    _.kebabCase textArray.join(' ')
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
    _.kebabCase(textArray.join(' ')).toUpperCase()
  dots: (textArray) ->
    textArray.join('.').replace(/\.\.\./g, ".").replace(/\.\./, ".")
  slashes: (textArray) ->
    textArray.join('/')
  titleSentance: (textArray) ->
    # _.map(_.compact(textArray), (item, index) ->
    #   item.charAt(0).toUpperCase() + item.slice(1)
    # ).join(' ').replace(/\s\.\s/g, ".").replace(/\.\s/, ".")
    _.startCase textArray.join ' '
  titleFirstSentance: (textArray) ->
    _.map(textArray, (item, index) ->
      if index is 0
        item.charAt(0).toUpperCase() + item.slice(1)
      else
        item
    ).join(' ').replace(/\s\.\s/g, ".").replace(/\.\s/, ".")
  firstLetters: (textArray) ->
    _.map(textArray, (item, index) ->
      item.charAt(0)
    ).join('')
  pluckThree: (string) ->
    if string.length
      string.slice(0, 3)
    else
      ""

module.exports = Transforms
