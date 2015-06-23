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

# For fleecing, saving intermediate data to the /var/www/miq/vmdb/data/metadata
# directory doesn't seem to work reliably through shared folders. To fix this,
# create a local directory for the metadata and create a symbolic link to it.
[[ -d $LOCAL_METADATA_DIR ]] || mkdir -p $LOCAL_METADATA_DIR
[[ -d $MIQ_DIR/vmdb/data ]] || mkdir -p $MIQ_DIR/vmdb/data
[[ -d $MIQ_DIR/vmdb/data/metadata && ! -L $MIQ_DIR/vmdb/data/metadata ]] && rmdir $MIQ_DIR/vmdb/data/metadata
ln -f -s $LOCAL_METADATA_DIR $MIQ_DIR/vmdb/data/metadata

# We don't want logs written to our source tree.
echo "**** Creating link to local log directory..."
[[ -d $LOCAL_LOG_DIR ]] || mkdir -p $LOCAL_LOG_DIR
[[ -d $MIQ_DIR/vmdb/log && ! -L $MIQ_DIR/vmdb/log ]] && rmdir $MIQ_DIR/vmdb/log
ln -f -s $LOCAL_LOG_DIR $MIQ_DIR/vmdb/log
echo "**** Run: git update-index --assume-unchanged vmdb/log/.gitkeep on MAC."

# We don't want compiled assets written to our source tree.
# XXX this doesn't work because rake evm:compile_assets removes the link.
[[ -d $LOCAL_ASSETS_DIR ]] || mkdir -p $LOCAL_ASSETS_DIR
[[ -d $MIQ_DIR/vmdb/public/assets && ! -L $MIQ_DIR/vmdb/public/assets ]] && rm -rf $MIQ_DIR/vmdb/public/assets
ln -f -s $LOCAL_ASSETS_DIR $MIQ_DIR/vmdb/public/assets

cd $MIQ_DIR/vmdb || exit 1

# Update gems.
echo "**** Updating gems..."
bundle install --without qpid:metric_fu || exit 1
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
