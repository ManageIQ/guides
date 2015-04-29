
# External Authentication (httpd)

This document describes the steps needed to enable External
Authentication (httpd) on the Appliance against an IPA Server.

Once external authentication is enabled, users will be able
to login to the Appliance using their IPA Server credentials.
User accounts will be automatically created on the Appliance
and relevant information imported from the IPA Server. 

To allow IPA server defined users to login to the Appliance,
they must be members of at least one group on the IPA server
which needs to be defined in the Appliance under
*Configure->Configuration->Access Control->Groups* with the
appropriate role assigned to that group.

The Appliance comes pre-loaded with the necessary IPA Client
software to be able to connect to the IPA Server. The software
is just not configured by default.

Enabling External Authentication is done by first enabling it
in the Appliance Web UI then via the Appliance Console.
Disabling External Authentication and returning to Internal
Database Authentication also needs to be done in both the
Appliance Web UI and then the Appliance Console.

---

### Appliance Requirements

* For an Appliance to leverage an IPA Server on the network,
the Appliance **must** have time synchronization enabled.
This can be done by either configuring NTP in the Appliance UI,
from *Configure->Configuration->Zone->Server->NTP Settings* or by using
the Virtual Machine's hosting provider's Advanced Setting
to Synchronize Time. Both Appliance and IPA Server must have
their clocks synchronized otherwise Kerberos and LDAP based
authentication will fail.


* The IPA Server needs to be known by DNS and accessible by name.
If DNS is not configured accordingly, the hosts files need to be
updated to reflect both IPA server and the Appliance on
both virtual machines.

---

### Configuring Appliance for External Authentication:

* Appliance UI
    1. Login to the Appliance via an administrative account
    2. Select *Configure->Configuration*
    3. Click on *Authentication*
    4. In the Authentication section, set Mode to **External (httpd)**
    5. In the Role Settings section, select the *Get User Groups from
External Authentication (https)*
    6. Click on **Save**


* Appliance Console
    1. Login via the **admin** Username
    2. Summary screen should show **External Auth** as *not configured*,
Press any key
    3. From the Advanced Setting menu, select the menu item
**Configure External Authentication (httpd)**
    4. Enter the Fully qualified Hostname of the IPA Server,
i.e. *ipaserver.test.company.com*
    5. Enter the IPA Server domain, i.e. *test.company.com*
    6. Enter the IPA Server Realm, i.e. *TEST.COMPANY.COM*
    7. Press enter to select the default IPA Server Principal, i.e. *admin*
    8. Enter the Password of the IPA Server Principal
    9. Review details, and Enter **y** to proceed.

  **Note:** If any of the following conditions are true, the Configuration will fail:

  * The IPA server is not reachable by its FQDN
  * The IPA Server cannot reach the appliance by its FQDN
  * The time is not synchronized between the Appliance and the IPA Server
  * The IPA server **admin** password specified is incorrect

---

### Configuring Appliance back to Internal Database Authentication:

* Appliance UI
    1. Login to the Appliance via an administrative account
    2. Select *Configure->Configuration*
    3. Click on *Authentication*
    4. In the Authentication section, set Mode to **Database**
    5. Click on **Save**


* Appliance Console
    1. Login via the **admin** Username
    2. Summary screen should have **External Auth** showing the fully qualified
host name of the IPA server, Press any key
    3. select the menu item **Configure External Authentication (httpd)**
    4. Configure External Authentication (httpd) would show the currently
configured IPA Server Hostname and Domain.
    5. Enter **y** to Un-Configure the IPA Client
    6. Enter **n** to not proceed with the Re-Configuration.

---

### Optional Configuration via the Appliance Console CLI

In addition to using the Appliance Console, External Authentication can be
optionally configured and un-configured via the Appliance Console Command Line Interface.

Appliance Console CLI command and relevant options include:

```sh
/bin/appliance_console_cli --host <appliance_fqdn>
                           --ipaserver <ipa_server_fqdn>
                           --ipadomain <domain_of_ipa_server>
                           --iparealm <realm_of_ipa_server>
                           --ipaprincipal <ipa_server_principal>
                           --ipapassword <ipa_server_password>
                           --uninstall-ipa
```

Note:

* specifying \-\-host will update the hostname of the appliance. If this
step was already performed via the Appliance Console and the necessary updates
made to /etc/hosts if DNS is not properly configured, the \-\-host option
can be omitted.
* \-\-ipadomain will be based on the appliance domain name if not specified.
* \-\-iparealm will be based on the domain name of the ipaserver if not specified.
* \-\-ipaprincipal will default to **admin** if not specified.

#### Configuring External Authentication Example:

```sh
$ ssh root@appliance.test.company.com
appliance# /bin/appliance_console_cli --host appliance.test.company.com \
                                      --ipaserver ipaserver.test.company.com \
                                      --ipadomain test.company.com \
                                      --iparealm TEST.COMPANY.COM \
                                      --ipaprincipal admin \
                                      --ipapassword smartvm1
```

#### Un-Configuring External Authentication Example:

```sh
$ ssh root@appliance.test.company.com
appliance# /bin/appliance_console_cli --uninstall-ipa
```

---

### Manual Configuration

The following Instructions are for informational purposes and describe how to manually install the
necessary packages and configure the External Authentication (i.e. what is currently done behind
the scene via the Appliance Console):

* Installing the required packages - [Installation](./external_auth/installation.md)
    * The packages required for enabling External Authentication are
installed by default on the Appliance so these steps are intended
to assist when building an appliance from scratch.
    * The installation instructions are targeted for the CentOS 6.x
based ManageIQ Appliance.


* Enabling External Authentication - [Configuration](./external_auth/configuration.md)
