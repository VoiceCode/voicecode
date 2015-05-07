@Transforms =
  identity: (textArray) ->
    textArray.join(' ').replace(/\s\.\s/g, ".").replace(/\.\s/, ".").replace(/\s\./, ".").replace(/\s:/, ":").replace(/\s'\s/, "'").replace(/-\s/, "-")
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
    _s.slugify textArray.join(' ')
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
    _s.slugify(textArray.join(' ')).toUpperCase()
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
  firstLetters: (textArray) ->
    _.map(textArray, (item, index) ->
      item.charAt(0)
    ).join('')
  pluckThree: (string) ->
    if string.length
      string.slice(0, 3)
    else
      ""

# selection transforms
class Transformer
  hasSpace = /\s/
  hasSeparator = /[\W_]/
  separatorSplitter = /[\W_]+(.|$)/g
  camelSplitter = /(.)([A-Z]+)/g

  unseparate: (string) ->
    string.replace separatorSplitter, (m, next) ->
      if next then ' ' + next else ''

  uncamelize: (string) ->
    string.replace camelSplitter, (m, previous, uppers) ->
      previous + ' ' + uppers.toLowerCase().split('').join(' ')

  toNoCase: (string) ->
    if hasSpace.test(string)
      return string.toLowerCase()
    if hasSeparator.test(string)
      return (@unseparate(string) or string).toLowerCase()
    @uncamelize(string).toLowerCase()

  identity: (string) ->
    @toNoCase(string).replace /[\W_]+(.|$)/g, (matches, match) ->
      if match then ' ' + match else ''

  snake: (string) ->
    @identity(string).replace /\s/g, '_'

  camel: (string) ->
    @identity(string).replace /\s(\w)/g, (matches, letter) ->
      letter.toUpperCase()

  toDotCase: (string) ->
    @identity(string).replace /\s/g, '.'

  toConstantCase: (string) ->
    @snake(string).toUpperCase()

  titleFirstSentance: (string) ->
    @toNoCase(string).replace /[a-z]/i, (letter) ->
      letter.toUpperCase()

  spine: (string) ->
    @identity(string).replace /\s/g, '-'

  toCapitalCase: (string) ->
    @toNoCase(string).replace /(^|\s)(\w)/g, (matches, previous, letter) ->
      previous + letter.toUpperCase()

  stud: (string) ->
    @identity(string).replace /(?:^|\s)(\w)/g, (matches, letter) ->
      letter.toUpperCase()

  upperCase: (string) ->
    @identity(string).toUpperCase()

  lowerSlam: (string) ->
    @identity(string).replace /\s/g, ''

  upperSlam: (string) ->
    @identity(string).replace(/\s/g, '').toUpperCase()

  titleSentance: (string) ->
    escape = (str) ->
      String(str).replace /([.*+?=^!:${}()|[\]\/\\])/g, '\\$1'
    minors = [
      'a'
      'an'
      'and'
      'as'
      'at'
      'but'
      'by'
      'en'
      'for'
      'from'
      'how'
      'if'
      'in'
      'neither'
      'nor'
      'of'
      'on'
      'only'
      'onto'
      'out'
      'or'
      'per'
      'so'
      'than'
      'that'
      'the'
      'to'
      'until'
      'up'
      'upon'
      'v'
      'v.'
      'versus'
      'vs'
      'vs.'
      'via'
      'when'
      'with'
      'without'
      'yet'
    ]
    escaped = minors.map(escape)
    minorMatcher = new RegExp('[^^]\\b(' + escaped.join('|') + ')\\b', 'ig')
    colonMatcher = /:\s*(\w)/g
    toCapitalCase(string).replace(minorMatcher, (minor) ->
      minor.toLowerCase()
    ).replace colonMatcher, (letter) ->
      letter.toUpperCase()

@SelectionTransformer = new Transformer()
