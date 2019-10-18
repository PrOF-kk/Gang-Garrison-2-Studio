/**
 * Adds a gamemode to garrison builder
 * argument[0]: The name
 * [argument[1]]: A string that returns true when the gamemode has the correct entities.
 * [argument[2]]: An error message in case the string above returned false.
 * Returns: An identifier for that gamemode
*/

var map;
map = ds_map_create();
ds_map_add(map, "name", argument[0]);
ds_map_add(map, "code", argument[1]);
ds_map_add(map, "error", argument[2]);
ds_list_add(global.gamemodes, map);

return power(2, ds_list_size(global.gamemodes)-1);
