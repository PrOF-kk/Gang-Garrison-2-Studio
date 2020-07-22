// Write a message to the buffer-ish argument[1] that informs the server
// that we want to switch to team argument[0].

fct_write_ubyte(argument[1], PLAYER_CHANGETEAM);
fct_write_ubyte(argument[1], argument[0]);
