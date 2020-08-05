var message;
message = string_copy(argument[0], 0, 255);
fct_write_ubyte(argument[1], MESSAGE_STRING);
fct_write_ubyte(argument[1], string_length(message));
fct_write_string(argument[1], message);
