@commandLetters = 
  A: "arch"
  B: "brov"
  C: "char"
  D: "dell"
  E: "etch"
  F: "fomp"
  G: "goof"
  H: "hark"
  I: "ice"
  J: "jinks"
  K: "koop"
  L: "lug"
  M: "mowsh"
  N: "nerb"
  O: "ork"
  P: "pooch"
  Q: "quash"
  R: "rosh"
  S: "souk"
  T: "teek"
  U: "unks"
  V: "verge"
  W: "womp"
  X: "trex"
  Y: "yang"
  Z: "zooch"
  n1: "won"
  n2: "too"
  n3: "three"
  n4: "four"
  n5: "five"
  n6: "six"
  n7: "seven"
  n8: "ate"
  n9: "nine"
  n0: "zer"
  Return: "turn"
  Slash: "slush"
  Period: "peer"
  Comma: "com"
  Semicolon: "sink"
  Delete: "leet"
  ForwardDelete: "kit"
  Space: "oosh"
  Escape: "cape"
  Tab: "raff"
  Equal: "queff"
  Minus: "min"
  Up: "up"
  Down: "own"
  Left: "left"
  Right: "right"
  RightBracket: "race"
  LeftBracket: "lets"
  Backslash: "pike"

@commandModifiers =
  chomm: ["command"]
  shoff: ["command", "shift"]
  shay: ["command", "option"]
  flock: ["command", "option", "shift"]
  crop: ["option"]
  snoop: ["option", "shift"]
  troll: ["control"]
  mack: ["command", "control"]
  triff: ["control", "shift"]
  prick: ["command", "control", "shift"]
  sky: ["shift"]

allowed =
  chomm: [
    "won"
    "too"
    "three"
    "four"
    "five"
    "six"
    "seven"
    "arch"
  ]
  shay: [
    "souk"
  ]

_.each commandModifiers, (mods, prefix) ->
  _.each commandLetters, (value, key) ->
    if allowed[prefix]? and _.contains allowed[prefix], value
      Commands.mapping["#{prefix}#{value}"] = 
        kind: "action"
        grammarType: "individual"
        description: "#{mods.join(' + ')} + #{key}"
        tags: ["modifiers"]
        module: "modifiers"
        actions: [
          kind: "script"
          modifiers: mods
          key: key
          script: (input) ->
            Scripts.singleModifier(key, mods)
        ]
