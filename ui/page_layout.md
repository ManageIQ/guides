### Page Layout

Almost all screens consist of the main menu, top right menu (see [Menus](menus.md))
 and content area.

Content area has usually [toolbars](toolbars.md) on top and 2 parts:
 * left panel and
 * main content.

We have 2 main variations of the layout:
 * Explorer and
 * Non explorer.

#### Explorer

Explorer layout screens have one or more accordions with [trees](trees.md) in the left
panel. Explorer screens are usually JSON and RJS driven, they don't refresh
fully on click. These screens make heavy use of `ExplorerPresenter` -- a class
that encapsulates the DOM manipulation on these screens.

#### Non-explorer
Non-explorer layout screen have [listnavs](listnav.md) in one or more accordions on the
left side and mostly do a full reload on each click (unless in a form or
Angular form).

#### Main Content

There are 2 very typical types of content for the main content area:

 * [GTL](gtl.md),
 * [Textual summaries](textual_summary.md).


