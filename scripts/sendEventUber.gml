/**
 * Notify all clients that a player just started an Ubercharge
 *
 * argument[0]: The player who just fired his Ubercharge
 */
 
fct_write_ubyte(global.sendBuffer, UBER);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument[0]));
