// Force dedicated mode to off so you can go to main menu instead of just restarting server
if (show_question("Do you really want to leave this match?")) {
    global.dedicatedMode = 0;
    with(Client)
        instance_destroy();
        
    with(GameServer)
        instance_destroy();
}
