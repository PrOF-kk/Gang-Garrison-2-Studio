// Write a message to the buffer-ish argument[1] that informs the clients
// that the player with id argument[0] left the game.

fct_write_ubyte(argument[1], PLAYER_LEAVE);
fct_write_ubyte(argument[1], argument[0]);
