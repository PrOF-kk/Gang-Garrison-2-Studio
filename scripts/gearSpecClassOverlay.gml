// gearSpecClassOverlay(gearSpec, classConstant, redOverlay, blueOverlay, subimage)
// Sets the default overlay for the given class and for both teams to the given sprites, both at the given subimage
// This overrides the default overlay specified using gearSpecDefaultOverlay
var gearSpec, classConstant, redOverlay, blueOverlay, subimage;

gearSpec = argument[0];
classConstant = argument[1];
redOverlay = argument[2];
blueOverlay = argument[3];
subimage = argument[4];

_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_RED), "overlay", redOverlay);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_RED), "overlaySubimage", subimage);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_BLUE), "overlay", blueOverlay);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_BLUE), "overlaySubimage", subimage);
