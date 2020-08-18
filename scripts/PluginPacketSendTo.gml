// Sends a packet for a server-sent plugin to a specific client
// Returns true if successful, false if not
// argument[0] - plugin packet ID, passed as argument[1] to server-sent plugin upon execution
// argument[1] - data buffer to send (maximum size 65535 bytes)
// argument[2] - Player object for client to send to

var packetID, databuffer, player, packetBuffer;

packetID = argument[0];
dataBuffer = argument[1];
player = argument[2];

// error out if we're not the host
// (this function can't be used by clients, obviously)
if (!global.isHost)
{
    show_error("ERROR when sending plugin packet: cannot use PluginPacketSendTo as client", true);
    return false;
}

// check to make sure the packet ID is valid
if (!ds_map_exists(global.pluginPacketBuffers, packetID))
{
    show_error("ERROR when sending plugin packet: no such plugin packet ID " + string(packetID), true);
    return false;
}

// check size of buffer (limited because ushort used for length of packet)
if (fct_buffer_size(dataBuffer) > 65534)
    return false;

// Short-cicuit when sending to self
if (player == global.myself)
{
    packetBuffer = fct_buffer_create();
    fct_write_buffer(packetBuffer, dataBuffer);
    _PluginPacketPush(packetID, packetBuffer, global.myself);
    return true;
}

// send packet to specified client
packetBuffer = fct_buffer_create();

// ID of plugin packet container packet
fct_write_ubyte(packetBuffer, PLUGIN_PACKET);

// packet remainder length
fct_write_ushort(packetBuffer, fct_buffer_size(dataBuffer) + 1);

// plugin packet ID
fct_write_ubyte(packetBuffer, packetID);

// plugin packet data buffer
fct_write_buffer(packetBuffer, dataBuffer);

// write to appropriate buffer and call send if needed
fct_write_buffer(player.socket, packetBuffer);
fct_socket_send(player.socket);

fct_buffer_destroy(packetBuffer);
return true;
