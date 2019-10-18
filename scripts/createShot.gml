//createShot(x, y, projectile, damageSource, direction, projectileSpeed)

var _x, _y, projectile, damageSource, dir, projectileSpeed, shot;
_x = argument[0];
_y = argument[1];
projectile = argument[2];
damageSource = argument[3];
dir = argument[4];
projectileSpeed = argument[5];

shot = instance_create(_x,_y,projectile);
with(shot)
{
    direction = dir;
    image_angle = dir;
    speed = projectileSpeed;
    owner = other.owner;
    ownerPlayer = other.ownerPlayer;
    team = owner.team;
    weapon = damageSource;
}

return shot;
