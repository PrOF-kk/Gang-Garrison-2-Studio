// Read state data from the global.serverSocket and deserialize it
// argument[0]: Type of the state update

global.updateType = argument[0];

if(argument[0] == FULL_UPDATE) {
    receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
    global.tdmInvulnerabilityTicks = fct_read_ushort(global.tempBuffer);
}

receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
if(fct_read_ubyte(global.tempBuffer) != ds_list_size(global.players))
    show_message("Wrong number of players while deserializing state");

if(argument[0] != CAPS_UPDATE) {
    for(i=0; i<ds_list_size(global.players); i+=1) {
        player = ds_list_find_value(global.players, i);
        with(player) {
            event_user(13);
        }
    }
    
    with(MovingPlatform)
        event_user(11);
}

if(argument[0] == FULL_UPDATE) {
    deserialize(IntelligenceRed);
    deserialize(IntelligenceBlue);
    
    receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
    global.caplimit = fct_read_ubyte(global.tempBuffer);
    global.redCaps = fct_read_ubyte(global.tempBuffer);
    global.blueCaps = fct_read_ubyte(global.tempBuffer);
    global.Server_RespawntimeSec = fct_read_ubyte(global.tempBuffer);
    global.Server_Respawntime = global.Server_RespawntimeSec * 30;
         
    with (HUD)
        event_user(13);
    
    // read in 
    receiveCompleteMessage(global.serverSocket, 10, global.tempBuffer);
    for (a = 0; a < 10; a +=1 )
        global.classlimits[a] = fct_read_ubyte(global.tempBuffer);
}

if(argument[0] == CAPS_UPDATE) {
    receiveCompleteMessage(global.serverSocket,3,global.tempBuffer);          
    global.redCaps = fct_read_ubyte(global.tempBuffer);
    global.blueCaps = fct_read_ubyte(global.tempBuffer);
    global.Server_RespawntimeSec = fct_read_ubyte(global.tempBuffer);

    with (HUD)
        event_user(13);
}
