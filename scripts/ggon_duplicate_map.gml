/** Dupes a map. This does NOT work for maps with non-string keys
 * argument[0]: The map you want to duplictate.
 * [argument[1]]: A 2nd map to duplicate the previous one into. An empty one will be create if this parameter is left empty.
 * Returns a duplicated map.
*/

var key, map;
if (argument[1] > 0) map = argument[1];
else map = ds_map_create();

for(key=ds_map_find_first(argument[0]); is_string(key); key = ds_map_find_next(argument[0], key)) {
    ds_map_add(map, key, ds_map_find_value(argument[0], key));
}

return map;
