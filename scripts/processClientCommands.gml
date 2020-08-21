var player, playerId, commandLimitRemaining;

player = argument[0];
playerId = argument[1];

// To prevent players from flooding the server, limit the number of commands to process per step and player.
commandLimitRemaining = 10;

with(player) {
    if(!variable_instance_exists(id, "commandReceiveState")) {
        // 0: waiting for command byte.
        // 1: waiting for command data length (1 byte)
        // 2: waiting for command data.
        commandReceiveState = 0;
        commandReceiveExpectedBytes = 1;
        commandReceiveCommand = 0;
    }
}

while(commandLimitRemaining > 0) {
    var socket;
    socket = player.socket;
    if(!fct_tcp_receive(socket, player.commandReceiveExpectedBytes)) {
        return 0;
    }
    
    switch(player.commandReceiveState)
    {
    case 0:
        player.commandReceiveCommand = fct_read_ubyte(socket);
        switch(commandBytes[player.commandReceiveCommand]) {
        case commandBytesInvalidCommand:
            // Invalid byte received. Wait for another command byte.
            break;
            
        case commandBytesPrefixLength1:
            player.commandReceiveState = 1;
            player.commandReceiveExpectedBytes = 1;
            break;

        case commandBytesPrefixLength2:
            player.commandReceiveState = 3;
            player.commandReceiveExpectedBytes = 2;
            break;

        default:
            player.commandReceiveState = 2;
            player.commandReceiveExpectedBytes = commandBytes[player.commandReceiveCommand];
            break;
        }
        break;
        
    case 1:
        player.commandReceiveState = 2;
        player.commandReceiveExpectedBytes = fct_read_ubyte(socket);
        break;

    case 3:
        player.commandReceiveState = 2;
        player.commandReceiveExpectedBytes = fct_read_ushort(socket);
        break;
        
    case 2:
        player.commandReceiveState = 0;
        player.commandReceiveExpectedBytes = 1;
        commandLimitRemaining -= 1;
        
        switch(player.commandReceiveCommand)
        {
        case PLAYER_LEAVE:
            fct_socket_destroy(player.socket);
            player.socket = -1;
            break;
            
        case PLAYER_CHANGECLASS:
            var class;
            class = fct_read_ubyte(socket);
            if(getCharacterObject(class) != -1)
            {
                if(player.object != -1)
                {
                    with(player.object)
                    {
                        if (collision_point(x,y,SpawnRoom,0,0) < 0)
                        {
                            if (!instance_exists(lastDamageDealer) || lastDamageDealer == player)
                            {
                                sendEventPlayerDeath(player, player, noone, global.DAMAGE_SOURCE_BID_FAREWELL);
                                doEventPlayerDeath(player, player, noone, global.DAMAGE_SOURCE_BID_FAREWELL);
                            }
                            else
                            {
                                var assistant;
                                assistant = secondToLastDamageDealer;
                                if (lastDamageDealer.object)
                                    if (lastDamageDealer.object.healer)
                                        assistant = lastDamageDealer.object.healer;
                                sendEventPlayerDeath(player, lastDamageDealer, assistant, global.DAMAGE_SOURCE_FINISHED_OFF);
                                doEventPlayerDeath(player, lastDamageDealer, assistant, global.DAMAGE_SOURCE_FINISHED_OFF);
                            }
                        }
                        else 
                        instance_destroy(); 
                        
                    }
                }
                else if(player.alarm[5]<=0)
                    player.alarm[5] = 1; // Will spawn in the same step (between Begin Step and Step)
                class = checkClasslimits(player, player.team, class);
                player.class = class;
                ServerPlayerChangeclass(playerId, player.class, global.sendBuffer);
            }
            break;
            
        case PLAYER_CHANGETEAM:
            var newTeam, balance, redSuperiority;
            newTeam = fct_read_ubyte(socket);
            
            // Invalid team was requested, treat it as a random team
            if(newTeam != TEAM_RED and newTeam != TEAM_BLUE and newTeam != TEAM_SPECTATOR)
                newTeam = TEAM_ANY;

            redSuperiority = 0   //calculate which team is bigger
            with(Player)
            {
                if(id != player)
                {
                    if(team == TEAM_RED)
                        redSuperiority += 1;
                    else if(team == TEAM_BLUE)
                        redSuperiority -= 1;
                }
            }
            if(redSuperiority > 0)
                balance = TEAM_RED;
            else if(redSuperiority < 0)
                balance = TEAM_BLUE;
            else
                balance = -1;
            
            if(newTeam == TEAM_ANY)
            {
                if(balance == TEAM_RED)
                    newTeam = TEAM_BLUE;
                else if(balance == TEAM_BLUE)
                    newTeam = TEAM_RED;
                else
                    newTeam = choose(TEAM_RED, TEAM_BLUE);
            }
                
            if(balance != newTeam and newTeam != player.team)
            {
                if(getCharacterObject(player.class) != -1 or newTeam==TEAM_SPECTATOR)
                {  
                    if(player.object != -1)
                    {
                        with(player.object)
                        {
                            if (!instance_exists(lastDamageDealer) || lastDamageDealer == player)
                            {
                                sendEventPlayerDeath(player, player, noone, global.DAMAGE_SOURCE_BID_FAREWELL);
                                doEventPlayerDeath(player, player, noone, global.DAMAGE_SOURCE_BID_FAREWELL);
                            }
                            else
                            {
                                var assistant;
                                assistant = secondToLastDamageDealer;
                                if (lastDamageDealer.object)
                                    if (lastDamageDealer.object.healer)
                                        assistant = lastDamageDealer.object.healer;
                                sendEventPlayerDeath(player, lastDamageDealer, assistant, global.DAMAGE_SOURCE_FINISHED_OFF);
                                doEventPlayerDeath(player, lastDamageDealer, assistant, global.DAMAGE_SOURCE_FINISHED_OFF);
                            }
                        }
                        player.alarm[5] = global.Server_Respawntime / global.delta_factor;
                    }
                    else if(player.alarm[5]<=0)
                        player.alarm[5] = 1; // Will spawn in the same step (between Begin Step and Step)
                    var newClass;
                    newClass = checkClasslimits(player, newTeam, player.class);
                    if newClass != player.class
                    {
                        player.class = newClass;
                        ServerPlayerChangeclass(playerId, player.class, global.sendBuffer);
                    }
                    player.team = newTeam;
                    ServerPlayerChangeteam(playerId, player.team, global.sendBuffer);
                    clearPlayerDominations(player);
                    ServerBalanceTeams();
                }
            }
            break;                   
            
        case CHAT_BUBBLE:
            var bubbleImage;
            bubbleImage = fct_read_ubyte(socket);
            if(global.aFirst and bubbleImage != 45)
            {
                bubbleImage = 0;
            }
            fct_write_ubyte(global.sendBuffer, CHAT_BUBBLE);
            fct_write_ubyte(global.sendBuffer, playerId);
            fct_write_ubyte(global.sendBuffer, bubbleImage);
            
            setChatBubble(player, bubbleImage);
            break;
            
        case BUILD_SENTRY:
            if(player.object != -1)
            {
                if(player.class == CLASS_ENGINEER
                        and collision_circle(player.object.x, player.object.y, 50, Sentry, false, true) < 0
                        and player.object.nutsNBolts == 100
                        and (collision_point(player.object.x,player.object.y,SpawnRoom,0,0) < 0)
                        and !player.sentry
                        and !player.object.onCabinet)
                {
                    fct_write_ubyte(global.sendBuffer, BUILD_SENTRY);
                    fct_write_ubyte(global.sendBuffer, playerId);
                    fct_write_ushort(global.serializeBuffer, round(player.object.x*5));
                    fct_write_ushort(global.serializeBuffer, round(player.object.y*5));
                    fct_write_byte(global.serializeBuffer, player.object.image_xscale);
                    buildSentry(player, player.object.x, player.object.y, player.object.image_xscale);
                }
            }
            break;                                       

        case DESTROY_SENTRY:
            with(player.sentry)
                instance_destroy();
            break;                     
        
        case DROP_INTEL:
            if (player.object != -1)
            {
                if (player.object.intel)
                {
                    sendEventDropIntel(player);
                    doEventDropIntel(player);
                }
            }
            break;     
              
        case OMNOMNOMNOM:
            if(player.object != -1) {
                if(!player.humiliated
                    and !player.object.taunting
                    and !player.object.omnomnomnom
                    and player.object.canEat
                    and player.class==CLASS_HEAVY)
                {                            
                    fct_write_ubyte(global.sendBuffer, OMNOMNOMNOM);
                    fct_write_ubyte(global.sendBuffer, playerId);
                    with(player.object)
                    {
                        omnomnomnom = true;
                        omnomnomnomindex=0;
                        omnomnomnomend=32;
                        xscale=image_xscale;
                    }             
                }
            }
            break;
             
        case TOGGLE_ZOOM:
            if player.object != -1 {
                if player.class == CLASS_SNIPER {
                    fct_write_ubyte(global.sendBuffer, TOGGLE_ZOOM);
                    fct_write_ubyte(global.sendBuffer, playerId);
                    toggleZoom(player.object);
                }
            }
            break;
                                                      
        case PLAYER_CHANGENAME:
            var nameLength;
            nameLength = fct_socket_receivebuffer_size(socket);
            if(nameLength > MAX_PLAYERNAME_LENGTH)
            {
                fct_write_ubyte(player.socket, KICK);
                fct_write_ubyte(player.socket, KICK_NAME);
                fct_socket_destroy(player.socket);
                player.socket = -1;
            }
            else
            {
                with(player)
                {
                    if(variable_instance_exists(id, "lastNamechange")) 
                        if(current_time - lastNamechange < 1000)
                            break;
                    lastNamechange = current_time;
                    name = fct_read_string(socket, nameLength);
                    fct_write_ubyte(global.sendBuffer, PLAYER_CHANGENAME);
                    fct_write_ubyte(global.sendBuffer, playerId);
                    fct_write_ubyte(global.sendBuffer, string_length(name));
                    fct_write_string(global.sendBuffer, name);
                }
            }
            break;
            
        case INPUTSTATE:
            if(player.object != -1)
            {
                with(player.object)
                {
                    keyState = fct_read_ubyte(socket);
                    netAimDirection = fct_read_ushort(socket);
                    aimDirection = netAimDirection*360/65536;
                    aimDistance = fct_read_ubyte(socket)*2;
                    event_user(1);
                }
            }
            break;
        
        case REWARD_REQUEST:
            player.rewardId = fct_read_string(socket, fct_socket_receivebuffer_size(socket));
            player.challenge = rewardCreateChallenge();
            
            fct_write_ubyte(socket, REWARD_CHALLENGE_CODE);
            write_binstring(socket, player.challenge);
            break;
            
        case REWARD_CHALLENGE_RESPONSE:
            var answer, i, authbuffer;
            answer = read_binstring(socket, 16);
            
            with(player)
                if(variable_instance_exists(id, "challenge") and variable_instance_exists(id, "rewardId"))
                    rewardAuthStart(player, answer, challenge, true, rewardId);
           
            break;
            
        case CLIENT_SETTINGS:
            var mirror;
            mirror = fct_read_ubyte(player.socket);
            player.queueJump = mirror;
            
            fct_write_ubyte(global.sendBuffer, CLIENT_SETTINGS);
            fct_write_ubyte(global.sendBuffer, playerId);
            fct_write_ubyte(global.sendBuffer, mirror);
            break;
        
        }
        break;
    } 
}
