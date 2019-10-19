//argument0 id of caller instance
//argument1 name of variable to remove from tracking
//Should usually be called in destroy event
ds_list_delete(global.localVariables, string(argument0) + argument1);
