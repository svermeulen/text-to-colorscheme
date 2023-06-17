
# Building

The plugin is implemented using the [teal language](https://github.com/teal-language/tl).  The source files are in the `teal/src/` directory.  These files are compiled by teal and then output to he `lua/` directory, which is where they need to be for vim to find them.  This means that every teal file also has its generated lua file committed to this repo as well.

This also means that any changes should only be made to the teal files, and the lua files should be generated from this.

To update the lua files:
* Install [luarocks](https://luarocks.org/)
* Install [cyan](https://github.com/teal-language/cyan)
* Execute `teal/scripts/build` script

