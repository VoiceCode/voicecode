Commands.createDisabledWithDefaults
  triggerScopes: ["Slack"]
  tags: ["slack"]
,  
  "channel":
    description: "open a channel / conversation"
    grammarType: "textCapture"
    continuous: false
    action: (input) ->
      @key 'K', 'command'
      if input?.length
        @string input.join(' ')
        @key 'Return'
