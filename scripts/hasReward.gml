// real hasReward(real player, string rewardName)
// Returns true if this Player has the specific non-class-specific reward

var player, rewardName;
player = argument[0];
rewardName = argument[1];

return ds_map_exists(player.rewards, rewardName);
