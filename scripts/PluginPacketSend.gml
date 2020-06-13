#define PluginPacketSend
// Sends a packet for a server-sent plugin to all clients
// Returns true if successful, false if not
// argument[0] - plugin packet ID, passed as argument[1] to server-sent plugin upon execution
// argument[1] - data buffer to send (maximum size 65535 bytes)
// argument[2] (optional, default false) - boolean, if true will send packet to server as well

var packetID, dataBuffer, loopback, packetBuffer;

packetID = argument[0];
dataBuffer = argument[1];

loopback = false;
if (argument_count > 2)
    loopback = argument[2];

// check to make sure the packet ID is valid
if (!ds_map_exists(global.pluginPacketBuffers, packetID))
{
    show_error("ERROR when sending plugin packet: no such plugin packet ID " + string(packetID), true);
    return false;
}

// check size of buffer (limited because ushort used for length of packet)
if (buffer_size(dataBuffer) > 65534)
    return false;

// Short-cicuit when sending to self
if (loopback)
{
    packetBuffer = buffer_create;
    write_buffer(packetBuffer, dataBuffer);
    _PluginPacketPush(packetID, packetBuffer, global.myself);
}

// send packet to every client (if server), or to server (if client)
packetBuffer = buffer_create;

// ID of plugin packet container packet
write_ubyte(packetBuffer, PLUGIN_PACKET);

// packet remainder length
write_ushort(packetBuffer, buffer_size(dataBuffer) + 1);

// plugin packet ID
write_ubyte(packetBuffer, packetID);

// plugin packet data buffer
write_buffer(packetBuffer, dataBuffer);

// write to appropriate buffer and call send if needed
if (global.isHost) {
    write_buffer(global.sendBuffer, packetBuffer);
} else {
    write_buffer(global.serverSocket, packetBuffer);
    socket_send(global.serverSocket);
}

buffer_destroy(packetBuffer);
return true;


#define PluginPacketSendTo
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
if (buffer_size(dataBuffer) > 65534)
    return false;

// Short-cicuit when sending to self
if (player == global.myself)
{
    packetBuffer = buffer_create;
    write_buffer(packetBuffer, dataBuffer);
    _PluginPacketPush(packetID, packetBuffer, global.myself);
    return true;
}

// send packet to specified client
packetBuffer = buffer_create;

// ID of plugin packet container packet
write_ubyte(packetBuffer, PLUGIN_PACKET);

// packet remainder length
write_ushort(packetBuffer, buffer_size(dataBuffer) + 1);

// plugin packet ID
write_ubyte(packetBuffer, packetID);

// plugin packet data buffer
write_buffer(packetBuffer, dataBuffer);

// write to appropriate buffer and call send if needed
write_buffer(player.socket, packetBuffer);
socket_send(player.socket);

buffer_destroy(packetBuffer);
return true;


#define PluginPacketGetBuffer
// Returns the buffer of the earliest received packet for a server-sent plugin
// Buffer returned should not be modified or destroyed.
// If there is no packet buffer to return, returns -1
// argument[0] - plugin packet ID, passed as argument[1] to server-sent plugin upon execution

var packetID, packetBufferQueue;

packetID = argument[0];

// check to make sure the packet ID is valid
if (!ds_map_exists(global.pluginPacketBuffers, packetID))
{
    show_error("ERROR when fetching plugin packet buffer: no such plugin packet ID " + string(packetID), true);
    return -1;
}

packetBufferQueue = ds_map_find_value(global.pluginPacketBuffers, packetID);

// check we have any buffer to return
if (ds_queue_empty(packetBufferQueue))
    return -1;

return ds_queue_head(packetBufferQueue);


#define PluginPacketGetPlayer
// Returns the Player of the earliest received packet for a server-sent plugin
// If this packet was received from the server, noone is returned instead
// If there is no packet Player to return, returns -1
// argument[0] - plugin packet ID, passed as argument[1] to server-sent plugin upon execution

var packetID, packetPlayerQueue;

packetID = argument[0];

// check to make sure the packet ID is valid
if (!ds_map_exists(global.pluginPacketPlayers, packetID))
{
    show_error("ERROR when fetching plugin packet Player: no such plugin packet ID " + string(packetID), true);
    return noone;
}

packetPlayerQueue = ds_map_find_value(global.pluginPacketPlayers, packetID);

// check we have any Player to return
if (ds_queue_empty(packetPlayerQueue))
    return -1;

return ds_queue_head(packetPlayerQueue);


#define PluginPacketPop
// Removes the earliest received packet for a server-sent plugin
// This will destroy the buffer.
// If there is packet to remove, returns false, otherwise true
// argument[1] - plugin packet ID, passed as argument[0] to server-sent plugin upon execution

