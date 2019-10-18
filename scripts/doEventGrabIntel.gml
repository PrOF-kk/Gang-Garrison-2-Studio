/*
 * Grab the intel.
 * Argument 0 is the player who is grabbing it.
 */

//recordEventInLog(6,argument[0].team,argument[0].name);
//argument[0].caps += 0.5;
sound_play(IntelGetSnd);
var isMe;
isMe = (global.myself == argument[0]);
recordEventInLog(6, argument[0].team, argument[0].name, isMe);
if (global.myself == argument[0])
{
    if !instance_exists(NoticeO)
        instance_create(0,0,NoticeO);
    with (NoticeO)
        notice = NOTICE_HAVEINTEL;
}

if(argument[0].object != -1)
{
    if(argument[0].team == TEAM_RED)
    {
        argument[0].object.intelRecharge = max(0, IntelligenceBlue.alarm[0] * global.delta_factor);
        with(IntelligenceBlue)
            instance_destroy();
    }
    else if(argument[0].team == TEAM_BLUE)
    {
        argument[0].object.intelRecharge = max(0, IntelligenceRed.alarm[0] * global.delta_factor);
        with(IntelligenceRed)
            instance_destroy();
    }
    else
        exit;
    
    argument[0].object.intel = true;
    argument[0].object.animationOffset = CHARACTER_ANIMATION_INTEL;
}
