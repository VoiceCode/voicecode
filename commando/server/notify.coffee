@Notify = (message)->
	if platform is "windows"
		console.log message
	else if platform is "linux"
		console.log message
	else if platform is "darwin"
	  if Settings.notificationProvider is "Growl"
	    Applescript """
	tell application "System Events"
		set isRunning to (count of (every process whose bundle identifier is "com.Growl.GrowlHelperApp")) > 0
	end tell

	if isRunning then
		tell application id "com.Growl.GrowlHelperApp"

			set the notificationList to ¬
				{"Notification"}

			register as application ¬
				"Voicecode" all notifications notificationList ¬
				default notifications notificationList ¬
				icon of application "Script Editor"

			notify with name ¬
				"Notification" title ¬
				"Voicecode" description ¬
				"#{message}" application name "Voicecode"
		end tell
	end if
	    """
	  else if Settings.notificationProvider is "log"
	  	console.log message
	  else
	    Applescript """
	    display notification "#{message}" with title "VoiceCode"
	    """
