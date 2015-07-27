Commands.createDisabled
  "daitler":
    grammarType: "custom"
    rule: "(dateFormats)?"
    tags: ["snippet"]
    description: "insert the current date/time in several different formats. See http://momentjs.com/docs/#/displaying/ for more formatting options"
    action: ({dateFormats}) ->
      @string moment().format(dateFormats or "LLL")
