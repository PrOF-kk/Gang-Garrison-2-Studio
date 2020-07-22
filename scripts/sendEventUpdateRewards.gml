/**
 * Notify all clients that a player has authenticated for some rewards
 *
 * argument[0]: The player who just did so
 * argument[1]: The reward string
 */

fct_write_ubyte(global.sendBuffer, REWARD_UPDATE);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players,argument[0]));
fct_write_ushort(global.sendBuffer, string_length(argument[1]));
fct_write_string(global.sendBuffer, argument[1]);
