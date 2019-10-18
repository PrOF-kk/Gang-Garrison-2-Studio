/**
 * Notify all clients that a player is respawning.
 *
 * argument[0]: The player who spawned
 * argument[1]: The spawnpoint ID
 * argument[2]: The spawn group
 */

write_ubyte(global.sendBuffer, PLAYER_SPAWN);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument[0]));
write_ubyte(global.sendBuffer, argument[1]);
write_ubyte(global.sendBuffer, argument[2]);