var packetID, packetBufferQueue, packetPlayerQueue;

packetID = argument[0];

// check to make sure the packet ID is valid
if (!ds_map_exists(global.pluginPacketBuffers, packetID))
{
    show_error("ERROR when popping plugin packet buffer: no such plugin packet ID " + string(packetID), true);
    return false;
}

packetBufferQueue = ds_map_find_value(global.pluginPacketBuffers, packetID);
packetPlayerQueue = ds_map_find_value(global.pluginPacketPlayers, packetID);

// check we have any packet to pop
if (ds_queue_empty(packetBufferQueue))
    return false;

// dequeue from both queues
// (the queues are synchronised, two are used because GML has no tuples)
buffer_destroy(ds_queue_dequeue(packetBufferQueue));
ds_queue_dequeue(packetPlayerQueue);
return true;



#define _PluginPacketPush
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


#define loadplugins
// self-explanatory
// borrowed file-search code from Port
var file, pattern, prefix, list, fp, i, env;

// Prefix since results from file_find_* don't include path
prefix = working_directory + "\Plugins\";
pattern = prefix + "*.gml";

list = ds_list_create();

// Find files and put in list
for (file = file_find_first(pattern, 0); file != ""; file = file_find_next())
{
    ds_list_add(list, file);
}

// Execute plugins
for (i = 0; i < ds_list_size(list); i += 1)
{
    file = ds_list_find_value(list, i);
    // Debugging facility, so we know *which* plugin caused compile/execute error
    fp = file_text_open_write(working_directory + "\last_plugin.log");
    file_text_write_string(fp, prefix + file);
    file_text_close(fp);
    // Create persistent environment for plugin (so its variables won't collide)
    env = instance_create(0, 0, PluginEnvironment);
    // Allows plugins to detect which mode they're running in
    env.isServerSentPlugin = false;
    env.isLocalPlugin = true;
    // So the plugin can locate its resources
    env.directory = prefix;
    // Execute
    with (env)
        execute_file(prefix + file);
}

// Clear up
file_delete(working_directory + "\last_plugin.log");
ds_list_destroy(list);


#define getpluginhashes
// gets MD5 hashes for plugins from ganggarrison.com
// argument[0] - comma separated plugin list 
// returns comma-separated plugin list with hashes
// or else the string 'failure'
var list, i, pluginname, pluginhash, url, handle, filesize, failed, fp, hashedList;

failed = false;
hashedList = '';

// split plugin list string
list = split(argument[0], ',');

for (i = 0; i < ds_list_size(list); i += 1)
{
    ds_list_replace(list, i, trim(ds_list_find_value(list, i)));
}

// Check plugin names and check for duplicates
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);
    
    // invalid plugin name
    if (!checkpluginname(pluginname))
    {
        show_message('Error loading server-sent plugins - invalid plugin name:#"' + pluginname + '"');
        return 'failure';
    }
    // is duplicate
    else if (ds_list_find_index(list, pluginname) != i)
    {
        show_message('Error loading server-sent plugins - duplicate plugin:#"' + pluginname + '"');
        return 'failure';
    }
}

