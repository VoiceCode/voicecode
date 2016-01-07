pack = Packages.register
  name: 'alphabet'
  description: 'Phonetic alphabet'

pack.settings
  letters:
    a: "arch"
    b: "brov"
    c: "char"
    d: "dell"
    e: "etch"
    f: "fomp"
    g: "goof"
    h: "hark"
    i: "ice"
    j: "jinks"
    k: "koop"
    l: "lug"
    m: "mowsh"
    n: "nerb"
    o: "ork"
    p: "pooch"
    q: "quash"
    r: "rosh"
    s: "souk"
    t: "teek"
    u: "unks"
    v: "verge"
    w: "womp"
    x: "trex"
    y: "yang"
    z: "zooch"
  uppercaseLetterPrefix: "sky"
  singleLetterSuffix: "ling"

pack.commands
  'spelling':
    description: 'phonetic alphabet'
    grammarType: 'custom'
    rule: '(alphabet) (alphabet)*'
    needsParsing: false
    variables:
      alphabet: ->
        _.values(pack.settings().letters).concat [
          pack.settings().uppercaseLetterPrefix,
          pack.settings().singleLetterSuffix
        ]
