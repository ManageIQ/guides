## Ruby 2.0 developer upgrade workflow

* Install ruby 2.0.0
* Install ruby 2.1.3 for fun and because it's awesome (see allocation_stats and stackprof gems)
* Run bundle on each ruby version (sharing the same Gemfile.lock)
* Configure your shell defaults ~/.bashrc ~/.zshrc and friends to use ruby 2.0.0
* Verify things work on ruby 2.0.0


## Issues

#### Mac: openssl with homebrew and ruby-install

Symptom:
openssl provided by homebrew is not found when launch ruby/bundling/etc.

```
brew upgrade ruby-install
brew install --upgrade openssl
brew unlink openssl && brew link openssl --force

# Rebuild your rubies
ruby-install ruby 1.9.3-p547
ruby-install ruby 2.0.0-p576
ruby-install ruby 2.1.3  # This is the goal...
```

#### Mac: readline (bin/rails c or irb)
Symptom: error when launching rails console or irb.

You may have to use `--no-install-deps` after removing readline that's in homebrew.

`ruby-install ruby 2.1.3 --no-install-deps`

See: https://github.com/postmodern/ruby-install/issues/144


#### Mac: 'couldn't understand kern.osversion `14.0.0' on OSX Yosemite' building ruby/gems

For example:

```
compiling num2int.c
couldn't understand kern.osversion `14.0.0'
num2int.c: In function ‘print_num2ll’:
num2int.c:82: error: expected ‘)’ before ‘PRI_LL_PREFIX’
num2int.c:82: warning: spurious trailing ‘%’ in format
num2int.c:82: warning: spurious trailing ‘%’ in format
num2int.c: In function ‘print_num2ull’:
num2int.c:94: error: expected ‘)’ before ‘PRI_LL_PREFIX’
num2int.c:94: warning: spurious trailing ‘%’ in format
num2int.c:94: warning: spurious trailing ‘%’ in format
make[2]: *** [num2int.o] Error 1
make[1]: *** [ext/-test-/num2int/all] Error 2
make: *** [build-ext] Error 2
!!! Compiling ruby 2.0.0-p576 failed!
```

Try the folllowing links:

* https://github.com/sstephenson/ruby-build/issues/654
* https://github.com/ffi/ffi/issues/347
* http://www.zlu.me/gcc/ruby/yosemite/2014/08/28/yosemite-gcc-woe.html


#### Linux: build a ruby shared library (libruby.so)

`ruby-install ruby 2.0.0 -- --enable-shared`

`--enable-shared` is important otherwise you won't get libruby.so and won't be able to build the shared objects


#### Upgrading an existing 2.0.0 or 1.9.3 to a new patch release

Note: ruby 2.1 and newer use semantic versioning and don't have this issue.

If you install a gem, bundler, on one ruby major version, say 2.0.0-p353, and then install 2.0.0-p576, uninstall the p353 ruby, running `bundle` will fail.

Any gems installed on the old ruby will have binstubs that point to the old removed ruby.  This is because ruby-install shares gems for all major versions (2.0.0-p353 and 2.0.0-p576 share gems) and the rubygems binstubs point to the old removed ruby.  To fix the binstubs:

See https://github.com/rubygems/rubygems/issues/1049

```
gem update --system
gem install bigdecimal -v1.1.0
gem install io-console -v0.3
gem install json -v1.5.5
gem install minitest -v2.5.1
gem install rake -v0.9.2.2
gem install rdoc -v3.9.5
gem pristine --all --only-executables
```

#### If you use a config/database.pg_dev.yml variant

ruby 2.0 changed SOMETHING in erb scoping which could cause the migration specs to not work locally because it's trying to shell out using the vmdb_test database instead of vmdb_test_master.

This happens because line 4 below is normally db_suffix = ...
Since the $db_yml_loaded is set once, any re-entry into the database.yml in the same process
would cause db_suffix to be nil.  Changing it to $db_suffix made it global and would be kept.

```
# <% unless $db_yml_loaded %>
# <%   $db_yml_loaded = true %>
# <%   evm_version = File.read(File.join(Rails.root, 'VERSION')).chomp rescue '9.9.9.9' %>
# <%   $db_suffix = (evm_version == '9.9.9.9') ? '' : "_#{evm_version.split('.')[0..2].join('_')}" %>
# <%   c = YAML.load_file(Rails.root.join("config", "database.yml"))[Rails.env] %>
# <%   c.keys.each { |k| c[k] = ERB.new(v = c[k], nil, nil, 'v').result(binding).lines.first if c[k].is_a?(String) } %>
# <%   puts "** EVM v#{evm_version}; Database: adapter=#{c["adapter"]}, name=#{c["database"]}, host=#{c["host"]}" %>
# <% end %>
```
