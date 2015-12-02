pack = Packages.register
  name: 'gmail'
  description: 'Commands for gmail'
  createScope: true
  applications: -> Settings.browserApplications
  when: -> @inBrowser() and @urlContains 'mail.google.com'

pack.commands
  'go-to-inbox':
    spoken: 'go inbox'
    description: 'go back to inbox in gmail'
    continuous: false
    action: -> @string 'gi'