// Download plugin hashes
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);

    // check if we have a debug version
    if (file_exists(working_directory + "\ServerPluginsDebug\" + pluginname + ".zip"))
    {
        // get its hash instead
        pluginhash = GG2DLL_compute_MD5(working_directory + "\ServerPluginsDebug\" + pluginname + ".zip");
    }
    else
    {   
        // construct the URL
        // (http://www.ganggarrison.com/plugins/$PLUGINNAME$.md5)
        url = PLUGIN_SOURCE + pluginname + ".md5";
    
        // let's make the request handle
        handle = http_new_get(url);

        while (!http_step(handle))
        {
            // should be quick, no need to show progress
        }

        // request failed
        if (http_status_code(handle) != 200)
        {
            if (http_status_code(handle) == 404)
                show_message('Error loading server-sent plugins - getting hash failed for "' + pluginname + '":#404 Not Found - This most likely means there is no plugin with that name. Are you sure you spelled it correctly? Please note that plugin names are always lowercase, and you cannot have spaces between the commas in ServerPluginList.');
            else
                show_message('Error loading server-sent plugins - getting hash failed for "' + pluginname + '":#' + string(http_status_code(handle)) + ' ' + http_reason_phrase(handle));
            failed = true;
            break;
        }

        pluginhash = read_string(http_response_body(handle), 32);
        http_destroy(handle);
    }

    // append name + hash to list
    // (used by client to check if cache is valid)
    if (i != 0)
    {
        hashedList += ',';
    }
    hashedList += pluginname + '@' + pluginhash;
}

// Get rid of plugin list
ds_list_destroy(list);

if (failed)
{
    return 'failure';
}
else
{
    return hashedList;
}


#define loadserverplugins
// loads plugins from ganggarrison.com asked for by server
// argument[0] - comma separated plugin list (pluginname@md5hash)
// returns true on success, false on failure
var list, hashList, text, i, pluginname, pluginhash, realhash, url, handle, filesize, progress, tempfile, tempdir, failed, lastContact, isCached, env;

failed = false;
list = ds_list_create();
lastContact = 0;
isCached = false;
isDebug = false;
hashList = ds_list_create();

// split plugin list string
list = split(argument[0], ',');

// Split hashes from plugin names
for (i = 0; i < ds_list_size(list); i += 1)
{
    text = ds_list_find_value(list, i);
    pluginname = string_copy(text, 0, string_pos("@", text) - 1);
    pluginhash = string_copy(text, string_pos("@", text) + 1, string_length(text) - string_pos("@", text));
    ds_list_replace(list, i, pluginname);
    ds_list_add(hashList, pluginhash);
}

// Check plugin names and check for duplicates
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);
    
    // invalid plugin name
    if (!checkpluginname(pluginname))
    {
        show_message('Error loading server-sent plugins - invalid plugin name:#"' + pluginname + '"');
        return false;
    }
    // is duplicate
    else if (ds_list_find_index(list, pluginname) != i)
    {
        show_message('Error loading server-sent plugins - duplicate plugin:#"' + pluginname + '"');
        return false;
    }
}

