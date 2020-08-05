{
    // Writes gamestate to the given buffer.
    // The first argument determines how detailled this information
    // is supposed to be:
    // INPUTSTATE gathers the keypresses and aim direction of every player
    // QUICK_UPDATE additionally gathers the player health, position and movement values
    // FULL_UPDATE gathers all relevant information
    // argument[0]: Type of update
    // argument[1]: Buffer to write the state data to

    var i, player;
        
    global.updateType=argument[0];
    
    fct_write_ubyte(argument[1], argument[0]);
    
    if(argument[0] == FULL_UPDATE) {
        fct_write_ushort(argument[1], global.tdmInvulnerabilityTicks);
    }
    
    fct_write_ubyte(argument[1], ds_list_size(global.players));
    
    global.serializeBuffer = argument[1];

    if argument[0] != CAPS_UPDATE {
        for(i=0; i<ds_list_size(global.players); i+=1) {
            player = ds_list_find_value(global.players, i);
            with(player) {
                event_user(12);
            }
        }
        
        with(MovingPlatform)
            event_user(10);
    }

    if(argument[0] == FULL_UPDATE) {
        serialize(IntelligenceRed);
        serialize(IntelligenceBlue);
        
        fct_write_ubyte(argument[1], global.caplimit);
        fct_write_ubyte(argument[1], global.redCaps);
        fct_write_ubyte(argument[1], global.blueCaps);
        fct_write_ubyte(argument[1], global.Server_RespawntimeSec);
        with (HUD)
            event_user(12);
        
        // Write classlimits to joining client
        for (a = 0; a < 10; a += 1)
            fct_write_ubyte(argument[1], global.classlimits[a]);
    }
    
    if(argument[0] == CAPS_UPDATE) {
              
        fct_write_ubyte(argument[1], global.redCaps);
        fct_write_ubyte(argument[1], global.blueCaps);
        fct_write_ubyte(argument[1], global.Server_RespawntimeSec);
        with (HUD)
            event_user(12);
    }
}
