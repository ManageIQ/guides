
# External Authentication Software Installation

This document identifies the RPM packages that need to get
installed on an Appliance to allow it to be configured
for External Authentication (httpd).

<br>
<hr>
## RPM Package Installation

<br>
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

Then proceed with installation of the packages as follows:


```sh
  yum install c-ares
  yum install ipa-client
  yum install sssd-dbus
  yum install mod_intercept_form_submit mod_authnz_pam mod_lookup_identity
  yum install security-httpd-dbus-sssd*
```

\* ***Note***:  Only needed for CentOS 6.5, will no longer be needed on CentOS 6.6 and later. The RPM package name shown here might change by the time the feature is introduced.

<br>
<hr>
Back to [External Authentication](../external_auth.md)
