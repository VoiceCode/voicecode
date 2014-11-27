_.extend Commands.mapping,
  "hytag":
    kind: "action"
    grammarType: "textCapture"
    description: "inserts an html tag with a dynamic name and dynamic attributes"
    actions: [
      kind: "block"
      transform: (textArray) ->
        tagName = textArray[0] or ""
        attributeNames = textArray.slice(1)
        attributes = if attributeNames.length
          " " + _.map(attributeNames, (item) ->
            "#{item}=\"\""
          ).join(" ")
        else
          ""
        if _.contains(SelfClosingTags, tagName)
          "<#{tagName}#{attributes} />"
        else
          "<#{tagName}#{attributes}></#{tagName}>"
      delay: 0.1
    ,
      kind: "key"
      key: "Left"
      modifiers: ["option"]
    ,
      kind: "key"
      key: "Left"
    ,
      kind: "key"
      key: "Left"
    ]