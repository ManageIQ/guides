# Skinning in ManageIQ Service UI

## How skinning works

A skin is a directory containing images, styles and (js) texts, that can be linked into an Service UI instance to alter the look of the application, overriding the default theme.

A sample skin exists in the Service UI code base, under the `skin-sample` directory.

Images need to exist under the `images/` subdirectory of the skin, any image in there will override any images from `client/assets/images`. Of course, adding a new one and referencing it from the css (`url(../images/foo.png)` being the preferred way) is possible too.

Styles live in `*.css` files, directly in the skin directory. These get concatenated and included last.

To override certain hardcoded strings (currently only the product name, and the login screen branding) a skin may also contain `*.js` files, also included last, which should be used to provide an angular `constant` named `Text` in the `app.skin` module. (See `client/app/skin/skin.module.js` for details.) This feature may also be used to override other code in the application, but that is neither supported, nor recommended.


## How to apply a skin

Simple! Just run `./link.sh` in the skin directory, optionally supplying the path to the Service UI directory (ie. something that includes the `client/` and `server/` subdirectories).

To undo this, run `./unlink.sh`.

What these scripts do, is to create a symlink from `client/skin` to this skin's directory.

All you need to do after is `gulp build`, or restart the development server.


## How to override an image

Just put an identically named image in the `images/` subdirectory of the skin. It will overwrite the image copied from `client/assets/images` during the build.


### Known images (that you may want to override)

For up-to-date info, please see the `client/assets/images` directory.

   * `bg-login.png`, `bg-login-2.png` - login screen backgrounds
   * `bg-modal-about-pf.png` - background for the About dialog
   * `bg-navbar.png` - background for the top navbar
   * `brand.svg` - the application logo used in the navbar
   * `login-screen-logo.png` - login screen logo, also used in the About dialog


## How to override a style

Simply add a css file in the skin, it will get included last, and so will override any identical selectors. Feel free to use `!important` but use with care.


## How to override a text label

Provide a JS file that introduces an angular `constant` named `Text`. It should be an object of objects, see below for the list of fields.


### Known labels

For up-to-date info, please see the `client/app/skin/skin.module.js` file.

   * `Text.app.name` - the name of the application
   * `Text.login.brand` - HTML for the brand name on the login page
