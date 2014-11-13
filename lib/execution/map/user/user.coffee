# add any custom commands here

# I recommend you pick your top 10 most frequently used applications
# and add direct commands to switch to them as shown below, rather than using the "fox" command
# make sure whatever applications you add here are also defined in /config/settings.coffee

_.extend Commands.mapping,
  "chromie":
    kind: "action"
    description: "open chrome"
    grammarType: "individual"
    actions: [
      kind: "script"
      script: () ->
        Scripts.openApplication("chrome")
    ]