/** 
 * Places an entity at the given x/y position with given x/y scales
 * argument[0]: X position
 * argument[1]: Y position
 * argument[2]: X scale
 * argument[3]: Y scale
 * [argument[4]]: Whether it's a mirrored entity
*/

with(Builder)
{
    var entity, isMirrored;  
    entity = instance_create(argument[0], argument[1], LevelEntity);

    isMirrored = 0;
    if (argument_count > 4)
        isMirrored = argument[4];
    
    if (isMirrored)
    {
        entity.type = ds_list_find_value(global.entities, mirrored);
        entity.sprite_index = mirroredSprite;
        entity.image_index = mirroredImage;
    }
    else 
    {
        entity.type = ds_list_find_value(global.entities, entityButtons[selected, INDEX]);
        entity.sprite_index = selectedSprite;
        entity.image_index = selectedImage;
    }
        
    entity.image_xscale = argument[2];
    entity.image_yscale = argument[3];
    
    if (ds_map_size(newProperties) > 0)
    {
        entity.properties = ggon_duplicate_map(newProperties);
        
        // Use the correct sprite for entities with external sprites.
        var resource;
        resource = ds_map_find_value(entity.properties, "resource");
        sprite = ds_map_find_value(global.resources, resource);
        if (sprite > 0)
        {
            entity.sprite_index = sprite;
            entity.image_index = 0;
        }
    }
}
