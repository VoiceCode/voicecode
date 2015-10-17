_.extend Settings,
  dragonVersion: 5
  slaveMode: true
  userAssetsPath: ''
  dragonCommandMode: 'new-school'

# jarvis bake pizza with bacon garlic and mozzarella
# jarvis make pizza with beef garlic mozzarella
# jarvis make pizza with foie gras and mayo with gorgonzola and some chili
# jarvis bake pizza
# jarvis make pizza
# jarvis cook up pizza
# jarvis pizza
# jarvis look up imdb the martian
# jarvis search google for the martian
Commands.create "pizza",
  kind : "action"
  grammarType : "dynamic"
  description : "jarvis ai bakes pizza"
  triggerPhrase : '(ai) (action)* pizza (with)* (ingredient)* (and)* (ingredient)*'
  variables: {
    'action': {
      mapping:
        name: ['cook', 'bake']
      defaults:
        name: 'bake'
    }
    'ai': {
      mapping:
        name: ['jarvis', 'siri']
      defaults:
        name: 'jarvis'
    }
    'ingredient': {
      mapping: {
        meetType: ['bacon', 'beef', 'foie gras']
        sauce: ['mayo', 'garlic', 'chili']
        cheeseType: ['mozzarella', 'gorgonzola']
      }
      defaults: {
        meetType: 'bacon'
        sauce: 'catchup'
        cheeseType: 'bree'
      }
    }
  }
  tags : ["ai"]
  continuous: false
  action : (input) ->
    return new Pizza
