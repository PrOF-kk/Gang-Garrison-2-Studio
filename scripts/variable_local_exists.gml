//argument0 id of variable owner's instance
//argument1 variable name
//Store id + variable name in a list to allow tracking multiple variables per instance
//without using a ds_grid
if (ds_list_find_index(global.localVariables, string(argument0) + argument1) != -1)
    return true;
return false;

