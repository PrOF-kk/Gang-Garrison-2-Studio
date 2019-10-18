/**
 * Notify all clients that a player has authenticated for some rewards
 *
 * argument[0]: The player who just did so
 * argument[1]: The reward string
 */

write_ubyte(global.sendBuffer, REWARD_UPDATE);
write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument[0]));
write_ushort(global.sendBuffer, string_length(argument[1]));
write_string(global.sendBuffer, argument[1]);
