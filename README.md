# Bitwarden Accelerator

Interact with [Bitwarden CLI](https://bitwarden.com/help/cli/).

---

## Table of Contents

* [Key Features](#features)
* [Options](#options)
* [Invoking](#invoking)
* [Main menu](#mainMenu)
* [More menu](#moreMenu)

---

<a name="features"></a>
## Key Features

* Login with username and password or API Key
* Two-step logins with Authenticator app, YubiKey OTP, or Email
* Copy username, password, TOTP code, or notes to the clipboard
* Search different fields of an item
	* Any item by its name or folder
	* Logins by username or URL
	* Cards by brand (eg., search for "Visa")
	* Identities by any field in the item
* Favorite items are listed first
* Download an item's attachments
* Limit searches to a single vault and/or collection to prevent shoulder-surfing
* View an item in a separate window to copy/paste multiple fields easily

---

<a name="options"></a>
## Options

### Bitwarden user

Your Bitwarden email address.

### Login method

Choose whether to prompted for your *Password* or to use an *API Key* to login.  *SSO* is not yet supported.

### Client ID and Client Secret

These are the *Client ID* and *Client Secret* used for *API Key* logins.  They are ignored when using the *Password* login method.  See [Personal API Key for CLI Authentication](https://bitwarden.com/help/personal-api-key/) for more information.

### Two-step login method

Choose *Authenticator app*, *YubiKey OTP*, or *Email*.  *FIDO2* and *Duo* are not supported by the CLI.  This is ignored when using the *API Key* login method.  See [Two-step Login Methods](https://bitwarden.com/help/setup-two-step-login/) for more information.

### Downloads Folder

Where to save attachments downloaded from your vault.  The default is your Downloads folder.  If you leave this blank, Bitwarden Accelerator will ask you to choose a folder each time.

### Clipboard time

How many seconds Bitwarden Accelerator will keep your password (or other field) in the clipboard.  Afterwards, the previous contents of the clipboard are restored.

### Sync Interval

Bitwarden Accelerator will sync your vault when you load the worfklow if it has not been synced in this many minutes.

### Notifications

Uncheck this to keep Bitwarden Accelerator from displaying a notification when copying your password (or other field) to the clipboard.

---

<a name="invoking"></a>
## Invoking

There are two ways to invoke Bitwarden Accelerator.

1. Using the keyword ***bw*** will provide a list of operations.  The list depends on whether you are logged into or logged out of Bitwarden, and whether your vault is locked or unlocked.
2. Typing the ***hotkey*** will start a search of your vault.  This is the same as choosing the **Search Vault** operation from the main menu.

The default hotkey is ***Control-Command-L***, because the Bitwarden browser extension uses *Shift-Command-L*.  If you wish to change or disable the hotkey, open the workflow in *Alfred Preferences*.  The hotkey trigger is in the top-left corner.

---

<a name="mainMenu"></a>
## Main Menu

The options you see in the main menu depend on the state of your vault.

### Unauthenticated

If you are completely logged out of Bitwarden, you will see two options.

* **Login to Bitwarden**
* **Configure Workflow**

### Vault is locked

If you are logged in, but your vault is locked, you will see three options.

* **Unlock vault**
* **Logout of Bitwarden**
* **Configure Workflow**

### Vault is unlocked

If your vault is unlocked, you will see many options.

* **Search Vault**

Copy an item's password (or other field) to the clipboard.  Use these modifiers to copy other fields instead of the password.


	Control		Username
	Shift		TOTP code
	Command		Notes

	Option		Opens a new menu with additional actions
	Fn		Show all fields in a dialog window

If your web browser is the front-most window, items that match the current tab's hostname will be listed first.

    Safari
    Firefox (see footnote)
    Chrome
    Edge
    Opera
    Brave
    Vivaldi

Favorited items will be listed next, followed by all items that match your search.

* **Search Folders**

Shows a list of all the folders in your vault, then searches your vault for items in that folder.

* **Lock Vault**

Locks your Bitwarden vault.

* **Set Default Vault**

Filter searches to a specific *Vault* (Organization), *My Vault*, or All Vaults.  Note that changing this setting will revert *Default Collection* to *All Collections*.

* **Set Default Collection**

Filter searches to a specific *Collection*, or *All Collections*.

* **Sync Vault**

Tells the Bitwarden server to synchronize your vault now.

* **Configure Workflow**

Opens *Alfred Preferences* to the Bitwarden Accelerator configuration screen.

---

<a name="moreMenu"></a>
## More Menu

**Move item to a Folder**

Moves the item to the Folder you select and syncs your vault.

**Mark/Unmark Favorite**

Marks or unmarks the item as a *Favorite* and syncs your vault.

**Download Attachments**

If an item has attachments, this will show you a list with their names and sizes.  Select one to save that attachment to the *Downloads Folder*.

**Delete Item**

Deletes the item from your vault.

You will get a warning that **THIS ACTION CANNOT BE UNDONE**.  This is not technically true; the item is moved to your vault's ***Trash***.  However, Bitwarden Accelerator *does not support* recovering items from your vault's Trash.

---
* *Bitwarden Accelerator makes extensive use of [jq](https://jqlang.github.io/jq/).  If the [Bitwarden CLI](https://bitwarden.com/help/cli/) or [jq](https://jqlang.github.io/jq/) package is not installed, Bitwarden Accelerator will ask to install it using [Homebrew](https://brew.sh) or [MacPorts](https://ports.macports.org/).  [Homebrew](https://brew.sh) or [MacPorts](https://ports.macports.org/) must already be installed.*
* *Integration with Firefox requires the [Alfred Integration extension](https://addons.mozilla.org/en-US/firefox/addon/alfred-launcher-integration) and [alfred-firefox workflow](https://github.com/deanishe/alfred-firefox/releases/latest).*
