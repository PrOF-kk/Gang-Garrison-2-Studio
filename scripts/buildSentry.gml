var player, xPos, yPos, startDirection;

player = argument[0];
xPos = argument[1];
yPos = argument[2];
startDirection = argument[3];

if(!player.sentry)
{
    player.sentry = instance_create(xPos, yPos, Sentry);
    player.sentry.ownerPlayer = player;
    player.sentry.team = player.team;
}
else
{
    player.sentry.x = xPos;
    player.sentry.y = yPos;
}

player.sentry.startDirection = startDirection;
player.sentry.image_xscale = startDirection;
player.object.nutsNBolts -= 100;
