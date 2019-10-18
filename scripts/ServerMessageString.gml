var message;
message = string_copy(argument[0], 0, 255);
write_ubyte(argument[1], MESSAGE_STRING);
write_ubyte(argument[1], string_length(message));
write_string(argument[1], message);
