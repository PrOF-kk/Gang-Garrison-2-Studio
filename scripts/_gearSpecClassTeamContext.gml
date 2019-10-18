// _gearSpecClassTeamContext(classConstant, teamConstant)
var classConstant, teamConstant;

classConstant = argument[0];
teamConstant = argument[1];

return global.characterSpriteTeamPrefixes[teamConstant] + " " + global.characterSpriteClassPrefixes[classConstant];
