# Development with an OIDC server

This document describes the steps needed to enable External Authentication (httpd),
running an OIDC server and Apache on a local development setup.

1. Ensure you have the [guides](https://github.com/ManageIQ/guides) repo cloned locally, then `cd guides/external_auth`

2. Launch KeyCloak

   ```sh
   docker run --rm --name keycloak \
     -p 8443:8443 \
     -v $(pwd)/certs:/etc/x509/https \
     -v $(pwd)/realms:/tmp/realms \
     -e JAVA_OPTS="-Dkeycloak.profile.feature.scripts=enabled -Dkeycloak.profile.feature.upload_scripts=enabled" \
     -e KEYCLOAK_IMPORT=/tmp/realms/ManageIQ-realm.json \
     -e KEYCLOAK_USER=admin \
     -e KEYCLOAK_PASSWORD=smartvm \
     -e DB_VENDOR=h2 \
     quay.io/keycloak/keycloak:12.0.4
   ```

   When it completes startup, go to `https://127.0.0.1.nip.io:8443` and login with `admin` / `smartvm` to verify it's working. You should see a realm for `ManageIQ`.

3. Launch the httpd container

   ```sh
   docker run --rm -it --name httpd \
     -p 80:80 \
     -v $(pwd)/oidc-httpd-configs:/etc/httpd/conf.d \
     -e HTTPD_AUTH_OIDC_CLIENT_ID=manageiq-oidc-client \
     -e HTTPD_AUTH_OIDC_CLIENT_SECRET=3167ae6f-762d-49cd-b246-ef8856315957 \
     -e HTTPD_AUTH_HOST=127.0.0.1.nip.io \
     --add-host=127.0.0.1.nip.io:192.168.65.2 \
     manageiq/httpd:latest
   ```

4. Launch ManageIQ

   Run your Rails server as you normally would for development, however, instead of accessing via the browser at `https://localhost:3000`, use `http://127.0.0.1.nip.io` (notice `http` as opposed to `https`).

   If ManageIQ is not yet configured for OIDC, do the following:

   1. Login as `admin` / `smartvm`
   2. Go to `Settings` -> `Application Settings` -> `Authentication`
   3. Change the following:

      | | |
      |-|-|
      | Mode                  | `External (httpd)` |
      | Enable Single Sign-On | checked |
      | Provider Type         | `Enable OpenID-Connect` |
      | Get User Groups from External Authentication (httpd) | checked |

   4. Logout
   5. Click `Log In to Corporate System`

## Updating KeyCloak data

### Export data from a running KeyCloak

If you've made changes in KeyCloak that you'd like to save, leave KeyCloak running and in another terminal run:

```sh
docker exec -it keycloak /opt/jboss/keycloak/bin/standalone.sh \
  -Djboss.socket.binding.port-offset=100 \
  -Dkeycloak.migration.action=export \
  -Dkeycloak.migration.provider=singleFile \
  -Dkeycloak.migration.realmName=ManageIQ \
  -Dkeycloak.migration.usersExportStrategy=REALM_FILE \
  -Dkeycloak.migration.file=/tmp/realms/ManageIQ-realm.json
```

When it completes, `Ctrl-C` to end the process and the `realms/ManageIQ-realm.json` file will be updated.

### Recreating KeyCloak setup from scratch

1. Ensure you have a `certs` directory and `realms` directory

   ```sh
   mkdir certs
   mkdir realms
   ```

2. Generate a cert and key

   ```sh
   openssl req -x509 -newkey rsa:4096 -keyout certs/tls.key -out certs/tls.crt -days 3650 -nodes
   ```

3. Launch KeyCloak

   ```sh
   docker run --rm --name keycloak \
     -p 8443:8443 \
     -v $(pwd)/certs:/etc/x509/https \
     -v $(pwd)/realms:/tmp/realms \
     -e KEYCLOAK_USER=admin \
     -e KEYCLOAK_PASSWORD=smartvm \
     -e DB_VENDOR=h2 \
     quay.io/keycloak/keycloak:12.0.4
   ```

4. Go to `https://127.0.0.1.nip.io:8443` and login with `admin` / `smartvm`

5. Create a Realm

   | | |
   |-|-|
   | Name | `ManageIQ` |

   **Note**: realm name is case-sensitive in URLs!

6. Create an OIDC Client

   | | |
   |-|-|
   | Client ID       | `manageiq-oidc-client` |
   | Client Protocol | `openid-connect` |

   Once created, go to the credentials tab and copy down the generated `Secret` value.

7. Configure the OIDC Client

   1. Settings

      | | |
      |-|-|
      | Access Type              | `confidential` |
      | Service Accounts Enabled | `ON` |
      | Authorization Enabled    | `ON` |
      | Valid Redirect URIs      | `http://127.0.0.1.nip.io/*` |

   2. Mappers -> Create

      | | |
      |-|-|
      | Name             | `groups` |
      | Mapper Type      | `Group Membership` |
      | Token Claim Name | `groups` |
      | Full group path  | `OFF` |

8. Create a group

   | | |
   |-|-|
   | Name | `EvmGroup-super_administrator` |

9. Create a user

   | | |
   |-|-|
   | Name           | `user1` |
   | Email          | `user1@manageiq.org` |
   | First Name     | `User` |
   | Last Name      | `One` |
   | Email Verified | `ON` |

10. Configure the user

    1. Credentials

       | | |
       |-|-|
       | Password              | `smartvm` |
       | Password Confirmation | `smartvm` |
       | Temporary             | `OFF` |

    2. Groups

       Put the user into a group by clicking the group, then clicking `Join`.

11. Verify the setup

    Be sure you have your OIDC client secret from step 6. `${client_secret}` below is a reference to that value. The client secret value from the current ManageIQ Realm export is `3167ae6f-762d-49cd-b246-ef8856315957`.

    1. Fetch the configuration

       ```sh
       curl -s -k https://127.0.0.1.nip.io:8443/auth/realms/ManageIQ/.well-known/openid-configuration | jq
       ```

    2. Get an access token

       ```sh
       token=$(curl -s -k -X POST https://127.0.0.1.nip.io:8443/auth/realms/ManageIQ/protocol/openid-connect/token \
         -H "Content-Type: application/x-www-form-urlencoded" \
         -u manageiq-oidc-client:${client_secret} \
         -d username=user1 \
         -d password=smartvm \
         -d grant_type=password | jq -r ".access_token")
       ```

    3. Introspect the access token

       ```sh
       curl -s -k -X POST https://127.0.0.1.nip.io:8443/auth/realms/ManageIQ/protocol/openid-connect/token/introspect \
         -H "Content-Type: application/x-www-form-urlencoded" \
         -u manageiq-oidc-client:${client_secret} \
         -d "token=${token}" | jq
       ```

12. Export the realm file. If you plan to commit this, be sure to also update the client secret values in this documentation.
