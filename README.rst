podreader - A curses TUI to read Perl POD from.

podreader is a curses TUI that displays a list of Perl modules. When a module is
selected, the perldoc(1) command is called to display its documentation.

********
Synopsis
********

podreader [-hm] [/some /directory ...]

.. code-block:: perl

   -m|--man          display man page
   -h|--help         display help
 
   [directory list]  search .pm files in said directories (optional)
 
   podreader looks for .pm files in @INC by default.

**********
Keystrokes
**********

Use the following keystrokes to navigate around the UI.

- Up/Down
 
 Move the cursor up or down.
 
- Enter/Space
 
 Confirm selection.
 
- Ctrl+q
 
 Quit the UI.
 
- /
 
 Small search box to look for an item in the list. Type a string and hit enter.
 
- n or N
 
 Go to the next/previous result in the list (if any).
 
*****
Mouse
*****

Mouse support is enabled and should work. Click on a file in the list to
display its documentation (if it exists of course).

********
See also
********

perldoc(1)

******
Author
******

Patrice Clement <monsieurp at cpan.org>

*********************
License and copyright
*********************

This software is copyright (c) 2021 by Patrice Clement.

This is free software, licensed under the (three-clause) BSD License.

See the LICENSE file.
