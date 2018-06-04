# RBAC

![RBAC](images/rbac.svg)

## How it works

RBAC in ManageIQ is split into 2 parts; what you can "see" and what you can "do".  All user interaction first pass through the first layer of things you can "see" based on a number of criteria.  On those objects, then, only a certain subset of actions are allowed based on what you can "do".

At the heart of the RBAC system are Users and Groups.  A user can belong to multiple groups, and while a user is interacting with ManageIQ there is the notion of a "current" group.  Only the current group's permission set will apply during that session, or until the "current" group is changed.  Both a user and a group can directly "own" resources in the system.

A Group belongs to a Tenant.  Tenants are a hierarchical structure above groups with inheritance rules for the resources they "own".

A Group is mapped to a Role, and a Role is a collection of a number of Product Features and Entitlements.  Product Features are the things you can "do" with the system.  Entitlements are a set of ways of grouping resources such that a user can "see" them.

## What you can "see"

The resources a user can see are decided from a number of sources.

- Ownership

  A resource in ManageIQ can be directly owned by a User or Group.  A resource can additionally be owned by a tenant.  All objects directly owned by a user or owned by the user's current group can be seen.

- Tenancy

  Tenancy ownership in ManageIQ is determined by first a direct ownership to a resource, and then applying certain "ancestor" or "descendant" rules depending on the type of resource being viewed.

  For example, a member of a tenant can only see virtual templates owned by their tenant or owned by any parent tenants.  This "ancestor" view in used to allow for sharing a virtual template across multiple child tenants.  In contrary, a member of a tenant can only see virtual machine instances owned by their tenant or owned by any child tenants.  This "descendant" view is used to allow the parent tenant to do accounting of all running virtual machines instances below them.

- Entitlements
  - managed tags

    A user can be given access to various resources by allowing them to view tagged resources.  A user is given access to a "managed tag", and any resource tagged with it can be seen.

  - belongs to

    A user can be given access to various resources based on the resource hierarchy from the provider.  For example, a user can be given access to a virtual infrastructure Cluster.  In doing, so any child host or virtual machine instance that "belongs to" that Cluster can be see by the user.

- Match via descendants

  In a resource hierarchy a user may only have access to see the lowest level of resources, but in some instances, particularly for presentation purposes, the parent resources may need to be displayed even though the user does not have access to them directly.  For example, the UI may wish to present the folder hierarchy that a virtual machine instance lives under, but the user does not have access to those folders directly.  In this case, the UI may request the folders based on a "match via descendant" virtual machines.  That is, the user will be given the ability to see only those parent folders of the child virtual machines they can see.

These various sources are combined together in the following expression






### Ownership
