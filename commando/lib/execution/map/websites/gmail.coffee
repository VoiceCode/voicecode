Commands.createDisabledWithDefaults
  triggerScopes: ["Safari", "Google Chrome"]
  when: -> @urlContains "mail.google.com"
  continuous: false
  tags: ["gmail"]
,
  "go inbox":
    description: "go back to inbox in gmail"
    action: -> @string "gi"
