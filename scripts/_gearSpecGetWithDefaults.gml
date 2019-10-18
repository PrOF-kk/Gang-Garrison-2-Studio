// _gearSpecGetOverlay(gearSpec, classConstant, teamConstant, animationName, subimage, key, fallbackValue)
var gearSpec, classConstant, teamConstant, animationName, subimage, key, fallbackValue;

gearSpec = argument[0];
classConstant = argument[1];
teamConstant = argument[2];
animationName = argument[3];
subimage = argument[4];
key = argument[5];
fallbackValue = argument[6];

var frameContextKey, classContextKey, teamContextKey;
frameContextKey = _gearSpecFrameContext(classConstant, teamConstant, animationName, subimage) + " " + key;
if(ds_map_exists(gearSpec, frameContextKey))
{
    return ds_map_find_value(gearSpec, frameContextKey);
}

classContextKey = _gearSpecClassTeamContext(classConstant, teamConstant) + " " + key;
if(ds_map_exists(gearSpec, classContextKey))
{
    return ds_map_find_value(gearSpec, classContextKey);
}

teamContextKey = _gearSpecDefaultTeamContext(teamConstant) + " " + key;
if(ds_map_exists(gearSpec, teamContextKey))
{
    return ds_map_find_value(gearSpec, teamContextKey);
}

return fallbackValue;
