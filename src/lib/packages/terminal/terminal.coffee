packageInfo = {
  name: 'terminal'
  description: 'Terminal integration'
  triggerScopes: ['Terminal']
}

Commands.before 'git.status', packageInfo, (input, context) ->
  @enter()
