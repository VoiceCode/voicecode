Commands.createDisabled
  'format.date':
    grammarType: 'custom'
    rule: '<name> (dateFormats)*'
    tags: ['snippet']
    description: 'insert the current date/time in several different formats. See http://momentjs.com/docs/#/displaying/ for more formatting options'
    variables:
      dateFormats: -> Settings.dateFormats
    action: ({dateFormats}) ->
      @string moment().format(dateFormats or 'LLL')
