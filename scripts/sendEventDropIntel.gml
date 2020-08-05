/**
 * Notify all clients that the player <argument[0]> dropped the intel.
 *
 * This event is not sent when the character dies to avoid issues with order of execution. Instead, character
 * destruction implicitly drops the intel.
 * argument[0]: The player who is dropping the intel. Must currently have a valid Character object with intel==true.
 */
var player;
player = argument[0];

fct_write_ubyte(global.sendBuffer, DROP_INTEL);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, player));
