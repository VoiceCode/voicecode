Commands.createDisabledWithDefaults
  triggerScopes: ['Slack']
  tags: ['slack']
,
  'slack.switch-to-channel':
    spoken: 'channel'
    description: 'open a channel / conversation'
    grammarType: 'textCapture'
    continuous: false
    inputRequired: false
    action: (input) ->
      @key 'k', 'command'
      if input?.length
        @string input.join(' ')
        @key 'return'
