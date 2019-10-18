// gearSpecClassOverlayOffset(gearSpec, classConstant, xoff, yoff)
// Sets the default x and y offset of the overlay for the given class
// The offset is the center of the overlay relative to the rigging point.
var gearSpec, classConstant, xoff, yoff;

gearSpec = argument[0];
classConstant = argument[1];
xoff = argument[2];
yoff = argument[3];

_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_RED), "xoff", xoff);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_RED), "yoff", yoff);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_BLUE), "xoff", xoff);
_gearSpecSet(gearSpec, _gearSpecClassTeamContext(classConstant, TEAM_BLUE), "yoff", yoff);
