/**
 * Adds a button to the GUI
 * argument[0]: Button text
 * argument[1]: The code that gets executed when the button is clicked, executes twice for toggles with argument[0] as the toggle value
 * [argument[2]]: Make the button a toggle
 * [argument[3]]: Button is active by default (if it's a toggle)
*/

var map, toggle, active;
toggle = 0;
active = 0;
map = ds_map_create();

if (argument_count > 2)
    toggle = argument[2];
if (argument_count > 3)
    active = argument[3];

ds_map_add(map, "name", argument[0]);
ds_map_add(map, "code", argument[1]);
ds_map_add(map, "toggle", toggle);
ds_map_add(map, "active", active);

ds_list_add(global.buttons, map);
