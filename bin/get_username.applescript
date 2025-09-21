#!/usr/bin/osascript
# *-*- apples -*-*

-- Main
on run u
    set t to "Enter Bitwarden username"
    set b to {"OK", "Cancel"}
    set myName to (system attribute "alfred_workflow_name")

    if (length of u) = 0 then
	set u to ""
    end

    return text returned of (display dialog t ¬
	buttons b ¬
	default answer u ¬
	default button "OK" ¬
	with title myName ¬
	with icon stop)
end run
