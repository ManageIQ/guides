# Reviewer's guidelines

We have some technical debt that is continuously being refactored.
However, it's possible that someone is getting inspired by wrong pattern that still lays in the codebase.
In such case the reviewer might not be aware of _The Right Way_ and approves the changes.

This can cause a significant growth in technical debt. As it is complicated to track all the ongoing refactoring approaches,
this document is intended to summarize common pitfalls and also good examples.

**Please update this document with simple `wrong` and `right` examples that you are aware of.**

**When doing reviews, please try to go through these examples to prevent introducing technical debt**

Thank you, happy reviewers!

## ManageIQ/manageiq-ui-classic

### Testing RBAC on checked items

Make sure, the introduced code is checking the permissions on items checked in UI.
There is a list of classes, that support RBAC check in [`CLASSES_THAT_PARTICIPATE_IN_RBAC`](https://github.com/ManageIQ/manageiq/blob/master/lib/rbac/filterer.rb#L8)

```ruby
# =====
# wrong
# =====
if @lastaction == "show_list" || (@lastaction == "show" && @layout != "cloud_network") || @lastaction.nil?
  find_checked_items
else
  [params[:id]]
end
```

Also, we still have 5 different _(deprecated)_ methods spread in the UI code for doing RBAC check, that basically do the same thing, just for different cases.

```ruby
# =====
# wrong
# =====
if @lastaction == "show_list" || (@lastaction == "show" && @layout != "cloud_subnet") || @lastaction.nil?
  find_checked_records_with_rbac(CloudSubnet)
else
  [find_record_with_rbac(CloudSubnet, params[:id])]
end
```

For checking the permissions on the particular items, please use `find_records_with_rbac` method.
_related issue: https://github.com/ManageIQ/manageiq-ui-classic/issues/1134_

```ruby
# =====
# right
# =====
find_records_with_rbac(CloudSubnet, checked_or_params)
```

In case you want to check a single item, please use `find_record_with_rbac`, added in (https://github.com/ManageIQ/manageiq-ui-classic/pull/1636):

```ruby
# =====
# right
# =====
find_record_with_rbac(CloudSubnet, checked_or_params)
```

more info:
http://manageiq.org/docs/guides/ui/rbac_features

#### Double checking loaded records

In [manageiq-ui-classic/pull/3131](https://github.com/ManageIQ/manageiq-ui-classic/pull/3131) the behavior of the fetching method was changed.

In case that no records are found, the method raises an `ActiveRecord::RecordNotFound` exception.

That means the double checking the variable with loaded records is not necessary, and therefore can be removed.

```diff
     scheds = find_records_with_rbac(MiqSchedule, checked_or_params)
-    if scheds.empty?
-      add_flash(msg1, :error)
-      javascript_flash
-    end
```
