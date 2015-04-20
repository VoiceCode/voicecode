Commands.create
  "dotspark":
    kind: "action"
    grammarType: "individual"
    description: "contraction of: dot spark"
    aliases: ["chin"]
    tags: ["copy-paste", "combo"]
    action: -> 
      @key "."
      @key "V", ['command']