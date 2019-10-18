// gearSpecFrameOverlay(gearSpec, classConstant, animationName, animationSubimage, redOverlay, blueOverlay, subimage)
var gearSpec, classConstant, animationName, animationSubimage, redOverlay, blueOverlay, subimage;

gearSpec = argument[0];
classConstant = argument[1];
animationName = argument[2];
animationSubimage = argument[3];
redOverlay = argument[4];
blueOverlay = argument[5];
subimage = argument[6];

var redContextName, blueContextName;
redContextName = _gearSpecFrameContext(classConstant, TEAM_RED, animationName, animationSubimage);
blueContextName = _gearSpecFrameContext(classConstant, TEAM_BLUE, animationName, animationSubimage);

_gearSpecSet(gearSpec, redContextName, "overlay", redOverlay);
_gearSpecSet(gearSpec, redContextName, "overlaySubimage", subimage);
_gearSpecSet(gearSpec, blueContextName, "overlay", blueOverlay);
_gearSpecSet(gearSpec, blueContextName, "overlaySubimage", subimage);
