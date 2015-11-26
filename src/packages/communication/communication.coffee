pack = Packages.register
  name: 'communication'
  description: 'Various commands for making phone calls, facetime, etc.'
  tags: ['messaging', 'phone']

pack.commands
  'phone-call':
    spoken: 'please dial'
    description: 'place a phone call to the given person (uses Settings.phoneNumbers). Requires an iPhone connected to the same wi-fi network as the computer'
    grammarType: 'textCapture'
    inputRequired: true
    action: (input) ->
      if input
        number = @fuzzyMatch Settings.phoneNumbers, input.join(' ')
        if number?
          @openURL "tel://#{number}?audio=yes"

          # click the call button
          @applescript """
          tell application "System Events"
              repeat while not (button "Call" of window 1 of application process "FaceTime" exists)
                  delay 1
              end repeat
              click button "Call" of window 1 of application process "FaceTime"
          end tell
          """
          @microphoneOff()

  'facetime-call':
    spoken: 'please facetime'
    description: 'place a facetime call to the given person (uses Settings.phoneNumbers)'
    tags: ['messaging', 'phone']
    action: (input) ->
      if input
        number = @fuzzyMatch Settings.phoneNumbers, input.join(' ')
        if number?
          @exec "open facetime://#{number}"

          # click the call button
          @applescript """
          tell application "System Events"
              repeat while not (button "Call" of window 1 of application process "FaceTime" exists)
                  delay 1
              end repeat
              click button "Call" of window 1 of application process "FaceTime"
          end tell
          """
          @microphoneOff()
        else
          @openApplication "Facetime"
      else
        @openApplication "Facetime"
