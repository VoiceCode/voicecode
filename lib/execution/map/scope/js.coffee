_.extend Commands.mapping,
  "jocksif":
    kind: "action"
    grammarType: "individual"
    description: "JavaScript if block"
    actions: [
      kind: "block"
      transform: () ->
        "if () {};"
      delay: 0.02
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Left"
    ]