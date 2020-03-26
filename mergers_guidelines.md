# Merger Guidlines

## DO
* Create a merge commit
* Set the following
  * A [purple component label][1] (e.g. api, providers/vmware, etc).
  * A [scope label][1] (bug, enhancement, refactoring, test, tools, developer, cleanup, performance, technical debt).
  * A backport label for the next release (e.g. jansa/yes? or jansa/no).
  * If there is no assignee, set yourself as the assignee.
* Proactively look at new PRs and Issues on some interval.
  * If you know the SME (subject matter expert) for a particular PR or Issue, assign it to them.
  * If you are the SME, assign to yourself, and do the review.
* Feel free to review PRs in which you are not the SME.  The more help, the better.
* Ask for help from others, with @mentions, if you are unsure, or just want a second set of eyes.

## DON’T
* Do not be afraid to merge. ;)
  * If you are hesitant to merge, re-assign to someone who will.
* Do not push to master or other release branches.
* Do not merge your own PRs.
* Do not merge a PR expecting the author to merge your PR (quid pro quo).
* Do not merge WIP PRs - A helpful Chrome extension to prevent it is [here](https://chrome.google.com/webstore/detail/do-not-merge-wip-for-gith/nimelepbpejjlbmoobocpfnjhihnpked).
* Do not push branches to the main repo.  Use a fork for your own work like other developers.
* By extension, do not use the revert or edit buttons in the GitHub UI as they create direct branches on the main repo.
  * Instead, for reverts, you can create a local branch, run `git revert SHA`, then push to your fork and make a PR.
  * It may be preferable to revert the merge commit, particularly if there are multiple commits in the PR and you want to revert the entire PR.
* Do not let PRs sit unreviewed.
  * Make a comment that you’ll get to it soon (if you don’t have time yet).
  * If you’re not the authority, assign to someone else; or at least @mention them.

[1]: labels.md#about-the-label-colors
