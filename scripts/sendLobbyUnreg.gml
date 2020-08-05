var iplookup;

/* Blocking IP lookup. This unreg function is only called when closing the server so
 * blocking is acceptable, and in case the user is closing the game we need to make
 * sure the UDP packet is sent before GM shuts down the networking extension.
 */
iplookup = fct_ip_lookup_create(LOBBY_SERVER_HOST);

while(!fct_ip_lookup_ready(iplookup))
    sleep_ms(10);
    
if(fct_ip_lookup_has_next(iplookup))
{
    var lobbyIp, lobbyBuffer;
    lobbyIp = fct_ip_lookup_next_result(iplookup);
    
    lobbyBuffer = fct_buffer_create;
    parseUuid("488984ac-45dc-86e1-9901-98dd1c01c064", lobbyBuffer); // Message Type "unregister"
    fct_write_buffer(lobbyBuffer, GameServer.serverId);
    fct_udp_send(lobbyBuffer, lobbyIp, LOBBY_SERVER_PORT);
    fct_buffer_destroy(lobbyBuffer);
}
fct_ip_lookup_destroy(iplookup);

