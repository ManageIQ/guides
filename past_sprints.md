# Sprint 9 ended July 9

## Providers
* OpenStack Tenant Inventory (@blomquisg) (INCOMPLETE)
* OpenStack Storage Inventory (@roliveri) (INCOMPLETE) [PR 129](https://github.com/ManageIQ/manageiq/pull/129)
* Microsoft SCVMM Event Catcher (@bsorota) (INCOMPLETE)
* Microsoft SCVMM Power Operations (@bsorota) [PR 22](https://github.com/ManageIQ/manageiq/pull/22)

## VM Analysis (aka Fleecing)
* Replace VixDiskLib Ruby-C Binding with FFI (@jerryk55) [PR 4](https://github.com/ManageIQ/manageiq/pull/4)
* XFS Support (@jerryk55) (INCOMPLETE)
* ReFS Support (@movitto) (INCOMPLETE)

## Control/Automate
* Event Switchboard (@lfu, @bzwei) (INCOMPLETE)
* Autonate UI class/instance/method copy (@h-kataria, @mkanoor) [PR 73](https://github.com/ManageIQ/manageiq/pull/73) and [PR 157](https://github.com/ManageIQ/manageiq/pull/157)
* Automate UI Import/Export (@eclarizio, @mkanoor) (INCOMPLETE)
  * Reset is working now: [PR 94](https://github.com/ManageIQ/manageiq/pull/94) and [PR 156](https://github.com/ManageIQ/manageiq/pull/156)
* Domain Content Cleanup (@tinafitz) [PR 123](https://github.com/ManageIQ/manageiq/pull/123)

## Services
* Hierarchies (@jdillaman) [PR 12](https://github.com/ManageIQ/manageiq/pull/12)
* Support Custom Attributes (@jdillaman) [PR 13](https://github.com/ManageIQ/manageiq/pull/13)
* Optional Regexp Validation (@jdillaman) [PR 14](https://github.com/ManageIQ/manageiq/pull/14)

## Security, Authentication and Authorization
* Support for External Authentication [PR 32](https://github.com/ManageIQ/manageiq/pull/32) and [PR 136](https://github.com/ManageIQ/manageiq/pull/136)
* Support for OpenLDAP [PR 92](https://github.com/ManageIQ/manageiq/pull/92)

## Performance & Scalability
* VM Summary Screen (@Fryguy) [PR 81](https://github.com/ManageIQ/manageiq/pull/81), [PR 120](https://github.com/ManageIQ/manageiq/pull/120), [PR 130](https://github.com/ManageIQ/manageiq/pull/130), [PR 131](https://github.com/ManageIQ/manageiq/pull/131)

## Integration with [Travis CI](https://travis-ci.org/ManageIQ/manageiq) (COMPLETE) [PR 132](https://github.com/ManageIQ/manageiq/pull/132)

## All Merged PRs in [ManageIQ/manageiq](https://github.com/ManageIQ/manageiq) repo
* [1](https://github.com/ManageIQ/manageiq/pull/1) Move ftp upload methods to file depot
* [3](https://github.com/ManageIQ/manageiq/pull/3) Added missing routes.
* [4](https://github.com/ManageIQ/manageiq/pull/4) Replace vix disk lib with ffi
* [9](https://github.com/ManageIQ/manageiq/pull/9) login screen and header updates
* [12](https://github.com/ManageIQ/manageiq/pull/12) Add support for service hierarchies
* [13](https://github.com/ManageIQ/manageiq/pull/13) Add support for custom attributes for services
* [14](https://github.com/ManageIQ/manageiq/pull/14) Add optional regexp validation to service dialogs
* [18](https://github.com/ManageIQ/manageiq/pull/18) Fix replication with a migration for databases upgraded from v4.
* [22](https://github.com/ManageIQ/manageiq/pull/22) SCVMM - Power operations for VMs
* [23](https://github.com/ManageIQ/manageiq/pull/23) Several enhancements to datastore support for the SCVMM integration
* [24](https://github.com/ManageIQ/manageiq/pull/24) migrate event_alert table to save email to address as an array
* [26](https://github.com/ManageIQ/manageiq/pull/26) Added CRUD support for Automate Domains.
* [29](https://github.com/ManageIQ/manageiq/pull/29) Export and Import from a single YAML file
* [30](https://github.com/ManageIQ/manageiq/pull/30) Fixed values passed in to get_combo_xml and get_dtype_combo_xml calls.
* [31](https://github.com/ManageIQ/manageiq/pull/31) Codemirror 4.2 upgrade and styling changes
* [32](https://github.com/ManageIQ/manageiq/pull/32) External auth3
* [34](https://github.com/ManageIQ/manageiq/pull/34) add RSPEC_VERBOSE and RSPEC_OPTIONS
* [36](https://github.com/ManageIQ/manageiq/pull/36) Swap DropDownDynamicList options and values
* [37](https://github.com/ManageIQ/manageiq/pull/37) Fix issue importing policy sets that attempt to be saved during import
* [39](https://github.com/ManageIQ/manageiq/pull/39) Fixed tree_lock method to make left side div and tree dim when in edit.
* [43](https://github.com/ManageIQ/manageiq/pull/43) Add VirtualE1000e NIC definition to the VIM mapping registry.
* [44](https://github.com/ManageIQ/manageiq/pull/44) Update Code Climate badge for new repo.
* [45](https://github.com/ManageIQ/manageiq/pull/45) Comment clean-up for previous commit.
* [47](https://github.com/ManageIQ/manageiq/pull/47) Add tests for encrypted password field and password default value.
* [48](https://github.com/ManageIQ/manageiq/pull/48) Fixed count of Product Features in spec test.
* [49](https://github.com/ManageIQ/manageiq/pull/49) Automate styling update and cleanup
* [50](https://github.com/ManageIQ/manageiq/pull/50) Change MiqAeDatastore upload to use yaml_import.
* [51](https://github.com/ManageIQ/manageiq/pull/51) Updated versioninfo test to use new executable
* [53](https://github.com/ManageIQ/manageiq/pull/53) Remove remaining mysql cruft
* [54](https://github.com/ManageIQ/manageiq/pull/54) Clean up get_session_data and set_session_data methods in all controllers
* [56](https://github.com/ManageIQ/manageiq/pull/56) Adding low-level filesystem test.
* [57](https://github.com/ManageIQ/manageiq/pull/57) Fix version spec to reflect VERSION change from "9.9.9.9" to "master".
* [58](https://github.com/ManageIQ/manageiq/pull/58) Fix test failure "FtpConnection" received :mkdir with unexpected arguments
* [59](https://github.com/ManageIQ/manageiq/pull/59) Automate sync task call from miq_ae_service_vm_vmware.rb
* [60](https://github.com/ManageIQ/manageiq/pull/60) Update with links
* [61](https://github.com/ManageIQ/manageiq/pull/61) Fixed tree_lock spec test.
* [62](https://github.com/ManageIQ/manageiq/pull/62) Cleanup LogFile after moving ftp connection logic to FileDepotFtp
* [63](https://github.com/ManageIQ/manageiq/pull/63) Remove xml based deprecated tests.
* [64](https://github.com/ManageIQ/manageiq/pull/64) Dhtmlx table styling
* [65](https://github.com/ManageIQ/manageiq/pull/65) Fix miq_ae_datastore spec restore test.
* [67](https://github.com/ManageIQ/manageiq/pull/67) Add export notice to README.md
* [68](https://github.com/ManageIQ/manageiq/pull/68) Added missing log .ico file
* [73](https://github.com/ManageIQ/manageiq/pull/73) Support for copy and compare of automate class, instance and methods
* [74](https://github.com/ManageIQ/manageiq/pull/74) Fixed an error when reload is pressed on VM filter with user input.
* [76](https://github.com/ManageIQ/manageiq/pull/76) Changed Settings & Ops main feature to Configure to match UI tab
* [77](https://github.com/ManageIQ/manageiq/pull/77) Standardize Bullet and Links in readme
* [79](https://github.com/ManageIQ/manageiq/pull/79) Added a nil check for @record when setting ownership on a service
* [80](https://github.com/ManageIQ/manageiq/pull/80) Remove psych patch for ruby 1.9.3 p194 since it's been long fixed.
* [81](https://github.com/ManageIQ/manageiq/pull/81) Fix UI vm summary performance (part 1)
* [82](https://github.com/ManageIQ/manageiq/pull/82) Add two missing routes
* [83](https://github.com/ManageIQ/manageiq/pull/83) Changes to address rubocop comments.
* [84](https://github.com/ManageIQ/manageiq/pull/84) Removed a warning message from automation log
* [87](https://github.com/ManageIQ/manageiq/pull/87) Adjusted sprite coordinates on hover over
* [88](https://github.com/ManageIQ/manageiq/pull/88) Export button click will now be disabled until a report is selected
* [90](https://github.com/ManageIQ/manageiq/pull/90) Skip importing $ namespace from legacy XML
* [91](https://github.com/ManageIQ/manageiq/pull/91) Changed identify_record call to pass in model.
* [92](https://github.com/ManageIQ/manageiq/pull/92) Add support for OpenLDAP as implementation for authentication mechanism.
* [93](https://github.com/ManageIQ/manageiq/pull/93) Reports Explorer: Fixed a page rendering issue due to a non-existent custom report node
* [94](https://github.com/ManageIQ/manageiq/pull/94) Reset of the default automate domains
* [95](https://github.com/ManageIQ/manageiq/pull/95) Correctly identify Chrome on the About screen
* [96](https://github.com/ManageIQ/manageiq/pull/96) Fix DoubleRender error when trying to sort a list of dialogs
* [97](https://github.com/ManageIQ/manageiq/pull/97) Added toolbar buttons to make them consistent for all nodes in Automate ...
* [98](https://github.com/ManageIQ/manageiq/pull/98) Build appliances from reliable git references
* [102](https://github.com/ManageIQ/manageiq/pull/102) Turns out equality returns true false
* [104](https://github.com/ManageIQ/manageiq/pull/104) When encrypting passwords, dont generate newlines
* [106](https://github.com/ManageIQ/manageiq/pull/106) Fix spec issues from expectations on old calls.
* [107](https://github.com/ManageIQ/manageiq/pull/107) Added createFolder and subFolderMors to the MiqVimFolder class.
* [108](https://github.com/ManageIQ/manageiq/pull/108) Added missing route.
* [109](https://github.com/ManageIQ/manageiq/pull/109) Add simplecov
* [110](https://github.com/ManageIQ/manageiq/pull/110) only allow root to connect to db as root
* [113](https://github.com/ManageIQ/manageiq/pull/113) Fixed the request workflow when a pre-provisioning dialog is used
* [114](https://github.com/ManageIQ/manageiq/pull/114) Created refactored x_button_response method so spec can stub it
* [115](https://github.com/ManageIQ/manageiq/pull/115) Subclass FileDepotRedhatDropbox
* [117](https://github.com/ManageIQ/manageiq/pull/117) Moved enable/disable download buttons code to a generic method.
* [119](https://github.com/ManageIQ/manageiq/pull/119) Fixed the crash when the accordions in compare/drift are clicked.
* [120](https://github.com/ManageIQ/manageiq/pull/120) Fix UI vm summary performance (part 2)
* [122](https://github.com/ManageIQ/manageiq/pull/122) Fix typo in variable name
* [123](https://github.com/ManageIQ/manageiq/pull/123) Automate model restructure
* [124](https://github.com/ManageIQ/manageiq/pull/124) Fix specs broken by service model update
* [126](https://github.com/ManageIQ/manageiq/pull/126) remove bullet
* [127](https://github.com/ManageIQ/manageiq/pull/127) Adjust MiqAeDatastore model counts.
* [128](https://github.com/ManageIQ/manageiq/pull/128) Code to turn off spinner when form fields are changed.
* [130](https://github.com/ManageIQ/manageiq/pull/130) Optimized Metric::CiMixin#has_perf_data? method
* [131](https://github.com/ManageIQ/manageiq/pull/131) Fix UI vm summary performance (part 3)
* [132](https://github.com/ManageIQ/manageiq/pull/132) Add initial Travis CI support
* [133](https://github.com/ManageIQ/manageiq/pull/133) Revisiting rspec verbose
* [135](https://github.com/ManageIQ/manageiq/pull/135) Added missing power state images
* [136](https://github.com/ManageIQ/manageiq/pull/136) Adding support for configuring External Authentication
* [137](https://github.com/ManageIQ/manageiq/pull/137) Change badges to use the nicer ones at shields.io
* [139](https://github.com/ManageIQ/manageiq/pull/139) Made changes to instance add/edit code to remove AR Objects from @edit
* [140](https://github.com/ManageIQ/manageiq/pull/140) Added a custom serialize method for dhtmlxgrid.
* [141](https://github.com/ManageIQ/manageiq/pull/141) Adding support for /api/request_tasks collection
* [142](https://github.com/ManageIQ/manageiq/pull/142) Fix EmsOpenstack.verify_credentials sleeper bug
* [143](https://github.com/ManageIQ/manageiq/pull/143) Added new dialog_field validator columns to serializer spec.
* [144](https://github.com/ManageIQ/manageiq/pull/144) Resolve an insecure .to_sym call.
* [145](https://github.com/ManageIQ/manageiq/pull/145) Use GUID when creating domains instead of timestamps
* [147](https://github.com/ManageIQ/manageiq/pull/147) Initiate a connection if one is not provided
* [148](https://github.com/ManageIQ/manageiq/pull/148) Build failure caused by test corruption
* [149](https://github.com/ManageIQ/manageiq/pull/149) Added Fog wrapper class for OpenStack access.
* [150](https://github.com/ManageIQ/manageiq/pull/150) Fix broken ScheduleWorker spec triggered by changes to Daylight Savings Time
* [152](https://github.com/ManageIQ/manageiq/pull/152) Fix MiqExpressionSpec to work in Timezone != "Eastern Time (US & Canada)"
* [154](https://github.com/ManageIQ/manageiq/pull/154) Fix routing issues for automate reset on import/export screen.
* [155](https://github.com/ManageIQ/manageiq/pull/155) Timeline styling cleanup
* [156](https://github.com/ManageIQ/manageiq/pull/156) Updated Automate UI export to use backup with zip format.
* [157](https://github.com/ManageIQ/manageiq/pull/157) Added support to copy class, instance, method automate objects.
* [158](https://github.com/ManageIQ/manageiq/pull/158) Default priority for domain, set priority based on ordered domain ids
* [159](https://github.com/ManageIQ/manageiq/pull/159) Catalog styling cleanup
* [162](https://github.com/ManageIQ/manageiq/pull/162) Remove RedHat specific class and implement anonymous_ftp subclass
* [163](https://github.com/ManageIQ/manageiq/pull/163) Testing .log_status should not blindly call .log_system_status
* [165](https://github.com/ManageIQ/manageiq/pull/165) Missing selection box class
* [166](https://github.com/ManageIQ/manageiq/pull/166) Change default GC RUBY_GC_MALLOC_LIMIT to decrease time in GC on travis a day ago
* [167](https://github.com/ManageIQ/manageiq/pull/167) No need to lock tree in Assignments accordion. a day ago
* [168](https://github.com/ManageIQ/manageiq/pull/168) Added a missing route "dynamic_list_refresh" to Service Controller a day ago
* [170](https://github.com/ManageIQ/manageiq/pull/170) Added support for Empty [ifp] sections a day ago
* [171](https://github.com/ManageIQ/manageiq/pull/171) Improve logging in MiqQueue. a day ago
* [172](https://github.com/ManageIQ/manageiq/pull/172) Fix issue with bundle update retry logic not being honored a day ago
* [173](https://github.com/ManageIQ/manageiq/pull/173) Fixed delete button on namespace summary screen.
* [174](https://github.com/ManageIQ/manageiq/pull/174) Fixed the script saving issue in CustomizationTemplate in PXE Controller
* [176](https://github.com/ManageIQ/manageiq/pull/176) Fix connection issue when EmsOpenstack#port is nil.
* [177](https://github.com/ManageIQ/manageiq/pull/177) Fixed tree name being passed in x_build_node_id call.
* [179](https://github.com/ManageIQ/manageiq/pull/179) Fixed Drift Screen scrolling issue
* [180](https://github.com/ManageIQ/manageiq/pull/180) Fix issue with private flavors not being visible on refresh
* [181](https://github.com/ManageIQ/manageiq/pull/181) Added a flash error message when an empty yaml is being imported
* [186](https://github.com/ManageIQ/manageiq/pull/186) Upgrade awesome_spawn and linux_admin
