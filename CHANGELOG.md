## 6.7.0

* Add TOTP to Edit Item menu
* Remove fields from Edit Item
* Disable Touch ID if user is not in the sudoers file
* Allow for errors from grep when checking sudo configuratin

## 6.6.1

* Check API key for non-printable characters (see https://github.com/ajrosen/Bitwarden-Accelerator/issues/28)
* Fix loading main menu from search when logged out or vault is locked

## 6.6.0

* Unlock vault with Touch ID

## 6.5.0

* Favorites icons for login items
* Default action for SSH keys is to copy the private key to the clipboard
* Put more information in subtitles
  * *Copy private key to clipboard* for SSH keys
  * *Copy note to clipboard* for secure notes
  * Cardholder name for cards

## 6.4.0

* Add support for SSH Keys

## 6.3.0

* Fix and reintroduce Add item
* Show which Bitwarden server is being used in the Login to Bitwarden title
* Fix server URL for bitwarden.eu again

## 6.2.2

* Fix server URL for bitwarden.eu

## 6.2.1

* Fix opening an item's URL when there is more than one

## 6.2.0

* Cleanup subtitles for inactive modifiers
* Add cmd+control and cmd+alt modifiers
* Comment out Add item (currently broken, probably a bug in the Bitwarden CLI)
* Look for jq in /usr/bin (for Sequoia 15.1+)
* Expanded README

## 6.1.3

* Create alfred_workflow_cache directory every time, not just when checking dependencies
* Don't display notification when not restoring an item from trash

## 6.1.2

* Fix setting default collection
* Add logging to jq scripts
* Check for workflow version changes

## 6.1.1

* Fix setting default organization
* Performance improvements

## 6.1.0

* Search deleted items and restore them
* Add support for Zen browser
* Use --connect-timeout 3 --max-time 5 on all calls to curl
* Clean up some outputs and log messages
* Bug fixes
	* Unlock vault with two different payload formats

# 6.0.0

* Add a new login item to your vault
* Add vault timeout like the desktop app and browser extension
* Performance improvements
* Bug fixes

## 5.1.1

* Post unlock payload in JSON format

## 5.1.0

* Search for dependencies installed with Nix

# 5.0.0

* Edit an item directly in the workflow
	* Choose *Edit Item* from the *More Actions* menu
	* You can edit an item's *Username*, *Password*, and *Name*
* Navigate an item without leaving Alfred
	* Highlight an item and invoke Alfred's [Universal Action](https://www.alfredapp.com/universal-actions/)
* Added "return to" item in all menus to navigate to the previous menu in the workflow
* Use *Control + Command* from the search menu to open an item's URL in your default browser
* Include an item's ID, type, and Revision Date in the *Show all fields* window
* Show *No items found* if the search list is empty

## 4.2.0

* Add support for Firefox Developer Edition

## 4.1.2

* Hide password and MFA even from debug messages (Issue #10)
* Always sync vault immediately after unlocking

## 4.1.1

* Fix launch agent label

## 4.1.0

* Add support for Arc

# 4.0.0

* View item fields directly within the worfklow
	* Use the command+option modifier when selecting an item
	* Invoke a Universal Action

## 3.2.0

* Add support for Ghost Browser

## 3.1.2

* Fix JSON output for non-unlocked states

## 3.1.1

* Bug fix in "last item" processing

## 3.1.0

* Put recently selected item at the top of the list
* Use SyncInterval for AUTO_ROTATE
* Include file and line in debug messages

## 3.0.1

* Bug fix: Create ~/Library/LaunchAgents/ if it doesn't exist

# 3.0.0

* Add "automatic field rotation"
	* If an item is selected twice within 15 seconds, copy the TOTP code to the clipboard instead of the password.
* Important bug fix in the path to *bwa-sync* as defined in the Launch Agent

## 2.1.0

* *Secure notes* always copy the note to the clipboard
* *Cards* and *Identities* will always **Show all fields**
* The auto-sync *Launch Agent* has been renamed to **bwa-sync** to make it easier to identify in System Settings.
* There is now a "hidden" debug option.  Setting the workflow's **DEBUG** environment variable to **1** will write log information in the cache directory.

# 2.0.0

* New option to install an *auto sync* launch agent, which automatically syncs your vault every *sync interval* minutes

## 1.2.1

* Move .jq to jq

## 1.2.0

* Support EU and self-hosted servers

## 1.1.0

* Filter sensitive data before caching

# 1.0.0

* Initial release
