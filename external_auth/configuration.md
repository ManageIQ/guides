
# External Authentication Configuration

This document describes the steps needed to enable External
Authentication (httpd) on the Appliance against with an IPA Server.

Once external authentication is enabled, users will be able
to login to the Appliance using their IPA Server credentials.
User accounts will be automatically created on the Appliance
and relevant information imported from the IPA Server.

The Appliance comes pre-loaded with the necessary IPA Client
software to be able to connect to the IPA Server. The software
is just not configured by default.

---
### Appliance Requirements

* For an Appliance to leverage an IPA Server on the network,
the Appliance **must** have time synchronization enabled.
This can be done by either configuring NTP in the Appliance UI,
from Configure-Configuration-Zone-Server-NTP Settings or by using
the Virtual Machine's hosting provider's Advanced Setting
to Synchronize Time. Both Appliance and IPA Server must have
their clocks synchronized otherwise Kerberos and LDAP based
authentication will fail.


* The IPA Server needs to be known by DNS and accessible by name.
If DNS is not configured accordingly, the hosts files need to be
updated to reflect both IPA server and the Appliance on
both virtual machines.

---
### Sample Domain and Systems

For the purpose of these instructions, the following
fully qualified host names and IP addresses will be used:

| Type | Host Name | IP Address |
| ---- | --------- | ---------- |
| IPA Server | ipaserver.test.company.com | 192.168.100.11 |
| Appliance  | appliance.test.company.com | 192.168.100.12 |

The IPA Server serves as the test.company.com domain
controller, Kerberos server, and as the LDAP DIT, hosting
the Root DSE dc=test,dc=company,dc=com.

---
## Configuration

### Configuring the Network

Ensure hosts are resolvable by name. If DNS is not configured,
specify the appropriate entries in the /etc/hosts on both
IPA Server and Appliance:

**/etc/hosts**

```
192.168.100.11   ipaserver.test.company.com
192.168.100.12   appliance.test.company.com
```

On the non-DNS environment, the network configuration for
the systems must reflect their FQDN.

If specifying both FQDN and Hostname in the /etc/hosts file,
make sure the FQDN comes first:

```
192.168.100.11   ipaserver.test.company.com   ipaserver
192.168.100.12   appliance.test.company.com   appliance
```


**/etc/sysconfig/network** on Appliance.

```sh
NETWORKING=yes
HOSTNAME=appliance.test.company.com
```

Then run:

```sh
hostname appliance.test.company.com
```

---
### Installing and Configuring the IPA Client Software

```sh
/usr/sbin/ipa-client-install -N \
  --realm=TEST.COMPANY.COM --domain=test.company.com   \
  --server=ipaserver.test.company.com   \
  --principal=admin --password=PASSWORD \
  --fixed-primary
```

---
### Configure SSSD

Update the SSSD configuration file /etc/sssd/sssd.conf to
define the IPA Server LDAP Domain and enable
the Apache modules for external authentication:

**/etc/sssd/sssd.conf**

* Add to the [domain/test.company.com] section:

```
[domain/test.company.com]
  ldap_user_extra_attrs = mail, givenname, sn, displayname
```

* In the [sssd] section, update the services section
to include ", ifp":

```
[sssd]
   services = nss, pam, ssh, ifp
```

* Add an [ifp] section at the end of the file:

```
[ifp]
  allowed_uids = apache, root
  user_attributes = +mail, +givenname, +sn, +displayname
```

---
### Configure PAM

Create a PAM Config file for the Appliance Apache authentication.

**/etc/pam.d/httpd-auth**

```
auth    required pam_sss.so
account required pam_sss.so
```

---
### Configure Apache

#### Create an Apache Authentication file for the Appliance

**/etc/httpd/conf.d/cfme-external-auth**

```
LoadModule authnz_pam_module modules/mod_authnz_pam.so
LoadModule intercept_form_submit_module modules/mod_intercept_form_submit.so
LoadModule lookup_identity_module modules/mod_lookup_identity.so

<Location /dashboard/authenticate>
  InterceptFormPAMService httpd-auth
  InterceptFormLogin      user_name
  InterceptFormPassword   user_password
  InterceptFormLoginSkip  admin
  InterceptFormClearRemoteUserForSkipped on
</Location>

<Location /dashboard/authenticate>
  LookupUserAttr   mail        REMOTE_USER_EMAIL
  LookupUserAttr   givenname   REMOTE_USER_FIRSTNAME
  LookupUserAttr   sn          REMOTE_USER_LASTNAME
  LookupUserAttr   displayname REMOTE_USER_FULLNAME
  LookupUserGroups             REMOTE_USER_GROUPS ":"
  LookupDbusTimeout            5000
</Location>
```

#### Update the Appliance Apache Configuration to enable External Authentication


Modify /etc/httpd/conf.d/cfme-https-application.conf as follows:

**/etc/httpd/conf.d/cfme-https-application.conf**

* add this line before the *VirtualHost* directive:

```
Include conf.d/cfme-external-auth
```

* Within the VirtualHost section, after this line:

	*RequestHeader set X_FORWARDED_PROTO 'https'*

    add the following lines:

```
RequestHeader unset X_REMOTE_USER
RequestHeader set X_REMOTE_USER           %{REMOTE_USER}e            env=REMOTE_USER
RequestHeader set X_EXTERNAL_AUTH_ERROR   %{EXTERNAL_AUTH_ERROR}e    env=EXTERNAL_AUTH_ERROR
RequestHeader set X_REMOTE_USER_EMAIL     %{REMOTE_USER_EMAIL}e      env=REMOTE_USER_EMAIL
RequestHeader set X_REMOTE_USER_FIRSTNAME %{REMOTE_USER_FIRSTNAME}e  env=REMOTE_USER_FIRSTNAME
RequestHeader set X_REMOTE_USER_LASTNAME  %{REMOTE_USER_LASTNAME}e   env=REMOTE_USER_LASTNAME
RequestHeader set X_REMOTE_USER_FULLNAME  %{REMOTE_USER_FULLNAME}e   env=REMOTE_USER_FULLNAME
RequestHeader set X_REMOTE_USER_GROUPS    %{REMOTE_USER_GROUPS}e     env=REMOTE_USER_GROUPS
```

---
### Configure SELinux

For external authentication to work with Apache through
SSSD on SELinux systems, run the following command:

```sh
setsebool -P allow_httpd_mod_auth_pam on
```

Also, on RHEL 6.5 and later as well as CentOS 6.6 and later based Appliances, run the following command:

```sh
setsebool -P httpd_dbus_sssd on
```

---
### Restart SSSD and Apache

Make sure SSSD starts upon reboot:

```sh
chkconfig sssd on
```

Restart both:

```sh
service sssd  restart
service httpd restart
```

---
Back to [External Authentication](../external_auth.md)
