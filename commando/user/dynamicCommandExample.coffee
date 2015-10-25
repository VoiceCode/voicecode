Commands.create "pizza",
  description: "jarvis ai bakes pizza"
  grammarType: "custom"
  rule: '(ai) (action)* pizza (with)* (ingredient) (and/and also)* (ingredient)*'
  variables:
    action: ['cook', '+bake']
    ai: ['+jarvis', 'siri']
    ingredient: ['+bacon', 'beef', 'foie gras']
  tags : ["ai"]
  action : (input) ->
    console.log 'custom', input