// Download plugins
for (i = 0; i < ds_list_size(list); i += 1)
{
    pluginname = ds_list_find_value(list, i);
    pluginhash = ds_list_find_value(hashList, i);
    isDebug = file_exists(working_directory + "\ServerPluginsDebug\" + pluginname + ".zip");
    isCached = file_exists(working_directory + "\ServerPluginsCache\" + pluginname + "@" + pluginhash);
    tempfile = temp_directory + "\" + pluginname + ".zip.tmp";
    tempdir = temp_directory + "\" + pluginname + ".tmp";

    // check to see if we have a local copy for debugging
    if (isDebug)
    {
        file_copy(working_directory + "\ServerPluginsDebug\" + pluginname + ".zip", tempfile);
        // show warning
        if (global.isHost)
        {
            show_message(
                "Warning: server-sent plugin '"
                + pluginname
                + "' is being loaded from ServerPluginsDebug. Make sure clients have the same version, else they may be unable to connect."
            );
        }
        else
        {
            show_message(
                "Warning: server-sent plugin '"
                + pluginname
                + "' is being loaded from ServerPluginsDebug. Make sure the server has the same version, else you may be unable to connect."
            );
        }
    }
    // otherwise, check if we have it cached
    else if (isCached)
    {
        file_copy(working_directory + "\ServerPluginsCache\" + pluginname + "@" + pluginhash, tempfile);
    }
    // otherwise, download as usual
    else
    {
        // construct the URL
        // http://www.ganggarrison.com/plugins/$PLUGINNAME$@$PLUGINHASH$.zip)
        url = PLUGIN_SOURCE + pluginname + "@" + pluginhash + ".zip";
        
        // let's make the download handle
        handle = http_new_get(url);
        
        // download it
        while (!http_step(handle)) {
            // prevent game locking up
            //io_handle();
            
            if (!global.isHost) {
                // send ping if we haven't contacted server in 20 seconds
                // we need to do this to keep the connection open
                if (current_time-lastContact > 20000) {
                    write_byte(global.serverSocket, PING);
                    socket_send(global.serverSocket);
                    lastContact = current_time;
                }
            }

            // draw progress bar since they may be waiting a while
            filesize = http_response_body_size(handle);
            progress = http_response_body_progress(handle);
            draw_background_ext(background_index[0], 0, 0, background_xscale[0], background_yscale[0], 0, c_white, 1);
            draw_set_color(c_white);
            draw_set_alpha(1);
            draw_set_halign(fa_left);
            draw_rectangle(50, 550, 300, 560, 2);
            draw_text(50, 530, "Downloading server-sent plugin " + string(i + 1) + "/" + string(ds_list_size(list)) + ' - "' + pluginname + '"');
            // If the URL we fetch is a redirect with no body, size might briefly be 0
            // Also, Faucet HTTP reports an unknown size as -1
            if (filesize > 0)
                draw_rectangle(50, 550, 50 + progress / filesize * 250, 560, 0);
            //screen_refresh();
        }

        // request failed
        if (http_status_code(handle) != 200)
        {
            show_message('Error loading server-sent plugins - download failed for "' + pluginname + '":#' + string(http_status_code(handle)) + ' ' + http_reason_phrase(handle));
            failed = true;
            break;
        }
        else
        {
            write_buffer_to_file(http_response_body(handle), tempfile);
            if (!file_exists(tempfile))
            {
                show_message('Error loading server-sent plugins - download failed for "' + pluginname + '":# No such file?');
                failed = true;
                break;
            }
        }

        http_destroy(handle);
    }

    // check file integrity
    realhash = GG2DLL_compute_MD5(tempfile);
    if (realhash != pluginhash)
    {
        show_message('Error loading server-sent plugins - integrity check failed (MD5 hash mismatch) for:#"' + pluginname + '"');
        failed = true;
        break;
    }
    
    // don't try to cache debug plugins
    if (!isDebug)
    {
        // add to cache if we don't already have it
        if (!file_exists(working_directory + "\ServerPluginsCache\" + pluginname + "@" + pluginhash))
        {
            // make sure directory exists
            if (!directory_exists(working_directory + "\ServerPluginsCache"))
            {
                directory_create(working_directory + "\ServerPluginsCache");
            }
            // store in cache
            file_copy(tempfile, working_directory + "\ServerPluginsCache\" + pluginname + "@" + pluginhash);
        }
    }

    // let's get 7-zip to extract the files
    extractzip(tempfile, tempdir);
    
    // if the directory doesn't exist, extracting presumably failed
    if (!directory_exists(tempdir))
    {
        show_message('Error loading server-sent plugins - extracting zip failed for:#"' + pluginname + '"');
        failed = true;
        break;
    }
}

if (!failed)
{
    // Execute plugins
    for (i = 0; i < ds_list_size(list); i += 1)
    {
        pluginname = ds_list_find_value(list, i);
        tempdir = temp_directory + "\" + pluginname + ".tmp";
        
        // Debugging facility, so we know *which* plugin caused compile/execute error
        fp = file_text_open_write(working_directory + "\last_plugin.log");
        file_text_write_string(fp, pluginname);
        file_text_close(fp);

        // packetID is (i), so make queues for it
        ds_map_add(global.pluginPacketBuffers, i, ds_queue_create());
        ds_map_add(global.pluginPacketPlayers, i, ds_queue_create());

        // Create persistent environment for plugin (so its variables won't collide)
        env = instance_create(0, 0, PluginEnvironment);
        // Allows plugins to detect which mode they're running in
        env.isServerSentPlugin = true;
        env.isLocalPlugin = false;
        // So the plugin can locate its resources
        env.directory = tempdir;
        // The packet ID needed for the PluginPacket* functions
        env.packetID = i;

        // Execute plugin
        with (env)
            execute_file(
                // the plugin's main gml file must be in the root of the zip
                // it is called plugin.gml
                tempdir + "\plugin.gml",
                // For backwards-compatibility, we continue to pass these as arguments
                tempdir,
                i
            );
    }
}

// Delete last plugin log
file_delete(working_directory + "\last_plugin.log");

// Get rid of plugin list
ds_list_destroy(list);

// Get rid of plugin hash list
ds_list_destroy(hashList);

return !failed;


#define extractzip
// used by loadserverplugins(), relies on 7za.exe Included File
// argument[0] - Zip filename
// argument[1] - Destination

execute_program(temp_directory + "\7za.exe", 'x "'+argument[0]+'" -o"'+argument[1]+'" -aoa', true);


#define checkpluginname
// checks the name of a plugin to see if it conforms to /[a-z0-9_]+/
// returns true is it conforms, false if otherwise
// argument[0] - plugin name

var i, validChars;

if (string_length(argument[0]) < 1)
{
    return false;
}

validChars = "0123456789abcdefghijklmnopqrstuvwxyz_";
for (i = 0; i < string_length(argument[0]); i+=1)
{
    // if the urrent character isn't valid
    if (string_pos(string_char_at(argument[0], i), validChars) == 0)
    {
        return false;
    }
}

return true;


#define pluginscleanup
// cleans up server-sent plugins
// Restart or quit GG2 so that plugins aren't kept in memory
// argument[0]: (optional) show cancel button (for disconnecting via ingamemenu)

var msg, showCancel;
msg = "Because you used this server's plugins, you will have to restart GG2 to play on another server."

showCancel = false;
if (argument_count > 0)
    showCancel = argument[0];

if (global.restartPrompt == 1)
    promptRestartOrQuit(msg, showCancel);
else
    restartGG2();
