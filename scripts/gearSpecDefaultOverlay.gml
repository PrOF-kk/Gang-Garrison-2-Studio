// gearSpecDefaultOverlay(gearSpec, redOverlay, blueOverlay, subimage)
// Sets the default overlay for both teams to the given sprites, both at the given subimage
// This overlay will be used for all frames where no more specific overlay is defined
var gearSpec, redOverlay, blueOverlay, subimage;

gearSpec = argument[0];
redOverlay = argument[1];
blueOverlay = argument[2];
subimage = argument[3];

_gearSpecSet(gearSpec, _gearSpecDefaultTeamContext(TEAM_RED), "overlay", redOverlay);
_gearSpecSet(gearSpec, _gearSpecDefaultTeamContext(TEAM_RED), "overlaySubimage", subimage);
_gearSpecSet(gearSpec, _gearSpecDefaultTeamContext(TEAM_BLUE), "overlay", blueOverlay);
_gearSpecSet(gearSpec, _gearSpecDefaultTeamContext(TEAM_BLUE), "overlaySubimage", subimage);
