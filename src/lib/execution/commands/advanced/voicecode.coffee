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
