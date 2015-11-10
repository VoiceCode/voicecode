Commands.createDisabled
  'format.date':
    grammarType: 'custom'
    spoken: 'daitler'
    rule: '<spoken> (dateFormat)*'
    tags: ['snippet']
    description: 'insert the current date/time in several different formats. See http://momentjs.com/docs/#/displaying/ for more formatting options'
    variables:
      dateFormat: -> Settings.dateFormats
    action: ({dateFormat}) ->
      @string moment().format(dateFormat or 'LLL')
