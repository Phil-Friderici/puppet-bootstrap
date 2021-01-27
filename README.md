# mySociety Server Bootstrap

![Run PDK tests](https://github.com/mysociety/puppet-bootstrap/workflows/Run%20PDK%20tests/badge.svg)

This Puppet module is used to bootstrap a server ready for integration
into mySociety's infrastructure. It is not intended for use beyond
mySociety but may contain examples, patterns, etc that are of interest.

## Usage

The primary point of interaction is the main `bootstrap` class. The only
other public class currently provided is `bootstrap::ec2`.

As this module configures sensitive things, it does not contain all the
necessary data to be used directly. Specifically:

* SSH keys for the `maint` user (via `maint_public_ssh_key` and `maint_private_ssh_key`)
* Server SSH keys to globally trust (via `ssh_keys`)
* SSH keys to add to the `root` user's `authorized_keys` file (via `root_auth_keys`)

This data can be provided directly from Hiera or via a profile class.

### EC2

#### The ec2 class

The `bootstrap::ec2` class sets up a simple `systemd` service that registers
the instance in our dynamic ec2.mysociety.org zone. To do this, it needs
the details of the TSIG key for authenticating the update, provided to the
`ddns_key` parameter:

```
class { '::bootstrap::ec2':
  ddns_key => {
    'algorithm' => 'hmac-sha512',
    'secret'    => '5up3r53c43t',
  },
}
```

This should be applied before attempting to apply the core module to any new
EC2 instance.

#### Provisioning an EC2 instance

This module also includes an example plan, `bootstrap::ec2`, for use with
Puppet Bolt. This is intended to be applied to EC2 instances based on the
official Debian FAI AMIs and get them ready for full integration with our
platform.

The plan will return the public SSH key generated for the root user, the
public IP and fully-qualified domain name of the instance.

You could run this from a control repository containing the required
secrets with a command something like this:

```
bolt plan run bootstrap::ec2 \
  --user admin \
  --run-as root \
  --private-key ~/.ssh/my-aws-key.pem \
  --nodes 52.1.2.3
```
