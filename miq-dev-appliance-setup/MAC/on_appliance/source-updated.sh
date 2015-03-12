#!/bin/bash

. $(dirname $_)/defines.sh

# Create link to NetApp library Ruby bindings.
# cd $MIQ_DIR/lib/NetappManageabilityAPI/NmaCore || exit 1
# [[ -d lib && ! -L lib ]] && rm -rf lib
# [[ -L lib ]] && rm -f lib
# ln -f -s $MIQ_SAV_DIR/lib/NetappManageabilityAPI/NmaCore/lib lib

# Create link to MiqBlockDevOps.so
cd $MIQ_DIR/lib/disk/modules || exit 1
[[ -L MiqBlockDevOps.so ]] && rm -f MiqBlockDevOps.so
ln -f -s $MIQ_SAV_DIR/lib/disk/modules/MiqBlockDevOps.so MiqBlockDevOps.so

cd $MIQ_DIR/vmdb || exit 1

# Update gems.
echo "**** Updating gems..."
bundle update || exit 1
echo "**** done."
echo

# Precompile assets
echo "**** Precompiling assets..."
rake evm:compile_assets || exit 1
echo "**** done."
echo

# Migrate the database.
echo "**** Migrateing the database..."
bin/rake db:migrate || exit 1
echo "**** done."
echo

exit 0
