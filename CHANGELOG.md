# 3.0.1

Bug fix:  Create ~/Library/LaunchAgents/ if it doesn't exist

# 3.0.0

Add "automatic field rotation".  If an item is selected twice within 15 seconds, copy the TOTP code to the clipboard instead of the password.

Important bug fix in the path to *bwa-sync* as defined in the Launch Agent

# 2.1.0

*Secure notes* always copy the note to the clipboard
*Cards* and *Identities* will always **Show all fields**

The auto-sync *Launch Agent* has been renamed to **bwa-sync** to make it easier to identify in System Settings.

There is now a "hidden" debug option.  Setting the workflow's **DEBUG** environment variable to **1** will write log information in the cache directory.

# 2.0.0

New option to install an *auto sync* launch agent, which automatically syncs your vault every *sync interval* minutes

## 1.2.1

Move .jq to jq

## 1.2.0

Support EU and self-hosted servers

## 1.1.0

Filter sensitive data before caching

# 1.0.0

Initial release
