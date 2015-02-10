@PreviousCommands = new Mongo.Collection("previousCommands")

Schemas.PreviousCommand = new SimpleSchema
  spoken:
    type: String
  interpretation:
    type: [Object]
    blackbox: true
  generated:
    type: String
  createdAt:
    type: Date
    index: 1

PreviousCommands.attachSchema(Schemas.PreviousCommand)

PreviousCommands.helpers
  interpretationString: ->
    JSON.stringify @interpretation