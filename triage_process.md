# Issue and PR Lifecycle and Triage Process

The community holds meetings regularly to triage issues and pull requests across the ManageIQ organization’s repositories. Attendees include code owners and mergers for the repositories, but all are invited to attend.*This is not a meeting to assign when work will be done.*

Triage meetings are divided into two groups General and API/UI.
  * [Core/Provider triage meetings][] are usually held weekly and include provider and core repositories
  * [API/UI triage meetings][] are also held weekly and include the UI and API repos.
  
Triage Category|Core/Provider Link|UI/API Link
---|---|---
Unassigned issues|[Core/Provider unassigned issues][]|[UI/API unassigned issues][]
Assigned issues without scope label|[Core/Provider issues without scope label][]|[UI/API issues without scope label][]
Stale issues|[Core/Provider stale issues][]|[UI/API stale issues][]
Unassigned pull requests| [Core/Provider unassigned pull requests][]|[UI/API unassigned pull requests][]
Assigned pull requests without scope label|[Core/Provider assigned pull requests without scope label][]|[UI/API assigned pull requests without scope label][]
Stale pull requests|[Core/Provider stale pull requests][]|[UI/API stale pull requests][]



## Issue Triage
* Triage unassigned issues
  * Assign the issue.  There are three possible scenarios.
    * Assign someone to at least get in on the radar.  This *does not* mean that the assignee is expected to start work on the issue.
    * Apply the `help wanted` label.  This means that while the issue is valid, the team does not have plans to work on it in the near future.
    * Do not assign to anyone and revisit the issue.  In other words, we want to be sure that the issue does not get ignored in perpetuity.
  * Close invalid issues with a comment and/or label as to why it has been closed.
* Review issues with assignee, but no scope label.
  * Apply [scope labels][].
* Review `stale` issues 
  * `Bug` label
    * If the bug is stale, but not verified, will decide during triage if it should be closed.
    * If the bug is not reproducible, comment back to the opener of the issue for more info. If there is no response, then close after it goes stale. 
  * `Question` label
    * Should not go stale.
    * Can either be answered and closed OR converted to another scope label such as `enhancement` or `bug` with appropriate renaming of the issue title.
  * All other scope labels
    * Should never go stale, either pin or close.
    * If the item is considered reasonable, the issue should be labeled `pinned` to prevent the stale label from being applied.

## Pull Request Triage
* Review unassigned pull requests.
  * Apply [scope labels][]
  * Assign the pull request.  There are three possible outcomes.
    * Assign someone to at least get in on the radar.  This *does not* mean that the assignee is expected to start work on the issue.
    * Apply the `help wanted` label.  This means that while the issue is valid, the team does not have plans to work on it in the near future.
    * Do not assign to anyone and revisit the issue.  In other words, we want to be sure that the issue does not get ignored in perpetuity.
* Review assigned PRs with no scope label.
  * Apply [scope labels][].
* Review `stale` PRs.
  * Bump via @mention after 1 month of no activity 
  * Apply stale label after 3 month of no activity
  * After turns stale and 3 months, close the PR.
  * Stale and unmergeable PRs are closed automatically.


