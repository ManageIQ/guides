### Breadcrumbs

Breadcrumbs help to expose the hierarchy, not the particular clicks of a user.

##### Table of Contents
- [Breadcrumbs](#breadcrumbs)
    - [Table of Contents](#table-of-contents)
- [Usage](#usage)
  - [Breadcrumbs](#breadcrumbs-1)
- [Structure](#structure)
  - [Non-explorer controllers](#non-explorer-controllers)
    - [Default list](#default-list)
    - [Detail](#detail)
    - [Action](#action)
  - [Explorer controllers](#explorer-controllers)
    - [Default + detail view](#default--detail-view)
    - [Action](#action-1)
- [Design](#design)
- [Examples](#examples)
  - [1) Explorer screens](#1-explorer-screens)
  - [2) Non-explorer screens](#2-non-explorer-screens)

### Usage

Breadcrumbs are automatically generated from information collected in the controller. To allow generating the breadcrumbs, a controller should include the Breadcrumbs mixin:

`include Mixins::BreadcrumbMixin`

and then it has to define a new method which returns a hash with variables depended on the controller and its type.

```ruby
def breadcrumbs_options
    {
    :breadcrumbs    => ...,
    :include_record => ...,
    :record_info    => ...,
    :record_title   => ...,
    }
end
```

|option|type|default|type of controller|description|
|:-----|:--:|:-----:|:----------------:|----------:|
|`:breadcrumbs`|array|**required**|all|Initial sets of breadcrumbs. Should include the menu path.|
|`:record_info`|hash|`@record`|both|Object where currently shown record is stored.|
|`:record_title`|symbol|`:name`|both|Attribute of the `:record_info` object, which will be used as a title in breadcrumbs.|
|`:include_record`|bool|`false`|both|Will use `:record_info` for creating the item breadcrumb.|
|`:hide_title`|bool|`false`|non-explorer|Will not append `@title` to breadcrumbs.|
|`:ancestry`|Class|`nil`|explorer|Parent class for ancestry. Used in `service` controller|
|`:not_tree`|bool|`false`|explorer|This sets that the controller is not explorer. It should be used in controllers used in more places which someones do not use the explorer presenter.|
|`:disable_tree`|bool|`false`|explorer|Will disable all links in breadcrumbs.|
|`:to_explorer`|string|`nil`|explorer|Link to the explorer page. Will be appended to the penultimate breadcrumb when `:disable_tree` is set.|
|`:x_node`|string|`x_node`|explorer|Use custom node id instead of default `x_node`.|

#### Breadcrumbs
```ruby
{
:breadcrumbs => [
  { :title => ... , :url => ?, :key => ? }
  ]
}
```

The path in the main navigation menu.

Hash consists of:

```ruby
{
    :title  => _('Cloud Providers'), # Title of the breadcrumb
    :url    => controller_url,       # URL to the controller
    :key    => 'root',               # ID in the tree view, only explorer controllers
}
```

### Structure

#### Non-explorer controllers

Non-explorer controllers should have this structure:

`show_list` > `show` > `action`

- On `show_list` the title is not appended, because the title from the menu path is used.
- On `show` the `:record_info` is not used by default, because the `@title` of the page serves as a title in the last breadcrumb.
- On `action` the `:record_info` is used to generate item breadcrumb and `@title` is used as an action breadcrumb.

##### Default list

`[MENU]`

ex. `Compute` > `Infrastructure` > `Hosts / Nodes`

When the title of the page is different from the last item in the main navigation, the navigation title is used as the breadcrumb title.

##### Detail

`[MENU]` > `[ITEM TITLE]`

ex. `Compute` > `Infrastructure` > `Hosts / Nodes` > `17d6ec2e-0e75-45ab-95a6-642eb41855cd (Controller) (Summary)`

The whole title is used (with `Summary`, `Dashboard`)

##### Action

`[MENU]` > `[ITEM TITLE]` > `[ACTION HEADER]`

ex. `Compute` > `Infrastructure` > `Hosts / Nodes` > `17d6ec2e-0e75-45ab-95a6-642eb41855cd (Controller)` > `Info/Settings`

Notice the item title is now without the appendix (`Summary`, `Dashboard`). That is correct.

Breadcrumbs should not be deeper than this.

#### Explorer controllers

##### Default + detail view

`[MENU]` > `[ACCORDION TITLE]` > `[CURRENT NODE TEXT]`

ex. `Compute` > `Infrastructure` > `Virtual Machines` > `VMs & Templates` > `All VMs & Templates`

Accordion title should lead to the tree's root.

**! Breadcrumbs do not contain the whole tree path currently !**

##### Action

`[MENU]` > `[ACCORDION TITLE]` > `[CURRENT NODE TEXT]` > `[ACTION TITLE]`

ex. `Compute` > `Infrastructure` > `Virtual Machines` > `VMs & Templates` > `3.9ocp` > `Editing Virtual Machine "3.9ocp"`

As a `action title` it used one of these variables (sorted by the highest priority):
- `right_cell_text` as a local variable provided to the breadcrumbs template (if you provide it in `replace_right_cell` method)
- `@title_for_breadcrumbs` (non standard use)
- `@right_cell_text` (standard use)
- `@title` (explorer controller switched to non-explorer)

Breadcrumbs should not be deeper than this.

### [Design](https://www.patternfly.org/pattern-library/navigation/breadcrumbs/)
- this design follows [Patternfly guidelines](https://www.patternfly.org/pattern-library/navigation/breadcrumbs/)
- First, show the path from the navigation (E.g.: Compute > Infrastructure > Providers)
- Only breadcrumbs which lead somewhere should be clickable (last breadcrumb in the menu, etc.)
- The end of the breadcrumb string should represent the page a user is currently viewing.
- When using breadcrumbs, be sure to include them on every page throughout the application.
  - Exception: when content is shown on in a separate window without navigation (ex. reports), breadcrumbs are not required.


![breadcrumbs](https://user-images.githubusercontent.com/36040135/57836403-e6bbbc00-77c0-11e9-8f13-26b1dbef2633.png)

### Examples
#### 1) Explorer screens

**Default**

![Screenshot from 2019-10-02 13-18-24](https://user-images.githubusercontent.com/32869456/66040960-fd1ca700-e518-11e9-80ae-3702f7de7d65.png)

**Detail**

![Screenshot from 2019-10-02 13-18-48](https://user-images.githubusercontent.com/32869456/66040958-fc841080-e518-11e9-907e-718d14ce5dce.png)

**Action**

![Screenshot from 2019-10-02 13-18-59](https://user-images.githubusercontent.com/32869456/66040957-fc841080-e518-11e9-8959-fbba06feb988.png)


**Tagging/Ownership/etc.**
- Show the item breadcrumb only when there is only one item

One item

![Screenshot from 2019-10-02 13-21-03](https://user-images.githubusercontent.com/32869456/66040956-fc841080-e518-11e9-98d2-c143a0d02198.png)


More items

![Screenshot from 2019-10-02 13-22-32](https://user-images.githubusercontent.com/32869456/66040954-fc841080-e518-11e9-8321-1e3ce1da30fe.png)



**Ancestry**

![image](https://user-images.githubusercontent.com/32869456/56895268-e6b18180-6a88-11e9-8d7b-12ffbb3f889d.png)

- only Services. Services are missing hierarchy in the tree (because of performance).

#### 2) Non-explorer screens

**Default**

![Screenshot from 2019-10-02 13-36-07](https://user-images.githubusercontent.com/32869456/66041374-ff333580-e519-11e9-96c2-0d9440195153.png)

- There could be a different header on the landing page - that is a longer version of the item in the menu. Breadcrumbs should contain the same name as in the menu - the shorter version.

**Detail**
![Screenshot from 2019-10-02 13-36-42](https://user-images.githubusercontent.com/32869456/66041373-ff333580-e519-11e9-8d6c-716826b8eca1.png)

**Detail Action/Action**

![Screenshot from 2019-10-02 13-37-03](https://user-images.githubusercontent.com/32869456/66041372-fe9a9f00-e519-11e9-9da3-ec8bb5a18cd1.png)

**Tagging/Ownership/etc.**
- Show item breadcrumb only when there is only one item

One item
![Screenshot from 2019-10-02 13-37-35](https://user-images.githubusercontent.com/32869456/66041371-fe9a9f00-e519-11e9-8580-e70e8ea44f41.png)

More items
![Screenshot from 2019-10-02 13-38-40](https://user-images.githubusercontent.com/32869456/66041370-fe9a9f00-e519-11e9-82d9-39ec6df5c89e.png)