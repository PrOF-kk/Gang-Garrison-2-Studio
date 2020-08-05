{
    var i, player;

    fct_write_ubyte(argument[0], JOIN_UPDATE);
    fct_write_ubyte(argument[0], ds_list_size(global.players));
    fct_write_ubyte(argument[0], global.currentMapArea);
    
    ServerChangeMap(global.currentMap, global.currentMapMD5, socket);
    
    for(i = 0; i < ds_list_size(global.players); i += 1) {
        player = ds_list_find_value(global.players, i);
        ServerPlayerJoin(player.name, argument[0]);
        ServerPlayerChangeclass(i, player.class, argument[0]);
        ServerPlayerChangeteam(i, player.team, argument[0]);
    }
    
    serializeState(FULL_UPDATE, argument[0]);
}
