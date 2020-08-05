/**
 * argument[0]: The player who scored with the intel
 */
 
fct_write_ubyte(global.sendBuffer, SCORE_INTEL);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, argument[0]));
