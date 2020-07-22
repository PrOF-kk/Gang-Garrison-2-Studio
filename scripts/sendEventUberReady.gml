/**
 * Notify all clients that a player just filled his uberMeter
 *
 * argument[0]: The player who just filled his uberMeter
 */

fct_write_ubyte(global.sendBuffer, UBER_CHARGED);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument[0]));
