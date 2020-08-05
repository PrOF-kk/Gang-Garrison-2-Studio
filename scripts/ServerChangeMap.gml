// argument[0] - mapname
// argument[1] - mapmd5
// argument[2] - buffer

fct_write_ubyte(argument[2], CHANGE_MAP);
fct_write_ubyte(argument[2], string_length(argument[0]));
fct_write_string(argument[2], argument[0]);
fct_write_ubyte(argument[2], string_length(argument[1]));
fct_write_string(argument[2], argument[1]);
