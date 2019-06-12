# mySociety Server Bootstrap

This Puppet module is used to bootstrap a server ready for integration into mySociety's infrastructure.

It is not intended for use beyond mySociety but may contain examples, patterns, etc that are of interest.

## Data

The module does contain some useful defaults, although the following will need to be provided:

* SSH keys for the `maint` user (via `maint_public_ssh_key` and `maint_private_ssh_key`)
* Server SSH keys to globally trust (via `ssh_keys`)

