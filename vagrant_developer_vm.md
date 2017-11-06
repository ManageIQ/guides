# Developing using a Vagrant defined environment

## Introduction

In some cases, you won't be willing to install all the necessary elements in your system, it is possible to use a VM to deploy it.
The actual pieces of software will be run inside the VM, but it is possible to use folder synchronization to use your preferred development tools in your environment while testing it in the VM.

The VM will be based on Fedora and will install all the necessary tools to run ManageIQ in development mode.
Code is copied from the host during provisioning, so you can test changes in your code.

## Pre-requisites

You will need some tools installed in your machine to use this method:

- Install [Vagrant](http://vagrantup.com/) in your machine
- The image we use needs [VirtualBox](https://www.virtualbox.org/)
- We will provision the machine using [Ansible](https://www.ansible.com/), by default it will use the Ansible provisioner in your host, but it can be configured to run locally in the VM
- The code to be run should be in `~/workspace/manageiq`

## Instructions

 1. Clone the ManageIQ code into `~/workspace/manageiq`

 Everything that is inside that folder will be copied into `/manageiq` in the VM

 2. Clone the repo into your machine (i.e. in `Vagrant/manageiq-dev`)

 `git clone https://github.com/ManageIQ/manageiq-vagrant-dev.git ~/Vagrant/manageiq-dev`

 3. Verify that the Vagrant file is properly configured

  - provision method can be changed into "ansible_local" instead of "ansible" to force ansible to be installed in the VM and Ansible run locally if you don't have it in your host
  - folder synchronization method can be changed to some that support bidirectional synchronization

 4. Run the machine

 ` $ (manageiq-dev) > vagrant up`

 Look at the Vagrant documentation to know for options not described here:

 5. Interact with the VM

  ``` bash
  $ vagrant ssh # Connect to the VM via SSH
  $ vagrant rsync # rsync the content of /manageiq to update the content
  ```

  Ports 3000 for the UI and 4000 for the API are forwared in your local machine, so you can access them through http://127.0.0.1:3000 and http://127.0.0.1:4000

 6. Developing

  You have all the options in the development guide to test. The basic ones are: (Running in `vagrant ssh`)

  Prepare the environment to be run (gems, migrations, etc)

  ` cd ~/manageiq; bin/setup`

  Run the server in full mode

  ` cd ~/manageiq; bundle exec rake evm:start`


## The process

The Vagrant file will create a VM using fedora25-cloud as a basis and proceed to configure it for development following the developer setup guide:

- Configure the VM with 6 GB and 2 CPU
- Open port 3000 for UI management
- Open port 4000 for API management
- Copy the contents of ~/workspace/manageiq to /manageiq inside the appliance
- Install python (needed by Ansible) so the Ansible playbook.yml can be run
- Configure the OS and install everything needed for development
- Configure the database, start and enable it and add the user needed
- Configure rbenv and install ruby 2.3.1
- Verify if reboot is necessary and then reboot the machine


## Pull requests are accepted!
