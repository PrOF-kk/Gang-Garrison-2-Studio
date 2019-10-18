/**
 * argument[0]: The player whose rewards were updated
 * argument[1]: The new rewards value
 */

var player, rewardString;
player = argument[0];
rewardString = argument[1];

parseRewards(rewardString, player.rewards);
parseBadges(player.rewards, player.badges);
