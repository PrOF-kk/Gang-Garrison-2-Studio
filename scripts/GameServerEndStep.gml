with(Player)
{
    fct_write_buffer(socket, global.sendBuffer);
    fct_socket_send(socket);
}
fct_buffer_clear(global.sendBuffer);

global.runningMapDownloads = 0;
global.mapBytesRemainingInStep = global.mapdownloadLimitBps/room_speed;
with(JoiningPlayer)
    if(state==STATE_CLIENT_DOWNLOADING)
        global.runningMapDownloads += 1;

acceptJoiningPlayer();        
with(JoiningPlayer)
    serviceJoiningPlayer();
