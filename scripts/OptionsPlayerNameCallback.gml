var newName;
newName = string_copy(argument[0], 0, min(string_length(argument[0]), MAX_PLAYERNAME_LENGTH));
if(room != Options and newName != oldPlayerName)
{
    fct_write_ubyte(global.serverSocket, PLAYER_CHANGENAME);
    fct_write_ubyte(global.serverSocket, string_length(newName));
    fct_write_string(global.serverSocket, newName);
    fct_socket_send(global.serverSocket);
}
oldPlayerName = newName;
return newName;
