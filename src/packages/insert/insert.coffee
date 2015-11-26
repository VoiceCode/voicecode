pack = Packages.register
  name: 'insert'
  description: 'Commands for inserting preset textual content like usernames, passwords, snippets, abbreviations, etc.'

pack.commands
  'abbreviation':
    spoken: 'shrink'
    grammarType: 'textCapture'
    description: 'inserts a common abbreviation'
    autoSpacing: 'normal normal'
    multiPhraseAutoSpacing: 'normal normal'
    action: (input) ->
      if input?.length
        result = @fuzzyMatch Settings.abbreviations, input.join(' ')
        @string result
  'password':
    spoken: 'trassword'
    grammarType: 'textCapture'
    description: 'inserts a password from the predefined passwords list'
    action: (input) ->
      if input?.length
        result = @fuzzyMatch Settings.passwords, input.join(' ')
        @string result
  'email':
    spoken: 'treemail'
    grammarType: 'textCapture'
    description: 'inserts an email from the predefined emails list'
    action: (input) ->
      if input?.length
        result = @fuzzyMatch Settings.emails, input.join(' ')
        @string result
  'username':
    spoken: 'trusername'
    grammarType: 'textCapture'
    description: 'inserts a username from the predefined usernames list'
    action: (input) ->
      if input?.length
        result = @fuzzyMatch Settings.usernames, input.join(' ')
        @string result

pack.settings
  defaultDateFormat: 'LLL'

pack.commands
  'date':
    grammarType: 'custom'
    spoken: 'daitler'
    rule: '<spoken> (dateFormat)*'
    description: 'insert the current date/time in several different formats. See http://momentjs.com/docs/#/displaying/ for more formatting options'
    variables:
      dateFormat: -> Settings.dateFormats
    action: ({dateFormat}) ->
      @string moment().format(dateFormat or pack.settings().defaultDateFormat)
