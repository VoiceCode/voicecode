Commands.createDisabled
  "hytag":
    grammarType: "textCapture"
    description: "inserts an html tag with a dynamic name and dynamic attributes"
    tags: ["domain-specific", "html"]
    action: (input) ->
      textArray = input or []
      tagName = textArray[0] or ""
      attributeNames = textArray.slice(1)
      attributes = if attributeNames.length
        " " + _.map(attributeNames, (item) ->
          "#{item}=\"\""
        ).join(" ")
      else
        ""
      tag = if _.contains(Html.selfClosingTags, tagName)
        "<#{tagName}#{attributes} />"
      else
        "<#{tagName}#{attributes}></#{tagName}>"

      # type out the string
      @string tag

      # move the cursor back between the angle brackets by counting the length of the last section
      @left "</#{tagName}>".length
