/**
 * Adds an entity button to the GUI
 * argument[0]: The name
 * argument[1]: The gamemodes that this entity can be used on (uses bitmasks to select multiple gamemodes)
 * argument[2]: A ggon string with all properties that can be editted.
 * argument[3]: The object that gets created ingame.
 * argument[4]: The sprite of the entity.
 * argument[5]: The image index of the entity sprite.
 * argument[6]: The sprite of the button.
 * argument[7]: The image index of the button sprite.
 * [argument[8]]: Tooltip
 * Returns: An identifier for the entity button
*/

var index, map;

// Prevent dupes
index = ds_list_find_index(global.entities, argument[0]);
if (index != -1) {
    if (ds_map_find_value(ds_list_find_value(global.entityData, index), "gamemode") == argument[1]) return index;
}

index = ds_list_size(global.entities);
ds_list_add(global.entities, argument[0]);

map = ds_map_create();
ds_map_add(map, "gamemode", argument[1]);
ds_map_add(map, "object", argument[3]);
ds_map_add(map, "entity_sprite", argument[4]);
ds_map_add(map, "entity_image", argument[5]);
ds_map_add(map, "button_sprite", argument[6]);
ds_map_add(map, "button_image", argument[7]);
ds_map_add(map, "tooltip", argument[8]);
ds_map_add(map, "properties", ggon_decode(argument[2]));

ds_list_add(global.entityData, map);

return index;
