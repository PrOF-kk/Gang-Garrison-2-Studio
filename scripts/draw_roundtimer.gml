var xoffset, yoffset, xsize, ysize, xshift, yshift, teamoffset;
xoffset = argument[0];
yoffset = argument[1];
xsize = argument[2];
ysize = argument[3];
xshift = -320*global.timerPos;
yshift = 5*global.timerPos;

if instance_exists(WinBanner)
    exit;

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_set_valign(fa_center);

// Determine timer color based on team
teamoffset = 0; // Default: Red
if (global.myself != -1)
{
    if (global.myself.team == TEAM_RED)
        teamoffset = 0;
    else if (global.myself.team == TEAM_BLUE)
        teamoffset = 1;
}

draw_generictimer(xoffset+xshift, yoffset+yshift, xsize, ysize, argument[4], teamoffset, 0);
