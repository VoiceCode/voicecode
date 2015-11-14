pack = Packages.register
  name: 'gmail'
  description: 'Commands for gmail'
  triggerScopes: ['Safari', 'Google Chrome']
  when: ->
    @inBrowser() and @urlContains 'mail.google.com'
  tags: ['gmail']

pack.commands
  'go-to-inbox':
    spoken: 'go inbox'
    description: 'go back to inbox in gmail'
    continuous: false
    action: -> @string 'gi'
