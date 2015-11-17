Context.register
  name: 'gmail'
  applications: Settings.browserApplications
  when: -> @inBrowser() and @urlContains 'mail.google.com'

pack = Packages.register
  name: 'gmail'
  description: 'Commands for gmail'
  context: 'gmail'
  tags: ['gmail']

pack.commands
  'go-to-inbox':
    spoken: 'go inbox'
    description: 'go back to inbox in gmail'
    continuous: false
    action: -> @string 'gi'
