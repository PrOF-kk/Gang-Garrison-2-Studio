//Sets the player's corresponding number of kills
//Arg0: domination_kills table
//Arg1: Player
//Arg2: Value
if (ds_map_exists(argument[0], argument[1]))
    ds_map_replace(argument[0], argument[1], argument[2]);
else
    ds_map_add(argument[0], argument[1], argument[2]);
