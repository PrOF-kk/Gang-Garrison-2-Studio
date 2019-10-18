/**
 * Adds a button to the GUI
 * argument[0]: Button text
 * argument[1]: The code that gets executed when the button is clicked, executes twice for toggles with argument[0] as the toggle value
 * [argument[2]]: Make the button a toggle
 * [argument[3]]: Button is active by default (if it's a toggle)
*/

var map;
map = ds_map_create();
ds_map_add(map, "name", argument[0]);
ds_map_add(map, "code", argument[1]);
ds_map_add(map, "toggle", argument[2]);
ds_map_add(map, "active", argument[3]);

ds_list_add(global.buttons, map);
