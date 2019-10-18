// _gearSpecFrameContext(classConstant, teamConstant, animationName, subimage)
var classConstant, teamConstant, animationName, subimage;

classConstant = argument[0];
teamConstant = argument[1];
animationName = argument[2];
subimage = argument[3];

return _gearSpecClassTeamContext(classConstant, teamConstant) + " " + animationName + " " + string(subimage);
