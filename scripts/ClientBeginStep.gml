// receive and interpret the server's message(s)
var i, playerObject, playerID, player, otherPlayerID, otherPlayer, sameVersion, buffer;

if(fct_tcp_eof(global.serverSocket)) {
    if(gotServerHello)
        show_message("You have been disconnected from the server.");
    else
        show_message("Unable to connect to the server.");
    instance_destroy();
    exit;
}

if(room == DownloadRoom and keyboard_check(vk_escape))
{
    instance_destroy();
    exit;
}

if(downloadingMap)
{
    while(fct_tcp_receive(global.serverSocket, min(1024, downloadMapBytes-fct_buffer_size(downloadMapBuffer))))
    {
        fct_write_buffer(downloadMapBuffer, global.serverSocket);
        if(fct_buffer_size(downloadMapBuffer) == downloadMapBytes)
        {
            fct_write_buffer_to_file(downloadMapBuffer, "Maps/" + downloadMapName + ".png");
            downloadingMap = false;
            fct_buffer_destroy(downloadMapBuffer);
            downloadMapBuffer = -1;
            exit;
        }
    }
    exit;
}

roomchange = false;
do {
    if(fct_tcp_receive(global.serverSocket,1)) {
        switch(fct_read_ubyte(global.serverSocket)) {
        case HELLO:
            gotServerHello = true;
            global.joinedServerName = receivestring(global.serverSocket, 1);
            downloadMapName = receivestring(global.serverSocket, 1);
            advertisedMapMd5 = receivestring(global.serverSocket, 1);
            receiveCompleteMessage(global.serverSocket, 1, global.tempBuffer);

            if(string_pos("/", downloadMapName) != 0 or string_pos("\", downloadMapName) != 0)
            {
                show_message("Server sent illegal map name: "+downloadMapName);
                instance_destroy();
                exit;
            }
            ClientReserveSlot(global.serverSocket)
            fct_socket_send(global.serverSocket);
            break;

        case RESERVE_SLOT:
            if(advertisedMapMd5 != "")
            {
                var download;
                download = not file_exists("Maps/" + downloadMapName + ".png");
                if(!download and CustomMapGetMapMD5(downloadMapName) != advertisedMapMd5)
                {
                    if(show_question("The server's copy of the map (" + downloadMapName + ") differs from ours.#Would you like to download this server's version of the map?"))
                        download = true;
                    else
                    {
                        instance_destroy();
                        exit;
                    }
                }
                
                if(download)
                {
                    fct_write_ubyte(global.serverSocket, DOWNLOAD_MAP);
                    fct_socket_send(global.serverSocket);
                    receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
                    downloadMapBytes = fct_read_uint(global.tempBuffer);
                    downloadMapBuffer = fct_buffer_create;
                    downloadingMap = true;
                    roomchange=true;
                }
            }
            ClientPlayerJoin(global.serverSocket);
            if(global.rewardKey != "" and global.rewardId != "")
            {
                var rewardId;
                rewardId = string_copy(global.rewardId, 0, 255);
                fct_write_ubyte(global.serverSocket, REWARD_REQUEST);
                fct_write_ubyte(global.serverSocket, string_length(rewardId));
                fct_write_string(global.serverSocket, rewardId);
            }
            if(global.queueJumping == true)
            {
                fct_write_ubyte(global.serverSocket, CLIENT_SETTINGS);
                fct_write_ubyte(global.serverSocket, global.queueJumping);
            }
            fct_socket_send(global.serverSocket);
            break;
            
        case JOIN_UPDATE:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            global.playerID = fct_read_ubyte(global.tempBuffer);
            global.currentMapArea = fct_read_ubyte(global.tempBuffer);
            break;
        
        case FULL_UPDATE:
            deserializeState(FULL_UPDATE);
            break;
        
        case QUICK_UPDATE:
            deserializeState(QUICK_UPDATE);
            break;
             
        case CAPS_UPDATE:
            deserializeState(CAPS_UPDATE);
            break;
                  
        case INPUTSTATE:
            deserializeState(INPUTSTATE);
            break;             
        
        case PLAYER_JOIN:
            player = instance_create(0,0,Player);
            player.name = receivestring(global.serverSocket, 1);
                  
            ds_list_add(global.players, player);
            if(ds_list_size(global.players)-1 == global.playerID) {
                global.myself = player;
                instance_create(0,0,PlayerControl);
            }
            break;
            
        case PLAYER_LEAVE:
            // Delete player from the game, adjust own ID accordingly
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            playerID = fct_read_ubyte(global.tempBuffer);
            player = ds_list_find_value(global.players, playerID);
            removePlayer(player);
            if(playerID < global.playerID) {
                global.playerID -= 1;
            }
            break;
                                   
        case PLAYER_DEATH:
            var causeOfDeath, assistantPlayerID, assistantPlayer;
            receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
            playerID = fct_read_ubyte(global.tempBuffer);
            otherPlayerID = fct_read_ubyte(global.tempBuffer);
            assistantPlayerID = fct_read_ubyte(global.tempBuffer);
            causeOfDeath = fct_read_ubyte(global.tempBuffer);
                  
            player = ds_list_find_value(global.players, playerID);
            
            otherPlayer = noone;
            if(otherPlayerID != 255)
                otherPlayer = ds_list_find_value(global.players, otherPlayerID);
            
            assistantPlayer = noone;
            if(assistantPlayerID != 255)
                assistantPlayer = ds_list_find_value(global.players, assistantPlayerID);
            
            doEventPlayerDeath(player, otherPlayer, assistantPlayer, causeOfDeath);
            break;
             
        case BALANCE:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            balanceplayer=fct_read_ubyte(global.tempBuffer);
            if balanceplayer == 255 {
                if !instance_exists(Balancer) instance_create(x,y,Balancer);
                with(Balancer) notice=0;
            } else {
                receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
                player = ds_list_find_value(global.players, balanceplayer);
                player.class = fct_read_ubyte(global.tempBuffer);
                if(player.object != -1) {
                    with(player.object) {
                        instance_destroy();
                    }
                    player.object = -1;
                }
                if(player.team==TEAM_RED) {
                    player.team = TEAM_BLUE;
                } else {
                    player.team = TEAM_RED;
                }
                if !instance_exists(Balancer) instance_create(x,y,Balancer);
                Balancer.name=player.name;
                with (Balancer) notice=1;
            }
            break;
                  
        case PLAYER_CHANGETEAM:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
            }
            player.team = fct_read_ubyte(global.tempBuffer);
            clearPlayerDominations(player);
            break;
             
        case PLAYER_CHANGECLASS:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            if(player.object != -1) {
                with(player.object) {
                    instance_destroy();
                }
                player.object = -1;
            }
            player.class = fct_read_ubyte(global.tempBuffer);
            break;             
        
        case PLAYER_CHANGENAME:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            player.name = receivestring(global.serverSocket, 1);
            if player=global.myself {
                global.playerName=player.name
            }
            break;
                 
        case PLAYER_SPAWN:
            receiveCompleteMessage(global.serverSocket,3,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            doEventSpawn(player, fct_read_ubyte(global.tempBuffer), fct_read_ubyte(global.tempBuffer));
            break;
              
        case CHAT_BUBBLE:
            var bubbleImage;
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            setChatBubble(player, fct_read_ubyte(global.tempBuffer));
            break;
             
        case BUILD_SENTRY:
            receiveCompleteMessage(global.serverSocket,6,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            buildSentry(player, fct_read_ushort(global.tempBuffer)/5, fct_read_ushort(global.tempBuffer)/5, fct_read_byte(global.tempBuffer));
            break;
              
        case DESTROY_SENTRY:
            receiveCompleteMessage(global.serverSocket,4,global.tempBuffer);
            playerID = fct_read_ubyte(global.tempBuffer);
            otherPlayerID = fct_read_ubyte(global.tempBuffer);
            assistantPlayerID = fct_read_ubyte(global.tempBuffer);
            causeOfDeath = fct_read_ubyte(global.tempBuffer);
            
            player = ds_list_find_value(global.players, playerID);
            if(otherPlayerID == 255) {
                doEventDestruction(player, noone, noone, causeOfDeath);
            } else {
                otherPlayer = ds_list_find_value(global.players, otherPlayerID);
                if (assistantPlayerID == 255) {
                    doEventDestruction(player, otherPlayer, noone, causeOfDeath);
                } else {
                    assistantPlayer = ds_list_find_value(global.players, assistantPlayerID);
                    doEventDestruction(player, otherPlayer, assistantPlayer, causeOfDeath);
                }
            }
            break;
                      
        case GRAB_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            doEventGrabIntel(player);
            break;
      
        case SCORE_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            doEventScoreIntel(player);
            break;
      
        case DROP_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            doEventDropIntel(player); 
            break;
            
        case RETURN_INTEL:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            doEventReturnIntel(fct_read_ubyte(global.tempBuffer));
            break;
  
        case GENERATOR_DESTROY:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            team = fct_read_ubyte(global.tempBuffer);
            doEventGeneratorDestroy(team);
            break;
      
        case UBER_CHARGED:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            doEventUberReady(player);
            break;
  
        case UBER:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            doEventUber(player);
            break;    
  
        case OMNOMNOMNOM:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            if(player.object != -1) {
                with(player.object) {
                    omnomnomnom=true;
                    if(hp < 200)
                    {
                        canEat = false;
                        alarm[6] = eatCooldown / global.delta_factor; //10 second cooldown
                    }
                    omnomnomnomindex=0;
                    omnomnomnomend=32;
                    xscale=image_xscale; 
                } 
            }
            break;
      
        case TOGGLE_ZOOM:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            if player.object != -1 {
                toggleZoom(player.object);
            }
            break;
                                         
        case PASSWORD_REQUEST:
            if(!usePreviousPwd)
                global.clientPassword = get_string("Enter Password:", "");
            fct_write_ubyte(global.serverSocket, string_length(global.clientPassword));
            fct_write_string(global.serverSocket, global.clientPassword);
            fct_socket_send(global.serverSocket);
            break;
       
        case PASSWORD_WRONG:                                    
            show_message("Incorrect Password.");
            instance_destroy();
            exit;
        
        case INCOMPATIBLE_PROTOCOL:
            show_message("Incompatible server protocol version.");
            instance_destroy();
            exit;
            
        case KICK:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            reason = fct_read_ubyte(global.tempBuffer);
            if reason == KICK_NAME kickReason = "Name Exploit";
            else if reason == KICK_MULTI_CLIENT kickReason = "There are too many connections from your IP";
            else kickReason = "";
            show_message("You have been kicked from the server. "+kickReason+".");
            instance_destroy();
            exit;
           
        case ARENA_WAIT_FOR_PLAYERS:
            doEventArenaWaitForPlayers();
            break;
               
        case ARENA_STARTROUND:
            doEventArenaStartRound();
            break;
            
        case ARENA_ENDROUND:
            with ArenaHUD clientArenaEndRound();
            break;   
        
        case ARENA_RESTART:
            doEventArenaRestart();
            break;
            
        case UNLOCKCP:
            doEventUnlockCP();
            break;
                   
        case MAP_END:
            global.nextMap=receivestring(global.serverSocket, 1);
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            global.winners=fct_read_ubyte(global.tempBuffer);
            global.currentMapArea=fct_read_ubyte(global.tempBuffer);
            global.mapchanging = true;
            if !instance_exists(ScoreTableController) instance_create(0,0,ScoreTableController);
            instance_create(0,0,WinBanner);
            break;

        case CHANGE_MAP:
            roomchange=true;
            global.mapchanging = false;
            global.currentMap = receivestring(global.serverSocket, 1);
            global.currentMapMD5 = receivestring(global.serverSocket, 1);
            if(global.currentMapMD5 == "") { // if this is an internal map (signified by the lack of an md5)
                if(findInternalMapName(global.currentMap) != "")
                    room_goto_fix(CustomMapRoom);
                else
                {
                    show_message("Error:#Server went to invalid internal map: " + global.currentMap + "#Exiting.");
                    instance_destroy();
                    exit;
                }
            } else { // it's an external map
                if(string_pos("/", global.currentMap) != 0 or string_pos("\", global.currentMap) != 0)
                {
                    show_message("Server sent illegal map name: "+global.currentMap);
                    instance_destroy();
                    exit;
                }
                if(!file_exists("Maps/" + global.currentMap + ".png") or CustomMapGetMapMD5(global.currentMap) != global.currentMapMD5)
                {   // Reconnect to the server to download the map
                    var oldReturnRoom;
                    oldReturnRoom = returnRoom;
                    returnRoom = DownloadRoom;
                    event_perform(ev_destroy,0);
                    ClientCreate();
                    returnRoom = oldReturnRoom;
                    usePreviousPwd = true;
                    exit;
                }
                room_goto_fix(CustomMapRoom);
            }
                 
            for(i=0; i<ds_list_size(global.players); i+=1) {
                player = ds_list_find_value(global.players, i);
                if global.currentMapArea == 1 { 
                    player.stats[KILLS] = 0;
                    player.stats[DEATHS] = 0;
                    player.stats[CAPS] = 0;
                    player.stats[ASSISTS] = 0;
                    player.stats[DESTRUCTION] = 0;
                    player.stats[STABS] = 0;
                    player.stats[HEALING] = 0;
                    player.stats[DEFENSES] = 0;
                    player.stats[INVULNS] = 0;
                    player.stats[BONUS] = 0;
                    player.stats[DOMINATIONS] = 0;
                    player.stats[REVENGE] = 0;
                    player.stats[POINTS] = 0;
                    player.roundStats[KILLS] = 0;
                    player.roundStats[DEATHS] = 0;
                    player.roundStats[CAPS] = 0;
                    player.roundStats[ASSISTS] = 0;
                    player.roundStats[DESTRUCTION] = 0;
                    player.roundStats[STABS] = 0;
                    player.roundStats[HEALING] = 0;
                    player.roundStats[DEFENSES] = 0;
                    player.roundStats[INVULNS] = 0;
                    player.roundStats[BONUS] = 0;
                    player.roundStats[DOMINATIONS] = 0;
                    player.roundStats[REVENGE] = 0;
                    player.roundStats[POINTS] = 0;
                    player.team = TEAM_SPECTATOR;
                }
            }
            break;
        
        case SERVER_FULL:
            show_message("The server is full.");
            instance_destroy();
            exit;
        
        case REWARD_CHALLENGE_CODE:
            var challengeData;
            receiveCompleteMessage(global.serverSocket,16,global.tempBuffer);
            challengeData = read_binstring(global.tempBuffer, fct_buffer_size(global.tempBuffer));
            challengeData += fct_socket_remote_ip(global.serverSocket);

            fct_write_ubyte(global.serverSocket, REWARD_CHALLENGE_RESPONSE);
            write_binstring(global.serverSocket, hmac_md5_bin(global.rewardKey, challengeData));
            fct_socket_send(global.serverSocket);
            break;

        case REWARD_UPDATE:
            receiveCompleteMessage(global.serverSocket,1,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            var rewardString;
            rewardString = receivestring(global.serverSocket, 2);
            doEventUpdateRewards(player, rewardString);
            break;
            
        case MESSAGE_STRING:
            var message, notice;
            message = receivestring(global.serverSocket, 1);
            with NoticeO instance_destroy();
            notice = instance_create(0, 0, NoticeO);
            notice.notice = NOTICE_CUSTOM;
            notice.message = message;
            break;
        
        case SENTRY_POSITION:
            receiveCompleteMessage(global.serverSocket,5,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            if(player.sentry)
            {
                player.sentry.x = fct_read_ushort(global.tempBuffer) / 5;
                player.sentry.y = fct_read_ushort(global.tempBuffer) / 5;
                player.sentry.xprevious = player.sentry.x;
                player.sentry.yprevious = player.sentry.y;
                player.sentry.vspeed = 0;
            }
            break;
          
        case WEAPON_FIRE:
            receiveCompleteMessage(global.serverSocket,9,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            
            if(player.object)
            {
                with(player.object)
                {
                    x = fct_read_ushort(global.tempBuffer)/5;
                    y = fct_read_ushort(global.tempBuffer)/5;
                    hspeed = fct_read_byte(global.tempBuffer)/8.5;
                    vspeed = fct_read_byte(global.tempBuffer)/8.5;
                    xprevious = x;
                    yprevious = y;
                }
                
                doEventFireWeapon(player, fct_read_ushort(global.tempBuffer));
            }
            break;
        
        case CLIENT_SETTINGS:
            receiveCompleteMessage(global.serverSocket,2,global.tempBuffer);
            player = ds_list_find_value(global.players, fct_read_ubyte(global.tempBuffer));
            player.queueJump = fct_read_ubyte(global.tempBuffer);
            break;

        default:
            promptRestartOrQuit("The Server sent unexpected data.");
            exit;
        }
    } else {
        break;
    }
} until(roomchange);
