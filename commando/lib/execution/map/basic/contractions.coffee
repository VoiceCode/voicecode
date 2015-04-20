Commands.create
  "daspark":
    kind: "action"
    grammarType: "individual"
    description: "contraction of: dot spark"
    aliases: ["chin"]
    tags: ["copy-paste"]
    action: -> 
      @key "."
      @key "V", ['command']