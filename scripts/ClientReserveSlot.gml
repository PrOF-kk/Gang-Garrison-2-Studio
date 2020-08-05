var playername;
fct_write_ubyte(argument[0], RESERVE_SLOT);
playername = string_copy(global.playerName, 0, min(string_length(global.playerName), MAX_PLAYERNAME_LENGTH));
fct_write_ubyte(argument[0], string_length(playername));
fct_write_string(argument[0], playername);
