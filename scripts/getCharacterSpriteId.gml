var class, team, animation;

class = argument[0];
team = argument[1];
animation = argument[2];

if(!is_string(class))
{
    if(class >= 0 and class < 10)
        class = global.characterSpriteClassPrefixes[class];
    else
        show_error("Attempted to get a sprite for unknown class ID: " + string(class), true);
}

if(!is_string(team))
{
    if(team >= 0 and team < 2)
        team = global.characterSpriteTeamPrefixes[team];
    else
        show_error("Attempted to get a sprite for unknown team ID: " + string(team), true);
}

return asset_get_index(class + team + animation + "S");
