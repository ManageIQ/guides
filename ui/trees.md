### Trees

Trees are displayed in various places in the UI. Most notable are trees in explorer-like pages. Other examples include the snapshot tree for VMs and RBAC feature tree under Settings/Access Controll/Roles.

Trees are built using `TreeBuilder` subclasses located in `app/presenters/tree_builder*`.

Example tree builder:
```
class TreeBuilderInstances < TreeBuilder
  has_kids_for AvailabilityZone, [:x_get_tree_az_kids]
  has_kids_for ExtManagementSystem, [:x_get_tree_ems_kids]

  include TreeBuilderArchived

  def tree_init_options(_tree_name)
    {
      :leaf => 'VmCloud'
    }
  end

  def set_locals_for_render
    locals = super
    locals.merge!(
      :tree_id   => "instances_treebox",
      :tree_name => "instances_tree",
      :autoload  => true
    )
  end

  def root_options
    [_("Instances by Provider"), _("All Instances by Provider that I can see")]
  end

  def x_get_tree_roots(count_only, _options)
    count_only_or_objects_filtered(count_only, EmsCloud, "name", :match_via_descendants => VmCloud) +
      count_only_or_objects(count_only, x_get_tree_arch_orph_nodes("Instances"))
  end

  def x_get_tree_ems_kids(object, count_only)
    count_only_or_objects_filtered(count_only, object.availability_zones, "name") +
      count_only_or_objects_filtered(count_only, object.vms.where(:availability_zone_id => nil), "name")
  end

  # Get AvailabilityZone children count/array
  def x_get_tree_az_kids(object, count_only)
    count_only_or_objects_filtered(count_only, object.vms.not_archived_nor_orphaned, "name")
  end
end

```
 * `x_get_tree_roots` describes the root element(s) of the tree.
 * `has_kids_for` is used to declare non-root branches in the tree and methods that produce those.

Rules for buiding particular tree nodes are in `TreeNodeBuilder` and it's subclasses in `app/presenters/tree_node_builder*`.

Trees in explorer screens are wrapped in accordions. The list of accordions with trees in a particular controller is specified via "features".

Example:
```
def features
  [
    ApplicationController::Feature.new_with_hash(
      :role  => "vandt_accord",
      :name  => :vandt,
      :title => _("VMs & Templates")),

    ApplicationController::Feature.new_with_hash(
      :role  => "vms_filter_accord",
      :name  => :vms_filter,
      :title => _("VMs"),),

    ApplicationController::Feature.new_with_hash(
      :role  => "templates_filter_accord",
      :name  => :templates_filter,
      :title => _("Templates"),),
  ]
end
```
