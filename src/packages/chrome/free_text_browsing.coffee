class FreeTextBrowsing
  instance = null
  linkList = {}
  constructor: (@browserController) ->
    return instance if instance?
    instance = @
    @natural = require 'natural'
    @searchQuery = {}
    @alreadySubscribed = false
    @subscribeToEvents()
    @classifier = null
    @metaphone = @natural.Metaphone
    @linkList = {}
    @termFrequency = {}
    @termFrequencyDocumentMapping = {}

  setLinkList: (tabId, frameId, linkList, append = false) ->
    @linkList[tabId] ?= {}
    unless append is true
      @clearLinkList tabId, frameId
    @linkList[tabId][frameId] = _.extend @linkList[tabId][frameId], @processLinkList(linkList, frameId)
    @trainTermFrequency tabId, frameId

  getLinkList: (tabId, frameId = null, aggregate = false) ->
    unless aggregate
      return @linkList[tabId][frameId] || {}
    aggregate = []
    _.each @linkList[tabId], (documents, frameId) ->
      _.each documents, (document) ->
        aggregate.push document
    aggregate

  clearLinkList: (tabId, frameId = null) ->
    if frameId?
      @linkList[tabId][frameId] = {}
      return
    @linkList[tabId] = {}

  subscribeToEvents: ->
    unless @alreadySubscribed
      @browserController.on 'setLinkList', => @eventSetLinkList.apply @, arguments
      @browserController.on 'getMatches', => @eventGetMatches.apply @, arguments
      # @browserController.on 'eventBrowserEscape', => @eventBrowserEscape.apply @, arguments
      @browserController.on 'eventBrowserKeypress', => @eventBrowserKeypress.apply @, arguments
      @browserController.on 'clearSearchQuery', => @eventClearSearchQuery.apply @, arguments
      @browserController.on 'eventTabsOnUpdated', => @eventTabsOnUpdated.apply @, arguments
      @alreadySubscribed = true


  eventTabsOnUpdated: ({tabId, changeInfo, tab}) ->
    if changeInfo.status? and changeInfo.status is 'loading'
      @clearLinkList tabId, null
      @clearTermFrequency tabId
      @clearSearchQuery tabId

  eventSetLinkList: ({linkList, tabId, frameId}) ->
    @clearTermFrequency tabId
    @setLinkList tabId, frameId, linkList


  processLinkList: (linkList, frameId) ->
    @classifier = new @natural.BayesClassifier
    @classifier.events.on 'trainedWithDocument', (obj) ->
      console.log obj

    wordTokenizer = new @natural.WordTokenizer()

    processedList = {}
    spaceTokenizer = new @natural.RegexpTokenizer({pattern: /\s+/})

    _.each linkList, ({text, id}) ->
      # we tokenize in order to escape weird characters
      text = spaceTokenizer.tokenize text
      processedList[id] ?= []
      text = text.join ' '
      text = text.replace /\&/g, ' and '
      text = text.replace /([A-Z][a-z0-9]+(?=[A-Z][a-z0-9]+)(?!$))/g, ' $1 '
      text = text.replace /\s+/g, ' '
      processedList[id].push text.toLowerCase()

      # TODO: fix!
      text = text.replace /[\W_]+/g, ' '
      text = text.replace /\s+/g, ' '
      processedList[id].push text.toLowerCase()


    processedList = _.map processedList, (values, id) ->
      {id, frameId, documents: _.unique values}
    result = _.indexBy processedList, 'id'
    #  console.error result
    result

  trainClassifier: (processedList) ->
    _.each processedList, ({id, values}) ->
      do (id, values) =>
        _.each values, (document) =>
          @classifier.addDocument document, id
    , @

  setLinkProperty: (tabId, frameId, linkId, property, value) ->
    # try
    #   @linkList[tabId][frameId][linkId][property] = value
    # catch error
    #   console.error error
    @linkList[tabId][frameId][linkId][property] = value

  getAggregateIndex: (tabId) ->
    index = @termFrequency[tabId].documents.length
    --index

  clearTermFrequency: (tabId) ->
    @termFrequency[tabId] = null
    @termFrequencyDocumentMapping[tabId] = {}

  trainTermFrequency: (tabId, frameId, linkList = null) ->
    @termFrequency[tabId] ?= new @natural.TfIdf
    linkList = @getLinkList tabId, frameId unless linkList?
    @termFrequencyDocumentMapping[tabId] ?= {}
    @termFrequencyDocumentMapping[tabId][frameId] ?= {}
    _index = @getAggregateIndex tabId
    _.each linkList, ({id, documents}) =>
      do (id, documents) =>
        _.each documents, (document) =>
          @termFrequency[tabId].addDocument document
          console.log "Document tabId: #{tabId}, frameId: #{frameId}, index: #{_index}, id: #{id}\n#{document}"
          @termFrequencyDocumentMapping[tabId][frameId][++_index] = id
          @setLinkProperty tabId, frameId, id, 'termFrequencyId', _index

  measureTermFrequency: (queryString, tabId, next) ->
    count = @termFrequency[tabId].documents.length
    next = _.after count, next
    funky = do (queryString, tabId) =>
      (i, measure) =>
        _.each @termFrequencyDocumentMapping[tabId], (mappings, frameId) =>
          linkId = _.find mappings, (id, termFrequencyDocumentId) =>
            parseInt(termFrequencyDocumentId) is i
          if linkId?
            if measure
              console.error tabId, frameId, linkId, 'measure', measure
            @setLinkProperty tabId, frameId, linkId, 'measure', measure
        do next

    @termFrequency[tabId].tfidfs queryString, funky
    next()

  eventGetMatches: (queryString, tabId) ->
    @getMatches queryString, tabId

  dispatchMatchedLinks: (matchedLinks, tabId) ->
    @browserController.send
      request: 'tabMessage'
      parameters:
        tabId: tabId
        message:
          namespace: 'freeTextBrowsing'
          method: 'updateMatchedLinks'
          type: 'invokeBound'
          argumentsObject: {
            matchedLinks
          }

  toggleAllMarkers: ->
    {id} = browserController.getActiveTab()
    return false unless id?
    @browserController.send
      request: 'tabMessage'
      parameters:
        tabId: id
        message:
          namespace: 'freeTextBrowsing'
          method: 'toggleAllMarkers'
          type: 'invokeBound'

  eventClearSearchQuery: ({tabId}) ->
    @clearSearchQuery tabId

  clearSearchQuery: (tabId) ->
    @searchQuery[tabId] = ''

  eventBrowserEscape: ({tabId})->
    @clearSearchQuery tabId

  appendSearchQuery: (tabId, searchQuery) ->
    @searchQuery[tabId] ?= ''
    @searchQuery[tabId] += searchQuery

  getSearchQuery: (tabId) ->
    @searchQuery[tabId]

  eventBrowserKeypress: ({keys, tabId}) ->
    @appendSearchQuery tabId, keys
    @getMatches(@getSearchQuery(tabId), tabId)

  getMatches: (queryString, tabId) ->
    console.error "Searching for #{queryString}"
    # do (queryString, tabId) =>
    #   # console.log @processedList
    #   _.each @getLinkList(tabId, null, true), ({documents, id, frameId}) =>
    #     do (id, queryString, documents, tabId, frameId) =>
    #       _.each documents, (document) =>
    #         do (document, id, queryString, tabId, frameId) =>
    #           newDocuments = @getSoundAlikeDocuments document, queryString
    #           if newDocuments.length
    #             _.each newDocuments, (newDocument) =>
    #               @linkList[tabId][frameId][id].documents.push newDocument
    #           @trainTermFrequency tabId, frameId
    # @measureTermFrequency queryString, tabId
    # console.error @getLinkList(tabId, null, true)
    # console.error _.reject @getLinkList(tabId, null, true), (link) ->
    #   link.measure?
    next = =>
      # console.error @getLinkList tabId, null, true
      matches = _.filter @getLinkList(tabId, null, true), ({measure}, id) ->
        !!measure
      console.error matches
      matches = _.groupBy matches, ({measure}, index) ->
        measure
      console.error matches
      @dispatchMatchedLinks matches, tabId
    @measureTermFrequency queryString, tabId, next

  classify: (queryString) ->
    results = @classifier.getClassifications queryString
    console.error 'Classification: ', results
    results = _.map results, ({label, value}) ->
      {label, value: value * 100}
    results

  getDistances: (processedList = null, queryString) ->
    processedList = @processedList unless processedList?
    distances = _.map processedList, ({id, values}) ->
      combinedDistance = 0
      text = ''
      do (id, values) =>
        _.each values, (value, index) =>
          text = value if index is 0
          return if index > 0
          combinedDistance += @natural.JaroWinklerDistance value, queryString
      {id, text, rating: combinedDistance * 1000}
    , @
    distances

  soundAlike: (word1, word2) ->
    @metaphone.compare word1, word2

  getSoundAlikeDocuments: (document, query) ->
    # console.log "Sound matching: #{document}  =>  #{query}"
    _document = document
    documentArray = document.split ' '
    queryArray = query.split ' '
    newDocuments = []
    _.each documentArray, (documentWord, documentWordIndex) =>
      do (documentWord, documentWordIndex) =>
        _.each queryArray, (queryWord) =>
          return if documentWord is queryWord
          if @soundAlike documentWord, queryWord
            console.error "Words '#{documentWord}' and '#{queryWord}' sound alike!"
            newDocument = documentArray[...documentWordIndex]
            newDocument.push queryWord
            newDocument.concat documentArray[documentWordIndex+1..]
            newDocument = newDocument.join ' '
            newDocuments.push newDocument
            console.error "Created new document: \n'#{newDocument}'\nfor: \n'#{_document}'"
    # console.error newDocuments
    newDocuments



Commands.create 'browser.toggle-markers',
  spoken: 'marquis'
  description: ''
  tags: ['Chrome']
  action: (input) ->
    console.error @currentApplication().name
    console.error Settings.smartBrowsers
    if Settings.smartBrowsersUsed and @currentApplication().name in Settings.smartBrowsers
      browserController.freeTextBrowsing.toggleAllMarkers()
