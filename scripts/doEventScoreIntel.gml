/**
 * The player given in argument[0] has just recovered the intel for his team.
 */

sound_play(IntelPutSnd);
var isMe;
isMe = (argument[0] == global.myself);
//recordEventInLog(3, argument[0].team, argument[0].name);
recordEventInLog(3, argument[0].team, argument[0].name, isMe);
argument[0].stats[CAPS] += 1;
argument[0].roundStats[CAPS] += 1;
argument[0].stats[POINTS] += 2;
argument[0].roundStats[POINTS] += 2;
if(argument[0].team == TEAM_RED) {
    global.redCaps += 1;
    instance_create(IntelligenceBaseBlue.x, IntelligenceBaseBlue.y, IntelligenceBlue);
} else if(argument[0].team == TEAM_BLUE) {
    global.blueCaps += 1;
    instance_create(IntelligenceBaseRed.x, IntelligenceBaseRed.y, IntelligenceRed);
} else {
    exit;
}

if(argument[0].object != -1) {
    argument[0].object.intel = false;
    argument[0].object.animationOffset = CHARACTER_ANIMATION_NORMAL;
}
