Guides
======

Coding style and standards

High level guidelines:

* Be consistent.
* This guide describes general guidelines to follow for new code.
* Prefer readability over performance and conciseness until you can't.
* If you can convince others why we should violate a guideline, then violate the guideline.

Commits:

* Keep commits small by committing often and only include related changes/tests together.
* Squash(combine) commits to keep logical units of changes grouped together in the same commit.  Don't squash unrelated changes.
* Avoid mixing logical changes with style changes of unrelated code.  Keep them as separate commits or pull request.
* Make logical changes in one commit.  Modify the style of the changed code in another commit.  If the style change makes it hard to see the logical change, do the style change in a different pull request.
* Move a method in one commit.  Modify the moved method in another commit.  If the moved method has high churn(change), perhaps move the method in a separate pull request.
* Write a [good commit message](http://goo.gl/w11us).

Pull Requests:

* All pull requests should have tests or mention that there are existing tests that cover your code changes.
* Avoid large pull requests (1000+ lines changed minus any generated files such as test data).
* Use a feature branch with a descriptive name as they are included in our git history: change_ems_amazon_to_be_region_specific (good), faster_tests(not so good).

