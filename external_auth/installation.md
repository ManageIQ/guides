
# External Authentication Software Installation

This document identifies the RPM packages to install on an
Appliance to be able to use External Authentication (httpd).

---
## RPM Package Installation

Before installing the IPA Client and necessary modules, define
the following YUM repository on the CentOS based Appliance:

```
[adelton-identity_demo]
name=Copr repo for identity_demo
baseurl=http://copr-be.cloud.fedoraproject.org/results/adelton/identity_demo/epel-6-$basearch/
skip_if_unavailable=True
gpgcheck=0
enabled=1
```

Then, proceed with installation of the packages as follows:


```sh
yum install c-ares
yum install ipa-client
yum install sssd-dbus
yum install mod_intercept_form_submit mod_authnz_pam mod_lookup_identity
yum install mod_lookup_identity-selinux
```

***Note***:  *mod_lookup_identity-selinux* is only needed for CentOS 6.5. It will not be needed on CentOS 6.6 and later.

---
Back to [External Authentication](../external_auth.md)
