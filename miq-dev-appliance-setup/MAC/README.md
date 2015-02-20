# Purpose

This directory contains scripts that automate the process of creating a development MIQ
appliance that will run on a MAC under VMware Fusion.

Through the use of VMware Tools shared folders, the appliance runs MIQ code residing on the MAC.
Code can then be maintained and manipulated on the MAC, and tested directly on the appliance.

Setup instructions can be found [here](setup.md).

## Subdirectories:
### on_appliance
Contains scripts that are executed on the appliance:
```bash
# Runs through all of the steps of the development conversion process in sequence.
run-all.sh <hgfs_path_to_miq_dir>
```
```bash
# Step 1: Installs software packages that are needed to build Ruby bindings
#         and install binary gems.
software-install.sh
```
```bash
# Step 2: Automates the install of VMware Tools - needed for shared folders.
vmware-tools-install.sh
```
```bash
# Step 3: Links the MIQ execution environment on the appliance to the
#         source code on the MAC.
map-source.sh <hgfs_path_to_miq_dir>
```
```bash
# Step 4: Updates gems, precompiles assets, migrates the database,
#         and updates database entries based on v2_key in source tree.
miq-setup.sh
```
```bash
# Should be run on the appliance whenever code is pulled or branches switched in the MAC.
# Recreates links, updates gems, and migrates the database.
source-updated.sh
```
Where: `<hgfs_path_to_miq_dir>` is the path to the miq directory, relative to the MAC
directory that was shared with the appliance.

For example: If the directory `/Users/my_home` was shared with the appliance, `<hgfs_path_to_miq_dir>`
would be something like `my_home/src/git/miq`.
Where: `<mac_path_to_miq_dir>` is the path of the miq directory on the MAC.

For example: `/Users/my_home/src/git/miq` or `~/src/git/miq`.
