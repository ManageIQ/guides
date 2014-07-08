# Automate Model Redesign

## Problem
The Automate Model has grown to be a very large and central piece of ManageIQ. Today the model is expressed as a single XML file of over 20,000 lines. There are several problems with the current model:
 * With limited test coverage small changes to the model can silently break core functionality. Automated testing is very challenging.
 * Since the model is tightly coupled with the product any customer modifications may break following an upgrade.
 * Navigation
   * Classes and instances lack logical organization
   * Customers are easily confused when locating functionality
 * Customer integrations (Service Now, Remedy, etc) are increasingly required but it is difficult to keep these changes isolated to their own space. Minor alterations to core automate workflow are typically required.
 * Community contributions and sharing of automate functionality is largely blocked by the current model.
 * While the namespace/class/instance model is a common object-oriented approach, customers are forced to use a non-intuitive interface that makes development and debugging difficult.
 * Version control is possible but not practical. This slows development and negatively impacts customers.
 * Customer changes to the core automate model make supporting the product extremely difficult.

## Proposal
 * Provide clear separation between core automate model and user space where built-in automate methods are viewable but read-only. Allow end users to duplicate built-in automate model objects and utilize them. Any modifications that bridge core automate and user space must survive model upgrade.
 * Reorganize classes and folders logically. [See proposal below](Automate-Model-Redesign#proposed-namespaceclass-restructure).
 * Reorganize integration namespace to be a central place for all customer integration
 * Enable text-based editing through familiar directory hierarchy and files (see below)
   * schema: YAML syntax. [example](Automate-Model-Redesign#proposed-example-schemayaml)
   * methods: ruby files
 * Provide command-line simulation tool for complete CLI-based development/debugging workflow. This will also provide a tool for automated testing.
 * Automate hierarchy should have a view of the "community" models which may be selected and imported into ManageIQ. See planned [Github space](https://github.com/RedHatIntegrate/CloudForms-Management-Engine) for community models.
 * Simplify the UI
   * Remove meaningless icons
   * Remove `<class-description> (<class-name>)` convention in favor of simply `<name>`. This will encourage the use of meaningful names.

### Proposed example namespace file structure

    /<namespace>
        README
        /<class>
            README
            instance.yaml
            method.rb
            schema.yaml


### Proposed example instance.yaml

    param_1: default
    execute: my_method.rb


### Proposed example schema.yaml

    param_1:
        type: attribute
        default_value: my string
        substitute: 1
        message: create
    method_1:
        type: method
        default_value: my_method.rb

### Proposed Namespace/Class Restructure


    /ManageIQ (domain)
      /Cloud
        /VM
          /LifeCycle
          /Operations
            /Email
            /Methods 
          /Provisioning
            /Email
            /Naming
            /Placement
            /Profile
            /StateMachines
              /Methods
          /Retirement
            /Email
            /StateMachines
              /Methods
      /Control
        /Email (e.g. evm_server_start, evm_server_stop, etc.)
      /Infrastructure
        /Cluster
          /Operations
            /Email
            /Methods (e.g. gridapp, intelligent workload management)
        /Host
          /LifeCycle
          /Operations
            /Email
            /Methods (e.g. host-evacuation)
          /Provisioning
            /Email
            /Naming
            /Placement
            /Profile
            /StateMachines
              /Methods
        /VM
          /LifeCycle
          /Migrate
            /Email
            /Placement
            /Profile
            /StateMachines
              /Methods
          /Operations
            /Email
            /Methods (e.g. hot-add-memory, VM_Placement_Optimization, etc.)
          /Provisioning
              /Domain (LDAP Directory Integration Methods)
              /Email
              /Naming
              /Placement
              /Profile
              /StateMachines
                /Methods
          /Retirement
            /Email
            /StateMachines
              /Methods
      /Service
        /LifeCycle
        /Provisioning
          /Email
          /Profile
          /StateMachines
            /Methods
        /Retirement
          /Email
          /StateMachines
            /Methods


      /Integration
        /IPAM
        /BlueCat
        /InfoBlox
        /DHCP
        /CMDB
        /Event (or Incident?)
        /ServiceNow
        /Remedy (BMC Remedy)
        /Change (New class to align with ITIL standards)
        /Remedy
        /LDAP (Active Directory Integration for OU placement)