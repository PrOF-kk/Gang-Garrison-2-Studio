// Notify the server about the current keystate and aim direction
// Argument 0: Buffer or socket to write to
// Argument 1: the current keybyte

fct_write_ubyte(argument[0], INPUTSTATE);
fct_write_ubyte(argument[0], argument[1]);
fct_write_ushort(argument[0], point_direction(view_xview[0]+view_wview[0]/2, view_yview[0]+view_hview[0]/2, mouse_x, mouse_y)*65536/360);
fct_write_ubyte(argument[0], min(255, point_distance(view_xview[0]+view_wview[0]/2, view_yview[0]+view_hview[0]/2, mouse_x, mouse_y)/2));

