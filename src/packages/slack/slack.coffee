Scope.register
  name: 'slack'
  applications: ['Slack']

pack = Packages.register
  name: 'slack'
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
