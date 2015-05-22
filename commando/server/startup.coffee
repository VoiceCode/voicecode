# Meteor.startup ->
#   setContext = """
#   set theOutputFolder to path to preferences folder from user domain as string
#   set plist_file to theOutputFolder & "voicecode.plist"
#   tell application "System Events"
#     if not (exists file plist_file) then
#       tell application "System Events"
#         tell (make new property list file with properties {name:plist_file})
#           make new property list item at end with properties {kind:string, name:"context", value:"global"}
#         end tell
#       end tell
#     end if
#   end tell
#   """
#   command ="""osascript <<EOD
#   #{setContext}
#   EOD
#   """
#   Shell.exec command, async: true

Meteor.startup ->
  console.log "Copyright (c) VoiceCode.io 2015 - all rights reserved"
  @Grammar = new Grammar()
  @ParseGenerator = {}
  Commands.reloadGrammar()
  @synchronizer = new Synchronizer()
  synchronizer.updateAllCommands(true)
