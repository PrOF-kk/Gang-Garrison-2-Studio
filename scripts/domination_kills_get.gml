//Returns the number of kills corresponding to a player
//Arg0: domination_kills table
//Arg1: Player
if (ds_map_exists(argument[0], argument[1]))
    return ds_map_find_value(argument[0], argument[1]);
else
    return 0;
