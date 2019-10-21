// argument[0] - x position
// argument[1] - y position
// argument[2] - width
// argument[3] - valueoffset
// argument[4] - spacing
// [argument[5]] - tab offset (upwards) [thanks GM for making unset args default to 0!!!11]
// [argument[6]] - tab spacing
// [argument[7]] - tab margin

virtualitem = -1;
xbegin = argument[0];
ybegin = argument[1];
width = argument[2];
valueoffset = argument[3];
spacing = argument[4];

taboffset = 0;
tabspacing = 0;
tabmargin = 0;
if (argument_count > 5)
    taboffset = argument[5];
if (argument_count > 6)
    tabspacing = argument[6];
if (argument_count > 7)
    tabmargin = argument[7];

items = 0;
tabs = 0;
editing = -1;
dimmed = false;
stepHasRun = false;
drawbg = false;
getsHighlight = true;
bgtabs = false;
menumode = false;
screenheight = 600;

// Hack: The back button should usually appear last in the menu, even if plugins
// add new items later, so we treat it separately.
menu_script_back = "";
menu_text_back = "";
