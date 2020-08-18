/**
 * argument[0]: The player who grabbed the intel
 */
 
fct_write_ubyte(global.sendBuffer, GRAB_INTEL);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, argument[0]));
