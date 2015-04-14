# _.extend Commands.mapping,
#   "number":
#     kind: "number"
#     grammarType: "none"
#     description: "not spoken. used indirectly by other commands"

numbers = 
  one: 1
  two: 2
  twah: 2
  three: 3
  four: 4
  quads: 4
  five: 5
  six: 6
  seven: 7
  eight: 8
  nine: 9
  zero: 0
  oh: 0
  eleven: 11
  twelve: 12
  thirteen: 13
  fourteen: 14
  fifteen: 15
  sixteen: 16
  seventeen: 17
  eighteen: 18
  nineteen: 19
  ten: 10
  twenty: 20
  thirty: 30
  forty: 40
  fifty: 50
  sixty: 60
  seventy: 70
  eighty: 80
  ninety: 90

_.each numbers, (value, key) ->
  Commands.create key,
    kind: "action"
    grammarType: "none"
    description: "Enters the number: #{value}"
    namespace: "#{value}"
    tags: ["number", "recommended"]
    module: "number"

