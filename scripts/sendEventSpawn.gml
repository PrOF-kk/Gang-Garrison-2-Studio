/**
 * Notify all clients that a player is respawning.
 *
 * argument[0]: The player who spawned
 * argument[1]: The spawnpoint ID
 * argument[2]: The spawn group
 */

fct_write_ubyte(global.sendBuffer, PLAYER_SPAWN);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument[0]));
fct_write_ubyte(global.sendBuffer, argument[1]);
fct_write_ubyte(global.sendBuffer, argument[2]);
