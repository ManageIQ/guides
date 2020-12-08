# Triage Process

The ManageIQ core team holds regular meetings to triage issues and pull requests across the ManageIQ organization’s repositories. *This is not a meeting to assign when work will be done.*

## Topics

* Backports
  * [Backport requests (Jansa)][]
  * [Backport direct PRs (Jansa)][]
  * [Backport requests (Kasparov)][]
  * [Backport direct PRs (Kasparov)][]
* Issues
  * [Unassigned issues][]
  * [Issues without scope label][]
  * [Stale issues][]
* PRs
  * [Unassigned PRs][]
  * [PRs without scope label][]
  * [Stale PRs][]

## Actions

* Backport requests and direct PRs
  * If accepted for backport, add `<release>/yes` and remove `<release>/yes?`
  * If not accepted for backport, add `<release>/no` and remove `<release>/yes?`
* Unassigned issues (and PRs)
  * If they have a `question` label
    * Answer the question and close OR convert to another scope label such as `enhancement` or `bug` with appropriate renaming of the issue title.
    * Request more feedback and change the `question` label to `feedback requested`.
  * If they have a `feedback requested` label
    * If the author has responded, treat it like a `question` label, otherwise defer to next triage.
  * If invalid, close with a comment and/or label describing the reason.
  * Assign the issue
    * Assign someone to make them aware of the issue.  This *does not* mean that the assignee is expected to start work on the issue.
    * Apply the `help wanted` label.  This means that while the issue is valid, the team does not have plans to work on it in the near future.
* Issues (and PRs) without scope label
  * Apply [scope labels][]
* Stale issues
  * If they have a `bug` label
    * and the bug is `verified`, decide if it should be closed, otherwise request the author to retest on a newer version.
    * and the bug is not `verified`, comment back to the opener of the issue for more info.  If there is no response, then close after it goes stale again.
  * Other
    * If the issue should be kept, label it `pinned` to prevent the `stale` label from being applied, otherwise close
* Stale PRs
  * Stale and unmergeable PRs are closed automatically
  * @mention the author after 1 month of inactivity
  * Close the PR after 3 months of inactivity

[scope labels]:                                             https://www.manageiq.org/docs/guides/labels
<!-- triage links generated after here -->
[Unassigned issues]:                                        https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+is%3Aissue+is%3Aopen+no%3Aassignee+-label%3A%22help+wanted%22+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[Issues without scope label]:                               https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+is%3Aissue+is%3Aopen+-label%3Abug+-label%3A%22bug%2Fsporadic+test+failure%22+-label%3Acleanup+-label%3Adeveloper+-label%3Adocumentation+-label%3Aenhancement+-label%3Aperformance+-label%3Aredesign+-label%3Arefactoring+-label%3A%22technical+debt%22+-label%3Atest+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[Stale issues]:                                             https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+is%3Aissue+is%3Aopen+label%3Astale+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[Unassigned PRs]:                                           https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+is%3Apr+is%3Aopen+-label%3Awip+no%3Aassignee+-label%3A%22help+wanted%22+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[PRs without scope label]:                                  https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+is%3Apr+is%3Aopen+-label%3Awip+-label%3Abug+-label%3A%22bug%2Fsporadic+test+failure%22+-label%3Acleanup+-label%3Adeveloper+-label%3Adocumentation+-label%3Aenhancement+-label%3Aperformance+-label%3Aredesign+-label%3Arefactoring+-label%3A%22technical+debt%22+-label%3Atest+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[Stale PRs]:                                                https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+is%3Apr+is%3Aopen+label%3Astale+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[Backport requests (Jansa)]:                                https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+is%3Amerged+is%3Apr+label%3Ajansa%2Fyes%3F+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[Backport direct PRs (Jansa)]:                              https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+base%3Ajansa+is%3Aopen+is%3Apr+-label%3Ajansa%2Fno+-label%3Ajansa%2Fyes+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[Backport requests (Kasparov)]:                             https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+is%3Amerged+is%3Apr+label%3Akasparov%2Fyes%3F+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
[Backport direct PRs (Kasparov)]:                           https://github.com/issues?q=archived%3Afalse+sort%3Acreated-asc+base%3Akasparov+is%3Aopen+is%3Apr+-label%3Akasparov%2Fno+-label%3Akasparov%2Fyes+org%3AManageIQ+-repo%3AManageIQ%2Fbugzilla_mirror+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Fmanageiq-cross_repo-tests+-repo%3AManageIQ%2Fmanageiq-design+-repo%3AManageIQ%2Fmanageiq-performance+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host-build+-repo%3AManageIQ%2Fmanageiq-vagrant-dev+-repo%3AManageIQ%2Fmiq_bot+-repo%3AManageIQ%2Fpolisher+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fintegration_tests_playbooks+-repo%3AManageIQ%2Fmanageiq-lxca-docs+-repo%3AManageIQ%2Fmanageiq-nuage-docs+-repo%3AManageIQ%2Fmanageiq-redfish-docs+-repo%3AManageIQ%2Fmanageiq-vcloud-docs
