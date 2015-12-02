Commands.createDisabled
  "show.history":
    spoken: 'recon'
    description: "Show command history"
    tags: ["voicecode"]
    action: ->
      # TODO: implement UI
  'executeWorkflow':
    spoken: "flak"
    grammarType: "textCapture"
    description: "Execute workflow"
    tags: ["voicecode"]
    inputRequired: true
    action: (input) ->
      if input?.length # FIX: this
        workflow = @fuzzyMatch Settings.workflows, input.join(' ')
        chain = new Chain(workflow + " ")
        results = chain.generateNestedInterpretation()
        _.each results, (command) =>
          command.call(@)
          @delay 50
  'literal-escape':
    spoken: "keeper"
    needsParsing: false
    description: "whatever follows this command will be interpreted literally"
    tags: ["voicecode", "recommended"]
    action: (input) ->
      if input?.length
        @string input.join(" ")
  'mode.set':
    spoken: "set mode"
    grammarType: "textCapture"
    description: "change voicecode command execution mode"
    tags: ["system", "voicecode"]
    continuous: false
    inputRequired: true
    action: (input) ->
      if input?.length
        mode = @fuzzyMatch Settings.modes, input.join(' ')
        @setGlobalMode(mode)
  'smart.delete':
    spoken: "scratchy"
    description: "tries to do a 'smart' undo by deleting previously
     inserted characters if the previous command only inserted text"
    tags: ["system", "voicecode", "recommended"]
    action: () ->
      count = Commands.previousUndoByDeletingCount
      if count? and count > 0
        if @contextAllowsArrowKeyTextSelection()
          @repeat count, =>
            @key 'left', 'shift'
          @key "delete"
        else
          @repeat count, =>
            @key 'delete'
  'smart.select':
    spoken: "tragic"
    description: "tries to select the previously inserted text if possible"
    tags: ["system", "voicecode", "recommended"]
    action: () ->
      count = Commands.previousUndoByDeletingCount
      if count? and count > 0
        for i in [1..count]
          @key 'left', 'shift'
