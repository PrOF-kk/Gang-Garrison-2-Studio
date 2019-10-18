    // Record destruction in killlog
    // argument[0]: The owner of the destroyed building
    // argument[1]: The killer
    // argument[2]: The healer, or -1 for no assist
    // argument[3]: The source of the damage (e.g. DAMAGE_SOURCE_SCATTERGUN)
      
        with (KillLog) {
            map = ds_map_create();
			
            if (!argument[1] || argument[1] == argument[0]) {
                ds_map_add(map, "name1", "");
                ds_map_add(map, "team1", 0);
            }
            else {
                var killer;
                killer = string_copy(argument[1].name, 1, 20);
                if (instance_exists(argument[2]))
                    killer += " + " + string_copy(argument[2].name, 1, 20);
                ds_map_add(map, "name1", killer);
                ds_map_add(map, "team1", argument[1].team);
			}
            
            if(argument[3] == DAMAGE_SOURCE_BID_FAREWELL)
            {
                ds_map_add(map, "name2", "");
                ds_map_add(map, "team2", 0);
            }
            else
            {
                ds_map_add(map, "name2", "Autogun (" + string_copy(argument[0].name, 1, 20) + ")");
                ds_map_add(map, "team2", argument[0].team);
            }
            
            if (argument[0] == global.myself || argument[1] == global.myself || argument[2] == global.myself) 
                ds_map_add(map, "inthis", true);
            else ds_map_add(map, "inthis", false);
            
            ds_map_add(map, "weapon", findDamageSourceIcon(argument[3]));
            
            switch(argument[3]) {
                case DAMAGE_SOURCE_FINISHED_OFF:
                case DAMAGE_SOURCE_FINISHED_OFF_GIB:
                    ds_map_add(map, "string", "finished off ");
                    break;
                case DAMAGE_SOURCE_BID_FAREWELL:
                    ds_map_add(map, "string", string_copy(argument[0].name, 1, 20) + " bid farewell, cruel world!");
                    break;
                default:
                    ds_map_add(map, "string", "");
                    break;
            }
            
            ds_list_add(kills, map);
            
            if (ds_list_size(kills) > 5) {
                ds_map_destroy(ds_list_find_value(kills, 0));
                ds_list_delete(kills, 0);
            }
            
            alarm[0] = 30*5 / global.delta_factor;
        }
