# Bitwarden Accelerator

Interact with [Bitwarden CLI](https://bitwarden.com/help/cli/).

---

## Table of Contents

* [Key Features](#features)
* [Installing](#installing)
* [Options](#options)
* [Invoking](#invoking)
* [Main Menu](#mainMenu)
* [Item List](#itemList)
* [More Menu](#moreMenu)
* [Managing favorites icons](#faviconsMenu)
* [Reporting Bugs](#bugs)

---

<a name="features"></a>
## Key Features

#### Logging in

* Login with username and password, or API Key
* Two-step logins with Authenticator app, YubiKey OTP, or Email
* Activity timeout to logout or lock your vault

#### Selecting items

* Recently selected item is listed first
* Automatically searches for the active browser tab's domain name
* Favorite items are indicated with a ❤️
* Search different fields of an item
	* Any item by its name or folder
	* Logins by username or URL
	* Cards by brand (eg., search for "Visa")
	* Identities by any field in the item


#### Adding items

* Add new login items to your vault

#### Selecting fields

* Copy username, password, TOTP code, or notes to the clipboard
* Copy TOTP code instead of password if called shortly after copying an item's password

#### Editig fields

* Edit an item's username, password, or name without leaving Alfred

#### Miscellaneous

* Download an item's attachments
* Limit searches to a single vault and/or collection to prevent shoulder-surfing
* View any item in a separate window to copy/paste multiple fields easily
* View any item's fields within Alfred when using a [Universal Action](https://www.alfredapp.com/universal-actions/)
* (Optional) Automatically sync vault in the background using a macOS Launch Agent
* (Optional) Display each item's favorites icon

---

<a name="installing"></a>
## Installing

1. Download the workflow <a href="https://github.com/ajrosen/Bitwarden-Accelerator/releases/latest/download/Bitwarden.Accelerator.alfredworkflow">here</a>
2. Open the downloaded file to add it to Alfred
3. Install the *Bitwarden CLI*<sup>(1)</sup> from the [Bitwarden website](https://bitwarden.com/help/cli/), with `brew install bitwarden-cli`, or with `port -N install bitwarden-cli`.
4. Install *jq*<sup>(2)</sup> from from the [website](https://jqlang.github.io/jq/download/), with `brew install jq`, or with `port -N install jq`.

---

<a name="options"></a>
## Options

### Bitwarden user

Your Bitwarden email address.

### Auto Sync

Installs a macOS *Launch Agent* that automatically syncs your vault every *Sync Interval* minutes.

### Login method

Choose whether to be prompted for your *Password* or use an *API Key* to login.  *SSO* is not yet supported.

### Client ID and Client Secret

These are the *Client ID* and *Client Secret* used for *API Key* logins.  They are ignored when using the *Password* login method.  See [Personal API Key for CLI Authentication](https://bitwarden.com/help/personal-api-key/) for more information.

### Two-step login method

Choose *Authenticator app*, *YubiKey OTP*, or *Email*.  *FIDO2* and *Duo* are not supported by the CLI.  This is ignored when using the *API Key* login method.  See [Two-step Login Methods](https://bitwarden.com/help/setup-two-step-login/) for more information.

### Favorites icon service

Choose a service to download favorites icons.  The default is ***None***; Bitwarden Accelerator will continue to show the default icon for all login items.

If you choose a service, icons will be downloaded in the background.  You can continue to use Bitwarden Accelerator while the icon cache is being populated.

N.B. The icon cache is removed when Bitwarden Accelerator's version changes.  Icons will be redownloaded the next time you list items in your vault.

### Vault timeout

How long Bitwarden can be inactive before timing out. *Inactivity* is determined by the time since invoking the workflow.

### Custom timeout

Sets the timeout value when *Vault timeout* is *Custom*.

### Vault timeout action

What Bitwarden will do once the vault timeout is reached.  Choices are **Lock vault** and **Logout**.

### Bitwarden server

The Bitwarden server hosting your vault.  The default is *bitwarden.com*, the US server.

### Downloads Folder

Where to save attachments downloaded from your vault.  The default is your Downloads folder.  If you leave this blank, Bitwarden Accelerator will ask you to choose a folder each time.

### Clipboard time

How many seconds Bitwarden Accelerator will keep your password (or other field) in the clipboard.  Afterwards, the previous contents of the clipboard are restored.

### Sync Interval

Bitwarden Accelerator will sync your vault when you load the worfklow if it has not been synced in this many minutes.

### Notifications

Uncheck this to keep Bitwarden Accelerator from displaying a notification when copying your password (or other field) to the clipboard.

### Workflow Keyword

Keyword used to bring up Bitwarden Accelerator's main menu

### Search Keyword

Keyword used to bring up Bitwarden Accelerator's search menu

### Trash Keyword

Keyword used to search deleted items

---

<a name="invoking"></a>
## Invoking

There are three ways to invoke Bitwarden Accelerator.

1. Using the Workflow Keyword (default: ***bw***) will provide a list of operations.  The list depends on whether you are logged into or logged out of Bitwarden, and whether your vault is locked or unlocked.
2. Typing the ***hotkey*** will start a search of your vault.  This is the same as choosing the **Search Vault** operation from the main menu.
3. As a Universal Action, you can view an item's fields directly in Alfred.

The default hotkey is ***Control-Command-L***, because the Bitwarden browser extension uses *Shift-Command-L*.  If you wish to change or disable the hotkey, open the workflow in *Alfred Preferences*.  The hotkey trigger is in the top-left corner.

### Trash

Using the Trash Keyword (default: ***.bwtrash***) will list any deleted items.  Select an item to restore it.

---

<a name="mainMenu"></a>
## Main Menu

The options you see in the main menu depend on the state of your vault.

### Unauthenticated

If you are completely logged out of Bitwarden, you will see two options.

* **Login to Bitwarden**

Log into Bitwarden, with your vault *locked*.

* **Configure Workflow**

Opens *Alfred Preferences* to the Bitwarden Accelerator configuration screen.

### Vault is locked

If you are logged in, but your vault is locked, you will see three options.

* **Unlock vault**

Unlocks your vault.

* **Logout of Bitwarden**

Locks your vault and logs out of Bitwarden.

* **Configure Workflow**

Opens *Alfred Preferences* to the Bitwarden Accelerator configuration screen.

### Vault is unlocked

If your vault is unlocked, you will see many options.

* **Search Vault**

Lists all items in your vault.

* **Search Folders**

Shows a list of all the folders in your vault, then searches your vault for items in the selected folder.


* **Add item**

Adds a new login item to your vault.  You will be prompted for the item's *Name*, *Username*, and *Password*.

If your web browser is the front-most window, the default *Name* will be the active tab's domain name.

The default *Username* will be your Bitwarden email address.

The default *Password* will be a random password generated by Bitwarden.  It is 20 characters and includes uppercase letters, lowercase letters, numbers, and special characters.

* **Lock Vault**

Locks your Bitwarden vault.

* **Set Default Vault**

Filter searches to a specific *Vault* (Organization), *My Vault*, or All Vaults.  Or, set the default Organization for future searches with the Command modifier on the next screen.

Note that changing this setting with the Command modifier will also revert *Default Collection* to *All Collections*.

* **Set Default Collection**

Filters searches to a specific *Collection*, or *All Collections*.  Or, set the default Collection for future searches with the Command modifier on the next screen.

* **Sync Vault**

Tells the workflow to synchronize your vault now.

* **Logout of Bitwarden**

Locks your vault and logs out of Bitwarden.

* **Manage favorites icons**

Opens a [new menu](#faviconsMenu) to manage the favorites icons cache.

* **Configure Workflow**

Opens *Alfred Preferences* to the Bitwarden Accelerator configuration screen.

---

<a name="itemList"></a>
## Item List

All items in your vault are shown, sorted by each item's *name*.  If your web browser is the front-most window, items that match the current tab's domain will be listed first.  Favorited items will be listed next, followed by all remaining items.

Supported browsers:

* [Safari](https://www.apple.com/safari/)
* [Firefox](https://www.mozilla.org/)<sup>(3)</sup>
* [Firefox Developer Edition](https://www.mozilla.org/en-US/firefox/developer/)<sup>(3)</sup>
* [Chrome](https://www.google.com/chrome/)
* [Edge](https://www.microsoft.com/edge)
* [Opera](https://www.opera.com/)
* [Brave](https://brave.com/)
* [Vivaldi](https://vivaldi.com/)
* [Ghost](https://ghostbrowser.com/)
* [Arc](https://arc.net/)
* [Zen](https://zen-browser.app/)<sup>(3)</sup>

The default behavior when selecting an item depends on its *type*.

* **Logins**

Copy a login item's password to the clipboard.  Use these modifiers to copy other fields instead.

	Control			Username
	Shift			TOTP code
	Command			Notes

	Option			Opens a new menu with additional actions
	Fn			Show all fields in a dialog window

	Control + Command	Open URL in your default browser
	Command + Option	View all fields in Alfred

*Automatic field rotation*

When selecting the *same* login item within *Sync Interval* seconds, and the *password* was the last field copied, the *TOTP code* will be copied to the clipboard instead of the password.

* **Secure notes**

The note is copied to the clipboard, as if the *Command* modifier were used.

* **Cards**
* **Identities**

All fields will be shown in a dialog window, as if the *Fn* modifier were used.

* **SSH Keys**

The private key is copied to the clipboard.

---

<a name="moreMenu"></a>
## More Menu

**Move item to a Folder**

Moves the item to the Folder you select and syncs your vault.

**Mark/Unmark Favorite**

Marks or unmarks the item as a *Favorite* and syncs your vault.

**Download Attachments**

If an item has attachments, this will show you a list with their names and sizes.  Select one to save that attachment to the *Downloads Folder*.

**Edit Item**

Lets you edit the username, password, or name of the item.

**Delete Item**

Deletes the item from your vault.

You will get a warning that **THIS ACTION CANNOT BE UNDONE**.  This is not technically true; the item is moved to your vault's ***Trash***.

---

<a name="faviconsMenu"></a>
## Managing favorites icons

The *Managing favorites icons* menu has three options.

* Delete cache

This completely removes the icons cache.  Icons will be redownloaded the next time you list items in your vault.

* Fetch icons

If there is no icons cache, Bitwarden Accelerator will automatically try to download icons using your chosen service.

You can use this menu option to refresh the icons at any time.  It will (attempt to) download any favorites icons that are missing.  Any vault item that has been modified since its icon was last downloaded will also have its redownloaded.  I.e., if a vault item is newer than the icon, fetch its icon.

* Choose icon service

This will open *Alfred Preferences* to the configuration screen.  Bitwarden Accelerator supports five services that you can use to download favorites icons.

1. Bitwarden
1. DuckDuckGo
1. Favicone
1. Google
1. Icon Horse

---

<a name="bugs"></a>
## Reporting Bugs

When reporting bugs, please include the following information:

- Version of Bitwarden Accelerator
- Version of Bitwarden CLI (`bw --version`)
- Version of jq (`jq --version`)
- What you are trying to do
  - What result you are getting
  - What result you are expecting

---
1. *If the [Bitwarden CLI](https://bitwarden.com/help/cli/) is not installed, Bitwarden Accelerator will ask to install it using [Homebrew](https://brew.sh) or [MacPorts](https://ports.macports.org/).  [Homebrew](https://brew.sh) or [MacPorts](https://ports.macports.org/) must already be installed.*
2. *macOS 15.1 (Sequoia) includes jq, so it is not neccessary to install separately.*
3. *Integration with Firefox requires the [Alfred Integration extension](https://addons.mozilla.org/en-US/firefox/addon/alfred-launcher-integration).*
