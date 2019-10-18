var key, value;
key = argument[1];
value = argument[2];

if(string_length(key) > 255)
    show_error("Key too long: "+key, true);
    
if(string_length(value) > 65535)
    value = string_copy(value, 0, 65535);
    
write_ubyte(argument[0], string_length(key));
write_string(argument[0], key);
write_ushort(argument[0], string_length(value));
write_string(argument[0], value);
