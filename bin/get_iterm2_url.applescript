#!/usr/bin/osascript

tell application "iTerm" to tell current window to tell current tab to tell current session
	set h to variable named "tab.currentSession.hostname"
	if h is not missing value and h is not system attribute("HOST") then
	    return "https://" & h
	end if
end tell
