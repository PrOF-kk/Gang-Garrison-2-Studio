// Internal function to enque Player value and buffer for packet
// returns false if no such packetID, else true
// argument[0] - packetID
// argument[1] - buffer (on success, ownership passes to the buffer queue)
// argument[2] - Player

var packetID, buffer, player, packetBufferQueue, packetPlayerQueue;
packetID = argument[0];
buffer = argument[1];
player = argument[2];

// check this is a recognised plugin ID
if (!ds_map_exists(global.pluginPacketBuffers, packetID))
    return false;

// enque buffer and Player in queue
packetBufferQueue = ds_map_find_value(global.pluginPacketBuffers, packetID);
packetPlayerQueue = ds_map_find_value(global.pluginPacketPlayers, packetID);
ds_queue_enqueue(packetBufferQueue, buffer);
ds_queue_enqueue(packetPlayerQueue, player);

return true;
