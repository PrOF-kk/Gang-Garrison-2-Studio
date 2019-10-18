    // Record domination in killlog
    // argument[0]: The killed player  
    // argument[1]: The Dominating player
    // argument[2]: 0 for DOMINATION, 1 for REVENGE
        
        with (KillLog) {
            map = ds_map_create(); 
            var killer, victim, inthis;
            victim = string_copy(argument[0].name, 1, 20);
            killer = string_copy(argument[1].name, 1, 20);
            inthis = false;
            if (argument[0] == global.myself) || (argument[1] == global.myself) {
                inthis = true;
                if (!argument[2])
                    sound_play(DominationSnd);
                else
                    sound_play(RevengeSnd);
            }
            ds_map_add(map, "name1", killer);
            ds_map_add(map, "team1", argument[1].team);
            ds_map_add(map, "weapon", DominationKL);
            if (!argument[2])
                ds_map_add(map, "string", "is DOMINATING ");
            else
                ds_map_add(map, "string", "got REVENGE on ");
            ds_map_add(map, "name2", victim);
            ds_map_add(map, "team2", argument[0].team);
            ds_map_add(map, "inthis", inthis);
                        
            ds_list_add(kills, map);
            
            if (ds_list_size(kills) > 5) {
                ds_map_destroy(ds_list_find_value(kills, 0));
                ds_list_delete(kills, 0);
            }
            
            alarm[0] = 30*5 / global.delta_factor;
        }
