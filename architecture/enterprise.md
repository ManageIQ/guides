# Enterprise Architecture

To facilitate scaling it is possible to use multiple ManageIQ appliances each
performing different roles.  To understand how this is accomplished some new
terms and concepts must be learned.  This document gives a high level overview
of the enterprise architecture and hierarchy.

* [Appliance](#appliance)
* [Zone](#zone)
* [Region / Enterprise](#region--enterprise)

## Appliance

Also known as a "Server" or an "MiqServer", an appliance is a virtual machine
with the ManageIQ executable code.  It is delivered as a preconfigured virtual
appliance that can run on either VMware vSphere, RHEV, oVirt, or OpenStack.

Appliances are added for horizontal scalability as well as for dividing up work
by roles.  An appliance can be configured to handle work for one or many roles,
with workers within the appliance carrying out the duties for which they are
configured.

## Zone

Multiple appliances are logically grouped into zones.  Typically, zones are
configured to provide specific functionalities, however the grouping is
completely up to the user.

Some examples of zones are
* A UI zone
* A reporting zone
* A test zone
* A production zone
* A vSphere zone

ManageIQ has the ability to create an affinity between a zone and a particular
provider.  In this way, a provider specific zone can be created.

## Region / Enterprise

A region is a full installation of ManageIQ, containing one database appliance,
and potentially many other appliances.  A region is the collection of all zones
that share the same database.

In a typical enterprise installation, a separate region is used for each
geographical region where WAN access to the database would be detrimental to
performance.  For example, for an international corporation, one region may be
placed in North America, a second in Europe, and a third in Asia.  When multiple
regions are involved, we refer to the collection of all regions as the
enterprise.

To give a worldwide "single pane of glass" view, one extra region is usually
added to act as a "master" region.  This region is referred to as the Enterprise
region.  The other regions then enable the database synchronization role in
order to replicate their data into the "master" region. In this way, individual
regions get the benefit of being co-located with the database, whereas the
enterprise region can provide a high-level reporting view where needed.  See the
database synchronization role for more information.

Only one appliance per region can provide the database.  The ManageIQ appliance
comes preconfigured with a default database.  If a second appliance is added, it
must be configured to point to the first appliances's database.

Each region is identified by a unique number.  When a new region is created, a
unique number must be chosen.  The ManageIQ appliance comes preconfigured with
the default region number of 0.  The region number is used to set up database id
numbers in ranges of 1 trillion.  Thus region 0 will contain ids 0 through
999,999,999,999 and region 1 will contain ids 1,000,000,000,000 through
1,999,999,999,999.  By having each region be a specific range, there are no
collisions when database synchronization combines the various regions into the
"master" region's database.

### Visual example

<pre>
 Region
+--------------------------------------------------------------+
|                                                              |
|   Zone A                        Zone B                       |
|  +--------------------------+  +--------------------------+  |
|  |                          |  |                          |  |
|  |   Appl 1      Appl 2     |  |   Appl 3      Appl 4     |  |
|  |  +--------+  +--------+  |  |  +--------+  +--------+  |  |
|  |  |        |  |        |  |  |  |        |  |        |  |  |
|  |  |        |  |        |  |  |  |        |  |        |  |  |
|  |  |  {DB}  |  |        |  |  |  |        |  |        |  |  |
|  |  |        |  |        |  |  |  |        |  |        |  |  |
|  |  |        |  |        |  |  |  |        |  |        |  |  |
|  |  +--------+  +--------+  |  |  +--------+  +--------+  |  |
|  |                          |  |                          |  |
|  +--------------------------+  +--------------------------+  |
|                                                              |
+--------------------------------------------------------------+
</pre>
