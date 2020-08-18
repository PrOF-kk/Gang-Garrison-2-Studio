{
    // Only one client object may exist at a time
    if(instance_number(object_index)>1) {
        nocreate=true;
        instance_destroy();
        exit;
    }
    nocreate=false;
    usePreviousPwd = false;
    
    global.players = ds_list_create();
    global.deserializeBuffer = fct_buffer_create();
    global.isHost = false;

    global.myself = -1;
    gotServerHello = false;  
    returnRoom = Menu;
    downloadingMap = false;
    downloadMapBuffer = -1;
    
    global.serverSocket = fct_tcp_connect(global.serverIP, global.serverPort);
    
    fct_write_ubyte(global.serverSocket, HELLO);
    fct_write_buffer(global.serverSocket, global.protocolUuid);
    fct_socket_send(global.serverSocket);
    
    room_goto_fix(DownloadRoom);
}
