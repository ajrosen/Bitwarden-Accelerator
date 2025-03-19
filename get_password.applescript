#!/usr/bin/osascript
# *-*- apples -*-*

-- Main
on run u
    set t to "Enter password"
    set b to {"OK", "Cancel"}
    set myName to "Bitwarden Accelerator"

    if (length of u) > 0 then
	set t to u
    end

    -- password
    return text returned of (display dialog t ¬
	buttons b ¬
	default answer "" ¬
	default button "OK" ¬
	with title myName ¬
	with icon stop ¬
	with hidden answer)
end run
