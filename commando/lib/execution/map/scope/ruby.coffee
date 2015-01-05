_.extend Commands.mapping,
  "roobifend":
    kind: "action"
    grammarType: "individual"
    description: "ruby if end block"
    tags: ["domain-specific", "ruby"]
    actions: [
      kind: "block"
      transform: () ->
        """
        if 
        end
        """
      delay: 0.02
    ,
      kind: "key"
      key: "Up"
    ]
  "roobifelse":
    kind: "action"
    grammarType: "individual"
    description: "ruby if else block"
    tags: ["domain-specific", "ruby"]
    actions: [
      kind: "block"
      transform: () ->
        """
        if 
        else
        end
        """
      delay: 0.02
    ,
      kind: "key"
      key: "Up"
    ,
      kind: "key"
      key: "Up"
    ]
  "roobdefend":
    kind: "action"
    grammarType: "individual"
    description: "ruby def block"
    tags: ["domain-specific", "ruby"]
    actions: [
      kind: "block"
      transform: () ->
        """
        def 
        end
        """
      delay: 0.02
    ,
      kind: "key"
      key: "Up"
    ,
      kind: "key"
      key: "Right"
    ]
  "roobelsif":
    kind: "action"
    grammarType: "individual"
    description: "ruby elsif"
    tags: ["domain-specific", "ruby"]
    actions: [
      kind: "keystroke"
      keystroke: "elsif "
    ]
  "roobdewend":
    kind: "action"
    grammarType: "individual"
    description: "ruby do end block"
    tags: ["domain-specific", "ruby"]
    actions: [
      kind: "block"
      transform: () ->
        """
        do
        end
        """
      delay: 0.02
    ,
      kind: "key"
      key: "Up"
    ,
      kind: "key"
      key: "Right"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Return"
    ]
  "roobdovar":
    kind: "action"
    grammarType: "individual"
    description: "ruby do |var| block"
    tags: ["domain-specific", "ruby"]
    actions: [
      kind: "block"
      transform: () ->
        """
        do ||
        end
        """
      delay: 0.02
    ,
      kind: "key"
      key: "Up"
    ,
      kind: "key"
      key: "Right"
      modifiers: ["command"]
    ,
      kind: "key"
      key: "Left"
    ]
