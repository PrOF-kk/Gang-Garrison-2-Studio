// cleans up server-sent plugins
// Restart or quit GG2 so that plugins aren't kept in memory
// argument[0]: (optional) show cancel button (for disconnecting via ingamemenu)

var msg, showCancel;
msg = "Because you used this server's plugins, you will have to restart GG2 to play on another server."

showCancel = false;
if (argument_count == 0)
    showCancel = argument[0];

if (global.restartPrompt == 1)
    promptRestartOrQuit(msg, showCancel);
else
    restartGG2();
