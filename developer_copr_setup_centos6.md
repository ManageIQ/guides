## Developer Copr setup for CentOS6

### Background

ManageIQ requires some upstream rpms for use on our CentOS appliances.
Copr makes these rpms publicly available for the community build.

These steps will walk you through:

* Create a Fedora / Copr account
* Create a Copr project
* add repositories for dependencies
* specify the chroot
* add any additional packages to the minimal chroot
* specify the `src.rpm` to build
* host existing source rpm (srpm) publicly
* mock, test, and build the rpm
* incorporate the Copr yum repo into our upstream community build.


###  Create a Fedora account (used as a Copr account)
* Create a Fedora account: http://copr.fedoraproject.org/
* Review [Copr tutorial](https://fedorahosted.org/copr/wiki/ScreenshotsTutorial).

### Create a Copr project

* The project groups similar rpms together.
* Put rpms together based upon a common build environment and package requirements.
* Also, group rpms based upon how the yum repository will be consumed.
* Name the project correctly since you can't rename it.

### Configure the project's settings:

* [chroot](https://help.ubuntu.com/community/BasicChroot):
  * **epel-x86_64**
* Edit this chroot and "specify additional packages to be always present in minimal buildroot":
  * If you need to build a ruby gem that utilizes the SCL, you need the following:
    * **scl-utils-build ruby193-build**
    * **Note**: the guides suggest scl-utils, not scl-utils-build.
      * Without scl-utils-build, some scl macros won't be found and the mock/build may fail.
      * Bundler, rake-compiler, and others failed when using scl-utils: ```Unknown tag: %scl_package rubygem-%{gem_name}```

* repositories:
  * http://mirror.centos.org/centos/6/os/$basearch/
  * http://mirror.centos.org/centos/6/SCL/$basearch/
  * http://mirror.centos.org/centos/6/updates/$basearch/
  * http://copr-be.cloud.fedoraproject.org/results/jrafanie/manageiq-scl/epel-6-$basearch/
    * **Note**: The last repository is the project's yum repository itself since some packages have dependencies on other packages in the yum repository.
    * For example, the qpid_messaging gem requires the qpid-cpp package be built first, so we build qpid-cpp and then qpid_messaging can be built using the resulting qpid-cpp rpms in this yum repository.

### Find the desired srpm or create it.

* If you have the desired package in distgit, you can use rhpkg/fedpkg srpm to produce an srpm you can then push to github or somewhere publicly.
* Copr can use any src.rpm that is on the web.
* Github is not required but that's what ManageIQ people are familiar with.
  * **Note** When you build in Copr, you will need to provide the URL that it can be retrieved via curl/wget:
    * To use: "rubygem-somegem-1.0.0-1.el6.src.rpm" found in: https://github.com/USERNAME/srpms/tree/master/srpms
    * Tell mock/Copr to use: https://raw.githubusercontent.com/USERNAME/srpms/master/srpms/rubygem-somegem-1.0.0-1.el6.src.rpm

### Configure mock to test builds locally

Copr is sometimes busy and response can be slow. Using mock, to do test builds locally, can help avoid wasting time waiting for Copr to report the build failed. So use mock locally to debug builds until you get it to build successfully.

* Create a /etc/mock/YOUR_PROJECT.cfg, by copying your target platform's .cfg.
  * For example, I need epel-6-x86_64, so I do this:
  ``` cp /etc/mock/epel-6-x86_64.cfg /etc/mock/YOUR_PROJECT.cfg ```


* Update the repos you need, for example:

```
[base]
name=BaseOS
enabled=1
baseurl=http://mirror.centos.org/centos/6/os/$basearch/

[updates]
name=updates
enabled=1
baseurl=http://mirror.centos.org/centos/6/updates/$basearch/

[SCL]
name=SCL
enabled=1
baseurl=http://mirror.centos.org/centos/6/SCL/$basearch/
```

* Add a local yum repository so I can mock locally, produce rpms needed for other packages and add them to this yum repo.  See below for an explanation.

```
[local]
name=local
baseurl=file:///home/USERNAME/copr/manageiq
enabled=1
```

* Change the following lines that correspond to the option you specified in Copr "specify additional packages to be always present in minimal buildroot":

```
From:
config_opts['root'] = 'epel-6-x86_64'

To:
config_opts['root'] = 'YOUR_PROJECT'
```

```
From:
config_opts['chroot_setup_cmd'] = 'groupinstall buildsys-build'

To:
config_opts['chroot_setup_cmd'] = '@build scl-utils-build ruby193-build'
```

* Skip down to "mock locally" and try it.

* If that fails with "ERROR: Could not find useradd in chroot, maybe the install failed?",
perhaps your version of mock/yum isn't handling the package group @build properly so, the shadow-utils package is not installed so useradd is missing.

  * A workaround is to enumerate all of the packages in the build group, see rpm groupinfo build...

  ```
  From:
  config_opts['chroot_setup_cmd'] = 'groupinstall buildsys-build'
  ```

  To:
  ```
  config_opts['chroot_setup_cmd'] = 'install scl-utils-build ruby193-build bzip2 coreutils cpio diffutils findutils gawk gcc gcc-c++ grep gzip info make patch redhat-release redhat-release-server redhat-rpm-config rpm-build sed shadow-utils tar unzip util-linux-ng which'
  ```

### mock locally:

* mock -r YOUR_PROJECT https://raw.githubusercontent.com/USERNAME/srpms/master/srpms/rubygem-somegem-1.0.0-1.el6.src.rpm

* The basic workflow to populate a local repository.
  * Problem: qpid_messaging needs qpid-cpp-client-devel, so I need to package that first.

  ```
  mkdir -p ~/copr/manageiq  # the yum repository
  mock -r YOUR_PROJECT qpid-cpp-0.14-22.el6_3.src.rpm
  cp /var/lib/mock/YOUR_PROJECT/result/qpid*.rpm ~/copr/manageiq/
  createrepo ~/copr/manageiq/
  ```

  * You can then mock locally again... for the new rpm.
  * mock -r YOUR_PROJECT https://raw.githubusercontent.com/USERNAME/srpms/master/srpms/rubygem-qpid_messaging-0.20.2-2.el6.src.rpm

### build in Copr

* Once you are able to mock build locally, start a build in Copr using same source rpm
* The yum repository baseurl will be http://copr-be.cloud.fedoraproject.org/results/USERNAME/PROJECT/epel-6-x86_64/
* Each package will have a subdirectory within the repository above with the root.log/build.log and output rpms

### Use the Copr repository

Once you follow these instructions and have your Copr repo created and populated with rpms, you need to add the repo as a [repo line in the kickstart](https://github.com/ManageIQ/manageiq/blob/0d7eb30b165fa575521a19c02c9965031c33656e/build/kickstarts/base.ks.erb#L20) to enable installing of the packages in the Copr repo at appliance build time.  If you need to be able to install/update/re-install from the Copr repo (which should always be the case), you also need to [enable the repo for post appliance deployment](https://github.com/ManageIQ/manageiq/blob/0d7eb30b165fa575521a19c02c9965031c33656e/build/kickstarts/base.ks.erb#L215) 
