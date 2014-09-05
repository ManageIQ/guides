# Source Code Layout

The source code has 6 main directories
* [build](#build)
* [host](#host)
* [lib](#lib)
* [system](#system)
* [vmdb](#vmdb)

## build

Code used to build the virtual appliance.

## host

The "host" or SmartProxy is a component installed on a physical machine.  It
provides facilities to scan VMs or provide operations that are only accessible
from the physical machine.  This includes the abilities to run PowerShell
commands on Windows, to "heartbeat" to the ManageIQ server, and other features.

On VMWare, the VM scanning facilities of the standalone SmartProxy are less
important when the VMware Virtual Disk Development Kit (VDDK) is installed,
allowing remote access to virtual disks.  The standalone SmartProxy will
continue to be used for scanning other systems where the hypervisor's storage is
not accessible from the ManageIQ appliance.

Since the SmartProxy is generally used co-located with the ManageIQ server for
scanning, the PowerShell proxy is the primary remaining feature of the
standalone SmartProxy.

## lib

This directory contains libraries for

* interfacing with various clouds and infrastructure providers
  * lib/Amazon
  * lib/RedHatEnterpriseVirtualizationManagerAPI
  * lib/openstack
  * lib/VMwareWebService
    * Client and broker server for connecting to the VMware Virtual
      Infrastructure Management (VIM) API/Framework
* VM scanning
  * lib/disk
  * lib/fs
  * lib/metadata
  * lib/VixDiskLib
    * Ruby bindings to the VIX Disk API for connecting to the VMware virtual
      disks remotely
* standalone utility libraries
  * lib/util
    * Typically, utility libraries that are NOT tied to Rails are put here. The
      benefit is that most of the code automatically loads many of the libraries
      here, so if you want to add a new Exception class, for example, look in
      miq-exception.rb, and Rails code will automatically find it.
  * lib/util/extensions
    * Extensions for Ruby core classes.  Note that extensions to Rails core live
      in vmdb/lib/extensions.

## system

Tools and configuration files that for the virtual appliance.  This includes
daemon scripts, log managers, scripts for setting up ManageIQ, and application
configurations.

## vmdb

This directory contains the ManageIQ Rails application.

* The familiar Rails directories, such as app, config, vendor, etc
* Mixins for models and controllers
  * vmdb/app/models/mixins
  * vmdb/app/controllers/mixins
* Libraries for the application are found in vmdb/lib
  * vmdb/lib/workers
    * Contains the "worker" scripts for the various types of workers as well as
      the base EVM server.  When we start a worker, these are the scripts that
      are invoked with various arguments.  Each worker has a corresponding model
      found in vmdb/app/models.  Additionally, the workers have a class
      inheritance structure found in each script which directly matches the
      inheritance structure in the current configuration.  This way you can set
      a specific setting at the "worker_base" level and have it inherit for all
      subclasses, allowing overloading of configuration values when needed.
      See the documentation on the worker architecture for more details.
  * vmdb/lib/extensions
    * Extensions to Rails core classes.
* Testing
  * spec
    * Specs in the vmdb/spec directory typically match the class path of the
      model to make it easy to find the specs.  For example, the
      ExtManagementSystem model, which lives in models/ext_management_system.rb
      would have its specs in spec/models/ext_management_system_spec.rb
  * spec/automation
    * Specs that verify the internal ManageIQ domain for Automate.  These specs
      work differently in that test import the ManageIQ domain in a before(:all)
      once before executing the specs.  Be careful they are not run in parallel
      with other tests outside of this directory.
  * spec/factories
    * [FactoryGirl](https://github.com/thoughtbot/factory_girl) factories for
      the test suite.
  * spec/migrations
    * Specs that can test migrations using an internal migration testing DSL
      located at vmdb/spec/support/migration_spec_helper.rb.
    * These should not be executed directly and should only be executed via the
      rake task.  This is because the rake task will execute the migrations in
      order and run the corresponding specs along the way.  The rake task also
      migrates down to 0 to verify all down migrations are executed.  Because of
      this, one should not raise IrreversibleMigration exceptions in down
      migrations.
  * spec/replication
    * Specs that test replication between the test database and a second
      database named vmdb_production_master.
    * These should not be executed directly and should only be executed via the
      rake task.  This is because the rake task will setup and teardown the
      secondary database.
  * spec/vcr_cassettes
    * Cassettes for recorded tests using [VCR](https://github.com/vcr/vcr).
