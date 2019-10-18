//argument[0] - time (0...1)
//argument[1] - is blue (instead of red)
//argument[2] - vertical offset (positive is down)

draw_sprite_ext(IntelTimerS,floor(argument[1]*12+12*argument[0]),x+2,y-25+argument[2],2,2,0,c_white,1);

