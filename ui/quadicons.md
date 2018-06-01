### Quadicons

Quadicons are a condensed graphical way to represent information about various entities and their relations.
Quadicons are present, but not limited to Explorer trees, GTLs and Listnavs.

Example: 4 VM quadicons:
![Textual Summary Example](../images/quadicon.png)

The definition of quadicons is stored as methods in model decorators under the `app/decorators` folder.
The single icon definition should be defined as `single_quad` while the 4-view version should be `quadicon`.
At least the `single_quad` method needs to be defined as this is both the default and the fallback.

```ruby
def quadicon
  {
    :top_left => {
      :fonticon => 'fa fa-play',
      :color   => 'green',
      :tooltip => 'some tooltip'
    },
    :top_right => {
      :fileicon => '/assets/svg/something.svg',
      :tooltip => 'some other tooltip'
    },
    :bottom_left => {
      :text => 'T',
      :background => 'blue',
      :tooltip => 'you should put tooltips on each quad'
    },
    :bottom_right => {
      :text => '4000004',
      :tooltip => 'numbers will be shortened using numeral.js'
    }
  }
end

def single_quad
  {
    :fileicon => '/assets/svg/something.svg',
    :tooltip => 'hello world'
  }
end
```

The decorators should not inherit from each other and everything has to be as explicit as possible. Any common behavior that affects all of the quadicons should be moved into a static method in `app/helpers/quadicon_helper.rb`, see `QuadiconHelper.machine_state` as an example.

TODO: documentation for quad/single icon selection process

