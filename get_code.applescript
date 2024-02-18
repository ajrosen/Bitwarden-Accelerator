#!/usr/bin/osascript
# *-*- apples -*-*

-- Main
on run u
    set t to "Enter code"
    set b to {"OK", "Cancel"}
    set myName to "Bitwarden Accelerator"

    set m to first item of u

    if (m = "0") then			-- Authenticator app
	set t to "Enter the 6 digit verification code from  your authenticator app"
    end

    if (m = "1") then			-- Email
	set t to "Check yur email for your two-step login verification code"
    end

    if (m = "3") then			-- YubiKey OTP
	set t to "Insert your YubiKey into your computer's USB port, then touch its button"
    end

    return text returned of (display dialog t ¬
	buttons b ¬
	default answer "" ¬
	default button "OK" ¬
	with title myName ¬
	with icon caution)
end run
