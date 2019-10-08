# Coding Style and Standards

The following are the coding style and standards for the code written and
maintained by the ManageIQ team.

## Table of Contents

* [High Level Guidelines](#high-level-guidelines)
* [Ruby Style Guide](#ruby-style-guide)
* [Documentation](#documentation)
* [Logging](#logging)
* [Commits](#commits)
* [Pull Requests and Branches](#pull-requests-and-branches)
* [Gems](#gems)
* [Error and Issue Reporting](#error-and-issue-reporting)

## High Level Guidelines

* Be consistent.
* These guides describes general guidelines to follow for new code.
  For existing code, stay consistent with the conventions of the code you
  are changing.
* Prefer readability over performance and conciseness when the performance
  difference is minimal.
* If you can convince others why we should violate a guideline, then violate
  the guideline.
* These guides are living documents and are subject to change.  Feel free
  to comment or submit pull requests for changes, additions, or removals.

## Ruby Style Guide

* We follow, with some exceptions, the [original Ruby style guide](https://github.com/bbatsov/ruby-style-guide).
  Any changes we have that deviate from the default style guide are enumerated
  in the [.rubocop_base.yml](.rubocop_base.yml) file, which is inherited by most
  projects in the ManageIQ organization.

## Documentation

We use [yardoc](https://yardoc.org/) to create inline code documentation. For now documentation is scarce but
we encourage contributors to add it whenever possible. Until more of the codebase is documented, we limit the created 
documentation to those files that are well documented. 
Please try to document methods that are used by external teams, like providers.
These are the integration API for them and should be documented best.

To view the documentation online visit [rubydoc.info](http://www.rubydoc.info/github/manageiq/manageiq). For a local
version you can run `bundle exec yard` and view the html docs in `/doc/index.html`. When writing documentation you
should add your source files to `/.yardopts` and run `bundle exec yard server -r`. This will create a local 
documentation server which regenerates the docs on each request.

## Logging

* Log messages should be prefixed consistently.

  ```ruby
  # in a class method (notice the . notation)
  $log.info("MIQ(#{self.name}.#{__method__}) The rest of the log message.")

  # in an instance method (notice the # notation)
  $log.info("MIQ(#{self.class.name}##{__method__}) The rest of the log message.")
  ```

* If the same log prefix will be used many times within the same method,
  consider using a variable named log_prefix.

  ```ruby
  log_prefix = "MIQ(#{self.class.name}##{__method__})"
  ...
  $log.info("#{log_prefix} The rest of the log message.")
  ```

* When wrapping a block of code in logging, consider using the same
  string with ellipses, to make it easier to search them in the logs.  As a
  corollary, avoid using words that would not make sense on both ends, such as
  "Starting".  Attach any extra information after the latter message using
  `" - #{extra_info}"`

  ```ruby
  $log.info("#{log_prefix} Refreshing EMS #{name}...")
  ...
  $log.info("#{log_prefix} Refreshing EMS #{name}...Complete")

  # with extra information, such as timings or counts
  $log.info("#{log_prefix} Refreshing EMS #{name}...")
  ...
  $log.info("#{log_prefix} Refreshing EMS #{name}...Complete - Timings: #{timings.inspect}")
  ```

## Commits

* Write a good commit message.  The format for a commit message is as follows.
  Also [read more](http://goo.gl/w11us) on writing good commit messages.
  * A short summary of the commit under 72 characters.  Do not use a ticket
    number as the subject alone.
  * A blank line.
  * An optional body of text, preferably wrapped at 72 characters.
    The line length is flexible, particularly in cases where data such as
    tables or URLs are being copied.  The body's purpose is to convey more
    detailed information about the commit, especially to someone who may need
    to search the code history for changes.  Feel free to include URLs, Git
    SHA references to other commits, and even raw data to make the purpose
    of the commit clearer (e.g. "Was broken by commit 0f3a459b").
  * A blank line if you've written a body.
  * References to any Bugzilla tickets or Github Issues, one per line if
    there are multiple.
    * Bugzilla tickets should be in the form of a full URL to the ticket.
    * Github issues should be of the form "Issue #n", where n is the
    issue number.
* Each commit should have its own unique subject.  Do not use the same
  subject for a series of commits in a branch of work.
* Keep commits small by committing often and only include related changes
  and tests together.
* You may be doing too much in a commit if...
  * You can't get the subject of the commit message under 72 characters
  * You are using a lot of "ands" or "ors" in the commit message
  * You find yourself using lots of bullet points to enumerate all the work
    the commit does.
* Squash (combine) commits to keep logical units of changes grouped together
  in the same commit.  Don't squash unrelated changes.
* Avoid mixing logical changes with style changes of unrelated code.
  Keep them as separate commits.  If the style change makes it hard to see
  the logical change, do the style change in a different pull request.
* Avoid mixing code changes with code relocation.  Keep them as separate
  commits.  If the moved method has high churn, perhaps move the method in
  a separate pull request.

## Pull Requests and Branches

* Use descriptive names for feature branches as they are included in the
  Git history.

  ```
  # bad
  faster_tests
  rework_amazon_code

  # good
  remove_test_duplication_for_performance
  change_ems_amazon_to_be_region_specific
  ```

* Write a good pull request message.  By default, Github will use your
  branch name as the title.  Adjust the title if this is not appropriate for
  the pull request.
  * See [writing a good commit message](#commits) for information about
    writing a good pull request message, exchanging the word "subject" with
    "title".
* All pull requests should have tests or mention that there are existing
  tests that cover the code changes.
* Avoid large pull requests (e.g. 1000+ lines changed not counting any
  generated files such as test data).
  * Consider if the changes should be done in separate pull request.
  * Use the number of lines added/removed as an indicator of possible
    code smells.
* Try to avoid having a commit with, for example, a spelling mistake, that
  is fixed in a subsequent commit in the same pull request.  Use `git rebase -i`
  to clean up those commits to keep the history clean.
* If a pull request involves UI changes, consider adding a before/after
  set of screenshots to show what has changed visually.
* Use [@-mentions](https://github.com/blog/821) to request reviews from
  specific people.
* When you add new commits to a pull request, be sure to @-mention others
  so they know you are ready for a new review.

## Error and Issue Reporting

* Under no circumstances should customer names or customer related information
  be referenced in Github issues, error reports, commits, or pull requests.
* For UI errors, the error message and stack trace are usually in
  production.log.  A snippet from there with the entire UI transaction is
  needed, including the error message and the stack trace.  A UI transaction
  starts with something that looks like

  ```
  [----] I, [2013-08-22T04:39:11.910803 #24340:3fd36e0349dc]  INFO -- : Started GET "/ems_infra/show/7" for 127.0.0.1 at 2013-08-22 00:39:11 -0400
  [----] I, [2013-08-22T04:39:11.929926 #24340:3fd36e0349dc]  INFO -- : Processing by EmsInfraController#show as HTML
  ```

  and ends with something that looks like

  ```
  [----] I, [2013-08-22T04:39:12.127578 #24340:3fd36e0349dc]  INFO -- : Rendered layouts/_global_footer.html.erb (0.1ms)
  [----] I, [2013-08-22T04:39:12.127794 #24340:3fd36e0349dc]  INFO -- : Completed 200 OK in 198ms (Views: 110.1ms | ActiveRecord: 15.4ms)
  ```

  Everything in between with the same PID (the number between the # and :
  symbols in the log line header) is important.
* For non-UI errors (or errors that appear in the UI but are really
  backend errors), the error message is usually in the evm.log.  Typically,
  we need more information than just the error message and stack trace, so
  it is helpful to have some extra context lines above and below the error.
  The amount is hard to quantify, so we will have to build up a list of things
  as time moves forward.

  Most items are handled by a queue worker of some type, so for those it
  is most useful to have:
  
  * The MiqQueue.put or MiqQueue.merge line from the worker that placed
    the item on the queue.
  * Context around why the item was placed on the queue.  For example, if
    some operation caused a policy item to be placed on the queue, is useful
    to have the log lines around what that operation was that triggered a
    policy check.  This trail going backwards usually continues until you
    get a UI action or a scheduler action.
  * The MiqQueue.get line from the worker that picked up the queue item.
  * All work from the PID of the worker that picked up the item, up to and
    including the error message and stack trace.
  * On occasion, incidental work done by other workers in the same time
    frame.  Since all logs are UTC based, it makes it easier to coordinate
    log times from multiple appliances, regardless of where the logs live.
    This type of information is usually needed when there are environmental
    or coincidental errors occurring across all or part of the system.
* Screenshots of the "UI error screen" are not useful at all, as all it
  shows is the exact error that is in the logs, but without all of the rest
  of the required information listed above.
* For bugs on an old version of the product, it is helpful to know if the
  behavior is repeatable on the latest version on that z-stream.  In addition,
  it is helpful to know if the behavior is repeatable on the latest of the
  next release, or even upstream.

## Gems

When extracting code into a new gem or creating a new gem:

* Follow [SemVer](http://semver.org/).
* Follow the internal guide for a creating a new gem.
  * Create a CONTRIBUTING.md that references these guides.  Project-specific
    changes or additions to the guides can be put here.
  * Create a LICENSE.txt with an appropriate license.

## Git how-to

Note after the changes in this section, you will need `git push -f `if you have 
already pushed them before.

* Reword/squashing/reordering a commit

  To modify with recent commit in current branch, first do 
  `git rebase -i origin branch-name`.
  To modify a specific commit, use `git rebase -i SOME_COMMIT_ID^` instead.
  git will popup a vi window to let you do modification on commits, press 
  `:wq` after done.
  
  * Reword a commit
  
    Change the `pick` before the commit you want to reword to `edit` and edit 
    its message in popup vi window.
    
  * Squashing commits
  
    Change the `pick` before the commit you want to squach to `squash` and edit 
    the commit message after squash in a following popup vi window. A commit 
    will be squashed with its previous commit.
    
  * Reordering commits
  
    Reordering them in this vi window will reorder the commits.

* Amend a commit

  You can commit first and rebase it in the previous section. Or if you want to
  amend most recent commit, you can: `git commit some_file --amend`.
  
* Deleting a commit

  You can delete commits by delete corresponding lines in `git rebase`. Or if
  you want to delete most recent commit, you can `git reset --hard HEAD^`. If you
  want to go back to a specific commit and delete commits after that, use
  `git reset --hard commit-hash`.
  
* Uncommit a file from an existing commit

  ```
  git reset HEAD^ path/to/file/to/revert
  git commit --amend
  ```

## TODO

* Rails style guide see https://github.com/bbatsov/rails-style-guide
* Bugzilla how-to
  * how to copy commit details / clone a ticket

# License

![Creative Commons License](http://i.creativecommons.org/l/by/3.0/88x31.png)
This work is licensed under a [Creative Commons Attribution 3.0 Unported
License](http://creativecommons.org/licenses/by/3.0/deed.en_US)