[Core/Provider triage meetings]:                            https://calendar.google.com/event?action=TEMPLATE&tmeid=NWNjbGw2dDgzOGluZDJrb3QzanFobW9vNmNfMjAyMDAyMTNUMTgzMDAwWiBjb250YWN0QG1hbmFnZWlxLm9yZw&tmsrc=contact%40manageiq.org&scp=ALL
[API/UI triage meetings]:                                   https://calendar.google.com/event?action=TEMPLATE&tmeid=NzIxc28ycGtpcnJqcThobjhiMjh2NGQ5N3FfMjAyMDAyMTRUMTQzMDAwWiBjb250YWN0QG1hbmFnZWlxLm9yZw&tmsrc=contact%40manageiq.org&scp=ALL
[Core/Provider unassigned issues]:                          https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+archived%3Afalse+-label%3A%22help+wanted%22+no%3Aassignee+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageiq%2Fbugzilla_mirror+-repo%3AManageiq%2Fpolisher+-repo%3AManageiq%2Fwrapanapi+-repo%3AManageiq%2Fmanageiq-ui-classic+-repo%3AManageiq%2Fmanageiq-performance+or+-repo%3AManageiq%2Fmanageiq-api+or+-repo%3AManageIQ%2Fui-components+or+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Freact-ui-components+org%3AManageIQ+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageiq%2Fmanageiq-ui-service+-repo%3AManageIQ%2Fmanageiq_docs+-repo%3AManageIQ%2Fintegration_tests+user%3AManageIQ+sort%3Acreated-desc+
[Core/Provider issues without scope label]:                 https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+archived%3Afalse+-label%3Atest+-label%3Aperformance+-label%3Abug+-label%3Aenhancement+-label%3Adocumentation+-label%3Arefactoring+-label%3Acleanup+-label%3A%22technical+debt%22+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageiq%2Fbugzilla_mirror+-repo%3AManageiq%2Fpolisher+-repo%3AManageiq%2Fwrapanapi+-repo%3AManageiq%2Fmanageiq-ui-classic+-repo%3AManageiq%2Fmanageiq-performance+or+-repo%3AManageiq%2Fmanageiq-api+or+-repo%3AManageIQ%2Fui-components+or+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Freact-ui-components+org%3AManageIQ+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageiq%2Fmanageiq-ui-service+-repo%3AManageIQ%2Fmanageiq_docs+-repo%3AManageIQ%2Fintegration_tests+user%3AManageIQ+sort%3Acreated-desc+
[Core/Provider stale issues]:                               https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Aissue+label%3Astale+archived%3Afalse+user%3AManageIQ+-repo%3AManageIQ%2Fmanageiq-ui-classic+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageiq%2Fbugzilla_mirror+-repo%3AManageiq%2Fpolisher+-repo%3AManageiq%2Fwrapanapi+-repo%3AManageiq%2Fmanageiq-ui-classic+-repo%3AManageiq%2Fmanageiq-performance+-repo%3AManageiq%2Fmanageiq-api+-repo%3AManageIQ%2Fui-components+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Freact-ui-components+org%3AManageIQ+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageiq%2Fmanageiq-ui-service+-repo%3AManageIQ%2Fmanageiq_docs+-repo%3AManageIQ%2Fintegration_tests+
[Core/Provider unassigned pull requests]:                   https://github.com/issues?utf8=%E2%9C%93&q=is%3Aopen+is%3Apr+archived%3Afalse+-label%3A%22help+wanted%22+no%3Aassignee+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageiq%2Fbugzilla_mirror+-repo%3AManageiq%2Fpolisher+-repo%3AManageiq%2Fwrapanapi+-repo%3AManageiq%2Fmanageiq-ui-classic+-repo%3AManageiq%2Fmanageiq-performance+or+-repo%3AManageiq%2Fmanageiq-api+or+-repo%3AManageIQ%2Fui-components+or+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Freact-ui-components+org%3AManageIQ+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageiq%2Fmanageiq-ui-service+-repo%3AManageIQ%2Fmanageiq_docs+-repo%3AManageIQ%2Fintegration_tests+user%3AManageIQ+sort%3Acreated-desc+
[Core/Provider assigned pull requests without scope label]: https://github.com/pulls?utf8=%E2%9C%93&q=is%3Aopen+is%3Apr+archived%3Afalse+-label%3Atest+-label%3Aperformance+-label%3Abug+-label%3Aenhancement+-label%3Adocumentation+-label%3Arefactoring+-label%3Acleanup+-label%3A%22technical+debt%22+-repo%3AManageIQ%2Fmanageiq-release+-repo%3AManageiq%2Fbugzilla_mirror+-repo%3AManageiq%2Fpolisher+-repo%3AManageiq%2Fwrapanapi+-repo%3AManageiq%2Fmanageiq-ui-classic+-repo%3AManageiq%2Fmanageiq-performance+or+-repo%3AManageiq%2Fmanageiq-api+or+-repo%3AManageIQ%2Fui-components+or+-repo%3AManageIQ%2Fmanageiq-consumption+-repo%3AManageIQ%2Freact-ui-components+org%3AManageIQ+-repo%3AManageIQ%2Fmanageiq-v2v+-repo%3AManageiq%2Fmanageiq-ui-service+-repo%3AManageIQ%2Fmanageiq_docs+-repo%3AManageIQ%2Fintegration_tests+-repo%3AManageIQ%2Fmanageiq-v2v-conversion_host+user%3AManageIQ+
[Core/Provider stale pull requests]:                        https://github.com/pulls?utf8=%E2%9C%93&q=is%3Aopen+is%3Apr+label%3Astale+archived%3Afalse+user%3AManageIQ+
[UI/API unassigned issues]:                                 https://github.com/issues?utf8=%E2%9C%93&q=is%3Aissue+-label%3A%22help+wanted%22+repo%3AManageiq%2Fmanageiq-ui-classic+repo%3AManageiq%2Fmanageiq-api+repo%3AManageIQ%2Fui-components+repo%3AManageIQ%2Freact-ui-components+repo%3AManageiq%2Fmanageiq-ui-service+is%3Aopen+no%3Aassignee+
[UI/API issues without scope label]:                        https://github.com/issues?page=1&q=is%3Aissue+-label%3A%22help+wanted%22+-label%3Arefactoring+-label%3A%22technical+debt%22+-label%3Abug+-label%3Aenhancement+repo%3AManageiq%2Fmanageiq-ui-classic+repo%3AManageiq%2Fmanageiq-api+repo%3AManageIQ%2Fui-components+repo%3AManageIQ%2Freact-ui-components+repo%3AManageiq%2Fmanageiq-ui-service+is%3Aopen&utf8=%E2%9C%93
[UI/API stale issues]:                                      https://github.com/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Astale+repo%3AManageiq%2Fmanageiq-ui-classic+repo%3AManageiq%2Fmanageiq-api+repo%3AManageIQ%2Fui-components+repo%3AManageIQ%2Freact-ui-components+repo%3AManageiq%2Fmanageiq-ui-service+is%3Aopen+
[UI/API unassigned pull requests]:                          https://github.com/pulls?utf8=%E2%9C%93&q=is%3Apr+is%3Aopen+-label%3A%22help+wanted%22+repo%3AManageiq%2Fmanageiq-ui-classic+repo%3AManageiq%2Fmanageiq-api+repo%3AManageIQ%2Fui-components+repo%3AManageIQ%2Freact-ui-components+repo%3AManageiq%2Fmanageiq-ui-service+is%3Aopen+no%3Aassignee+
[UI/API assigned pull requests without scope label]:        https://github.com/issues?page=2&q=is%3Apr+-label%3A%22help+wanted%22+-label%3Arefactoring+-label%3A%22technical+debt%22+-label%3Abug+-label%3Aenhancement+repo%3AManageiq%2Fmanageiq-ui-classic+repo%3AManageiq%2Fmanageiq-api+repo%3AManageIQ%2Fui-components+repo%3AManageIQ%2Freact-ui-components+repo%3AManageiq%2Fmanageiq-ui-service+is%3Aopen&utf8=%E2%9C%93
[UI/API stale pull requests]:                               https://github.com/pulls?utf8=%E2%9C%93&q=is%3Aopen+is%3Apr+label%3Astale+archived%3Afalse+user%3AManageIQ+
[scope labels]:                                             https://www.manageiq.org/docs/guides/labels
