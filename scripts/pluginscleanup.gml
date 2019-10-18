// cleans up server-sent plugins
// Restart or quit GG2 so that plugins aren't kept in memory
// argument[0]: (optional) show cancel button (for disconnecting via ingamemenu)

var msg;
msg = "Because you used this server's plugins, you will have to restart GG2 to play on another server."

if (global.restartPrompt == 1)
    promptRestartOrQuit(msg,argument[0]);
else
    restartGG2();
