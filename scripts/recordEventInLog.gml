    // Record event in killlog
    // argument[0]: The type of event 1=capped point 2=defended point
    //            3=intel capped 4=intel defended 5=intel dropped
    //            6=taken intel 7=generator destoyed  8=intel returned
    // argument[1]: The team
    // argument[2]: The player(s) name(s)
    // argument[3]: Am I involved?
        var message, sprite, icon, name, action;
        message = "";
        sprite = -1;
        icon = "";
        name = argument[2];
        action = "";
        if argument[0]==1 { 
            message = "captured the point!";
            icon = "capture";
        }
        else if argument[0]==2 {
            message= "defended the point!";
            icon = "defense";
        }
        else if argument[0]==3 {
            message = "captured the intelligence!";
            icon = "capture";
        }
        else if argument[0]==4 {
            message = "defended the intelligence!";
            icon = "defense";
        }
        else if argument[0]==5 {
            action = " dropped the intelligence!";
        }
        else if argument[0]==6 {
            //message = " has taken the intelligence!";
            message = "picked up the intelligence!";
            icon = "capture";
        }
        else if argument[0]==7 {
            if argument[1]==TEAM_RED name = "Red team";
            else if argument[1]==TEAM_BLUE name = "Blue team";
            action = " has destroyed the enemy generator!";
        }
        else if argument[0]==8 {
            if argument[1]==TEAM_RED name = "Red";
            else if argument[1]==TEAM_BLUE name = "Blue";
            action = " Intel has returned to base!";
            //icon = "intel"; Commented out until a suitable sprite is found
        }
        if icon == "capture" {
            if argument[1]==TEAM_RED sprite = RedCaptureS;
            else if argument[1]==TEAM_BLUE sprite = BlueCaptureS;
        } else if icon == "defense" {
            if argument[1]==TEAM_RED sprite = RedDefenseS;
            else if argument[1]==TEAM_BLUE sprite = BlueDefenseS;
        } else if icon == "intel" {
            if argument[1]==TEAM_RED sprite = RedIntelSL;
            else if argument[1]==TEAM_BLUE sprite = BlueIntelSL;
        }
        
        with (KillLog) {
            map = ds_map_create();
            ds_map_add(map, "name1", name);
            ds_map_add(map, "team1", argument[1]);
            ds_map_add(map, "weapon", sprite);
            ds_map_add(map, "string", message);
            ds_map_add(map, "name2", action);
            ds_map_add(map, "team2", argument[1]);
            ds_map_add(map, "inthis", argument[3]);
                        
            ds_list_add(kills, map);
            
            if (ds_list_size(kills) > 5) {
                ds_map_destroy(ds_list_find_value(kills, 0));
                ds_list_delete(kills, 0);
            }
            
            alarm[0] = 30*5 / global.delta_factor;
        }

