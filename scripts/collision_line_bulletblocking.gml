if(collision_line(argument[0], argument[1], argument[2], argument[3], Obstacle, 1, 0)) return true;
if(collision_line(argument[0], argument[1], argument[2], argument[3], BulletWall, 1, 0)) return true;
if(collision_line(argument[0], argument[1], argument[2], argument[3], IntelGate, 1, 0)) return true;
if(not global.mapchanging)
    if(collision_line(argument[0], argument[1], argument[2], argument[3], TeamGate, 1, 0)) return true;
if(areSetupGatesClosed())
    if(collision_line(argument[0], argument[1], argument[2], argument[3], ControlPointSetupGate, 1, 0)) return true;
return false;
