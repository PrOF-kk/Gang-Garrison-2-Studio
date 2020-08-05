var win;
receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
win = fct_read_ubyte(global.tempBuffer);
mvps[TEAM_RED] = fct_read_ubyte(global.tempBuffer);
mvps[TEAM_BLUE] = fct_read_ubyte(global.tempBuffer);
redWins = fct_read_ubyte(global.tempBuffer);
blueWins = fct_read_ubyte(global.tempBuffer);

for(i=0; i < mvps[TEAM_RED]; i+=1) {
    receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
    redMVP[i] = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
    redMVP[i].roundStats[KILLS] = fct_read_ubyte(global.tempBuffer);
    redMVP[i].roundStats[HEALING] = fct_read_ushort(global.tempBuffer);
    redMVP[i].roundStats[POINTS] = fct_read_ubyte(global.tempBuffer);
}

for(i=0; i < mvps[TEAM_BLUE]; i+=1) {
    receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
    blueMVP[i] = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
    blueMVP[i].roundStats[KILLS] = fct_read_ubyte(global.tempBuffer);
    blueMVP[i].roundStats[HEALING] = fct_read_ushort(global.tempBuffer);
    blueMVP[i].roundStats[POINTS] = fct_read_ubyte(global.tempBuffer);
}

doEventArenaEndRound(win);
