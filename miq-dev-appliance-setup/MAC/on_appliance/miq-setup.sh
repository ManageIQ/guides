#!/bin/bash

. $(dirname $_)/defines.sh

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

# Use the v2_key that's in the new source tree.
bundle exec ./tools/fix_auth.rb --invalid smartvm --v2
bundle exec ./tools/fix_auth.rb --invalid smartvm --databaseyml

exit 0
