#!/usr/bin/osascript
# *-*- apples -*-*

-- Main
on run u
    set answer to ""

    set t to ""
    if (system attribute "uriop") is "add" then
	set t to t & "Add"
    end if

    if (system attribute "uriop") is "edit" then
	set t to t & "Enter"
	set answer to u
    end if

    set t to t & " new URL for " & (system attribute "objectName")

    set myName to (system attribute "alfred_workflow_name")

    return text returned of (display dialog t ¬
	default button "OK" ¬
	default answer answer ¬
	with title myName ¬
	with icon caution)
end run
