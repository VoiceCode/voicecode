@Cashes = new Mongo.Collection("cashes")

Schemas.Cash = new SimpleSchema
  key:
    type: String
    index: 1
  fingerprint:
    type: String
  content:
    type: String
  updatedAt:
    type: Date
    index: 1

Cashes.attachSchema(Schemas.Cash)
