/**
 * Adds a gamemode to garrison builder
 * argument[0]: The name
 * [argument[1]]: A string that returns true when the gamemode has the correct entities.
 * [argument[2]]: An error message in case the string above returned false.
 * Returns: An identifier for that gamemode
*/

var map, code, error;

code = 0;
error = 0;

if (argument_count > 1)
    code = argument[1];
if (argument_count > 2)
    error = argument[2];

map = ds_map_create();
ds_map_add(map, "name", argument[0]);
ds_map_add(map, "code", code);
ds_map_add(map, "error", error);
ds_list_add(global.gamemodes, map);

return power(2, ds_list_size(global.gamemodes)-1);
