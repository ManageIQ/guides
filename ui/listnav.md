### Listnavs

Listnavs are the left parts of the non-explorer screens. They typically contain information about entities and their relationships organized into accordions.
Listnavs are defined under `app/views/layouts/listnav/`.

```
- if @record.try(:name)
  #accordion.panel-group
    = miq_accordion_panel(truncate(@record.name, :length => truncate_length), true, "icon") do
      = render_quadicon(@record, :mode => :icon, :size => 72, :typ => :listnav)

    = miq_accordion_panel(_("Properties"), false, "container_node_prop") do
      %ul.nav.nav-pills.nav-stacked
        %li
          = link_to(_('Summary'), {:action => 'show', :id => @record, :display => 'main'}, :title => _("Show Summary"))

...


    = miq_accordion_panel(_("Relationships"), false, "container_node_rel") do
      %ul.nav.nav-pills.nav-stacked
        = single_relationship_link(@record, :ems_container, "ext_management_system")
```

Notice the use of helper methods `miq_accordion_panel`, `single_relationship_link` and more.
