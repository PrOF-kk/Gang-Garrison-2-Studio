var newName;
newName = string_copy(argument[0], 0, min(string_length(argument[0]), MAX_PLAYERNAME_LENGTH));
if(room != Options and newName != oldPlayerName)
{
    write_ubyte(global.serverSocket, PLAYER_CHANGENAME);
    write_ubyte(global.serverSocket, string_length(newName));
    write_string(global.serverSocket, newName);
    socket_send(global.serverSocket);
}
oldPlayerName = newName;
return newName;
