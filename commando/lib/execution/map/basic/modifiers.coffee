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
  "1": "won"
  "2": "too"
  "3": "three"
  "4": "four"
  "5": "five"
  "6": "six"
  "7": "seven"
  "8": "ate"
  "9": "nine"
  "0": "zer"
  Return: "turn"
  "/": "slush"
  ".": "peer"
  ",": "com"
  ";": "sink"
  Delete: "leet"
  ForwardDelete: "kit"
  " ": "oosh"
  Escape: "cape"
  Tab: "raff"
  "=": "queff"
  "-": "min"
  Up: "up"
  Down: "own"
  Left: "left"
  Right: "right"
  "]": "race"
  "[": "lets"
  "\\": "pike"

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
    Commands.create "#{prefix}#{value}",
      kind: "action"
      grammarType: "individual"
      description: "#{mods.join(' + ')} + #{key}"
      tags: ["modifiers"]
      module: "modifiers"
      action: ->
        @key key, mods
