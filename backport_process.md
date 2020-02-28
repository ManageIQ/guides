# Backport Process

Beginning with the Jansa release of ManageIQ, we will be using the following backport process.  Here are the details!

* We are adding a new label `release_to_backport_to/yes?` 
* Anyone can request a backport by typing `@miq-bot add_label release_to_backport_to/yes?` in a comment in the pull request.
* During the [triage meetings](triage_process.md), the pull request will be evaluated for backportability.  
  * The label will be set to `release_to_backport_to/no` if the backport should be denied for any reason.
  * The label will be set to `release_to_backport_to/yes` if the pull request should be backported.
* The `release_to_backport_to/no` and `release_to_backport_to/yes` labels can only be set by those with special access.
* When the pull request has been backported, the label will flip to `release_to_backport_to/backported`.