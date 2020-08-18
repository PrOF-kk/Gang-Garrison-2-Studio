if(!global.useLobbyServer)
    exit;

var noOfOccupiedSlots;
noOfOccupiedSlots = getNumberOfOccupiedSlots();

var lobbyBuffer;
lobbyBuffer = fct_buffer_create();
fct_set_little_endian(lobbyBuffer, false);

parseUuid("b5dae2e8-424f-9ed0-0fcb-8c21c7ca1352", lobbyBuffer); // Message Type "register"
fct_write_buffer(lobbyBuffer, GameServer.serverId);
fct_write_buffer(lobbyBuffer, global.gg2lobbyId);
fct_write_ubyte(lobbyBuffer, 0); // TCP
fct_write_ushort(lobbyBuffer, global.hostingPort);
fct_write_ushort(lobbyBuffer, global.playerLimit);
fct_write_ushort(lobbyBuffer, noOfOccupiedSlots);
fct_write_ushort(lobbyBuffer, 0); // Number of bots
if(global.serverPassword != "")
    fct_write_ushort(lobbyBuffer, 1);
else
    fct_write_ushort(lobbyBuffer, 0);

fct_write_ushort(lobbyBuffer, 7); // Number of Key/Value pairs that follow
writeKeyValue(lobbyBuffer, "name", global.serverName);
writeKeyValue(lobbyBuffer, "game", GAME_NAME_STRING);
writeKeyValue(lobbyBuffer, "game_short", "gg2");
writeKeyValue(lobbyBuffer, "game_ver", GAME_VERSION_STRING);
writeKeyValue(lobbyBuffer, "game_url", GAME_URL_STRING);
writeKeyValue(lobbyBuffer, "map", global.currentMap);
fct_write_ubyte(lobbyBuffer, string_length("protocol_id"));
fct_write_string(lobbyBuffer, "protocol_id");
fct_write_ushort(lobbyBuffer, 16);
fct_write_buffer(lobbyBuffer, global.protocolUuid);

fct_udp_send(lobbyBuffer, LOBBY_SERVER_HOST, LOBBY_SERVER_PORT);
fct_buffer_destroy(lobbyBuffer);
