var player, answer, challenge, ipCheck, rewardId, authbuffer, item;
player = argument[0];
answer = argument[1];
challenge = argument[2];
ipCheck = argument[3];
rewardId = argument[4];

// Prevent one player from requesting auth several times
with(player)
    if(variable_instance_exists(id, "rewardAuthAlreadyStarted")) exit;
player.rewardAuthAlreadyStarted = true;

if(!instance_exists(RewardAuthChecker))
    instance_create(0, 0, RewardAuthChecker);
    
// Check for auth backlog overcapacity (paranoia!)
if(ds_queue_size(RewardAuthChecker.workQueue) > 50) exit;

// Prepare buffer to query the server
authbuffer = fct_buffer_create();
parseUuid("205e2d84-4833-89d4-15d9-c0249667df1c", authbuffer);
fct_write_ushort(authbuffer, string_length(answer)+string_length(challenge)+1+string_length(rewardId));
write_binstring(authbuffer, answer);
write_binstring(authbuffer, challenge);
fct_write_ubyte(authbuffer, ipCheck);
fct_write_string(authbuffer, rewardId);

// Enqueue the check
item = ds_list_create();
ds_list_add(item, player);
ds_list_add(item, authbuffer);
ds_queue_enqueue(RewardAuthChecker.workQueue, item);
