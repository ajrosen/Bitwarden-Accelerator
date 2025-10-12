# Using Touch ID with Bitwarden Accelerator

Bitwarden Accelerator can use Touch ID to unlock your vault instead of asking for your master password.  It leverages the *sudo* command to authenticate with Touch ID, and stores your master password in a secure location.

The next time you unlock your vault, the workflow will use *sudo* to read your master password from that secure location.

## The secure location

When using Touch ID, Bitwarden Accelerator stores your master password in a file in root's home directory.  This file can be read by local Admin users **only**.

## Configuring sudo

By default, macOS does not use Touch ID for sudo.  Two changes must be made to enable it.  Bitwarden Accelerator will try to do this automatically after you enable the Touch ID option in the workflow, the next time you unlock your vault.

<img width="372" alt="Configure sudo" src="https://github.com/user-attachments/assets/b74880ce-337c-46cd-954f-625c55366034" />

If Bitwarden Accelerator fails to configure sudo, you can make the changes manually.  You will need to use the command line.

## Manually configuring sudo

Using the command line, you can perform the same steps that Bitwarden Accelerator attempts to enable Touch ID for the workflow.  At the end is a complete list of commands that you can copy and paste into a _Terminal_ application.

1. Open the **Terminal** application and become root by running this command:

    `sudo -i`

1. Create or edit `/etc/pam.d/sudo_local`

	The file needs to include this line:

	`auth	sufficient	pam_tid.so`

1. Create or edit `/etc/sudoers.d/sudoers`

	The file needs to include this line:

	`Defaults: USERNAME timestamp_type = global`

	Be sure to replace `USERNAME` with your username.  You can find your username by running `whoami` from the command line (as yourself).

1. Set ownership and permissions

	You may get errors if these two files do not have the correct owner and permissions.  Run these commands from the command line (as root):

	```
	chown root /etc/pam.d/sudo_local /etc/sudoers.d/sudoers
	chmod 644 /etc/pam.d/sudo_local /etc/sudoers.d/sudoers
	```

1. Test

	Run these commands from the command line (as yourself):

	```
	sudo -K
	sudo whoami
	```

	If the changes were successful, you will be prompted for Touch ID, and you will see `root` in the terminal.

### The TL;DR version

Copy and paste these commands into your terminal.  If the changes are successful, you will be prompted for your password at the beginning, then prompted for Touch ID at the end.  The last command, `sudo whoami`, will show `root`.


```
sudo -i
mkdir -p /etc/pam.d /etc/sudoers.d
touch /etc/pam.d/sudo_local /etc/sudoers.d/sudoers
echo "auth sufficient pam_tid.so" >> /etc/pam.d/sudo_local
echo "Defaults: ${SUDO_USER} timestamp_type = global" >> /etc/sudoers.d/sudoers
chmod 644 /etc/pam.d/sudo_local /etc/sudoers.d/sudoers
exit
sudo -K
sudo whoami
```

<img width="260" alt="prompt for Touch ID" src="https://github.com/user-attachments/assets/354c1530-7cbc-4841-8c3d-e0279377a44d" />

## TIL

What do these changes do?

### pam_tid.so

*pam_tid.so* is the [Pluggable Authentication Module](https://en.wikipedia.org/wiki/Pluggable_Authentication_Module) that allows you to authenticate with Touch ID instead of your system password.

### timestamp_type

Sudo manages active *sessions*.  If you use sudo during an active session you are not asked for your password.  The default session policy is *tty*, which creates a separate session for each terminal that has authenticated.

Each time the workflow is activated a new "terminal" is created.  Therefore, you would need to authenticate every time you invoked Bitwarden Accelerator.  The *global* session policy creates a single session for your login.  This allows Bitwarden Accelerator to require authentication only once, for as long as your vault is unlocked.
