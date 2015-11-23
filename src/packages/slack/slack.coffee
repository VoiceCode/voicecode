pack = Packages.register
  name: 'slack'
  applications: ['com.tinyspeck.slackmacgap']
  description: 'Slack integration'
  scope: 'slack'

pack.commands
  'switch-channel':
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
