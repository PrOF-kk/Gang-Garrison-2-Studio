/**
 * Gives all entity data based on an entity name
 * argument[0]: The entity name
 * Returns a map containing the data of that entity
*/

var index;
index = ds_list_find_index(global.entities, argument[0]);
if (index == -1) return -1;

return ds_list_find_value(global.entityData, index);
