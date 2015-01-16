# _.extend Commands.mapping,
  # "chompshin":
  #   kind: "modifier"
  #   grammarType: "oneArgument"
  #   description: "presses the modifier combo + whatever you speak"
  #   description: "command + option"
  #   modifiers: ["command", "option"]
  # "chom":
  #   kind: "modifier"
  #   grammarType: "oneArgument"
  #   description: "presses the modifier combo + whatever you speak"
  #   description: "command"
  #   modifiers: ["command"]  
  # "choff":
  #   kind: "modifier"
  #   grammarType: "oneArgument"
  #   description: "presses the modifier combo + whatever you speak"
  #   description: "command + shift"
  #   modifiers: ["command", "shift"]
  # "alter":
  #   kind: "modifier"
  #   grammarType: "oneArgument"
  #   description: "presses the modifier combo + whatever you speak"
  #   description: "option"
  #   modifiers: ["option"]
  # "troll":
  #   kind: "modifier"
  #   grammarType: "oneArgument"
  #   description: "presses the modifier combo + whatever you speak"
  #   description: "control"
  #   modifiers: ["control"]
  # "tralter":
  #   kind: "modifier"
  #   grammarType: "oneArgument"
  #   description: "presses the modifier combo + whatever you speak"
  #   description: "control + option"
  #   modifiers: ["control", "option"]
  # "chifton":
  #   kind: "modifier"
  #   grammarType: "oneArgument"
  #   description: "presses the modifier combo + whatever you speak"
  #   description: "command + option + shift"
  #   modifiers: ["command", "option", "shift"]


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

_.each commandModifiers, (mods, prefix) ->
  _.each commandLetters, (value, key) ->
    Commands.mapping["#{prefix}#{value}"] = 
      kind: "action"
      grammarType: "individual"
      description: "#{mods.join(' + ')} + #{key}"
      tags: ["modifier", key, mods.join("+")]
      actions: [
        kind: "script"
        script: (input) ->
          Scripts.singleModifier(key, mods)
      ]

