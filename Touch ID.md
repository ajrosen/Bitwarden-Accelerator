# Using Touch ID with Bitwarden Accelerator

Bitwarden Accelerator can use Touch ID to unlock your vault, instead of asking for your master password.  It uses the *sudo* command to authenticate with Touch ID, and stores your master password in a secure location.

The next time you unlock your vault the workflow will use *sudo* to read your master password from that secure location.

## The secure location

When using Touch ID, Bitwarden Accelerator stores your master password in a file in root's home directory.  This file can be read by local Admin users **only**.

## Configuring sudo

By default, macOS does not use Touch ID for sudo.  Bitwarden Accelerator must make two changes to enable it.  It will do this automatically after you enable the option in the workflow, the next time you unlock your vault.

### pam_tid.so

*pam_tid.so* is the [Pluggable Authentication Module](https://en.wikipedia.org/wiki/Pluggable_Authentication_Module) that allows you to authenticate with Touch ID instead of your system password.  It is enabled in **/etc/pam.d/sudo_local**.

    auth       sufficient     pam_tid.so

### timestamp_type

Sudo manages active *sessions*.  If you use sudo during an active session you are not asked for your password.  The default session policy is *tty*, which creates a separate session for each terminal that has authenticated.

Each time the workflow is activated a new "terminal" is created.  Therefore, you would need to authenticate every time you invoked Bitwarden Accelerator.

The *global* session policy creates a single session for your login. This allows Bitwarden Accelerator to require authentication once, for as long as your vault is unlocked.

The *timestamp_type* option is added to **/etc/sudoers.d/sudoers** for your local account only.

    Defaults: <your_username>	timestamp_type = global
