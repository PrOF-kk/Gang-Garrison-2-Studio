// argument[0] - mapname
// argument[1] - mapmd5
// argument[2] - buffer

write_ubyte(argument[2], CHANGE_MAP);
write_ubyte(argument[2], string_length(argument[0]));
write_string(argument[2], argument[0]);
write_ubyte(argument[2], string_length(argument[1]));
write_string(argument[2], argument[1]);
