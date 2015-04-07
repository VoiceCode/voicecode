@Enables = new Mongo.Collection("enables")

Schemas.Enable = new SimpleSchema
  name:
    type: String
    index: 1
    unique: true
  enabled:
    type: Boolean

Enables.attachSchema(Schemas.Enable)
