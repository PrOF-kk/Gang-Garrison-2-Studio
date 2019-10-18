var uuidString, currentNibble, posValueString, numericByte;

// Parses the given UUID and appends it to the provided buffer in big-endian order.
// argument[0]: UUID hex string
// argument[1]: Buffer

uuidString = string_lower(string_replace_all(argument[0],"-",""));
if(string_length(uuidString)!=32)
    show_error("Invalid UUID: "+argument[0], true);

posValueString = "0123456789abcdef";
for(i=0; i<16; i+=1)
{
    currentNibble = string_char_at(uuidString,i*2+1);
    if(string_pos(currentNibble, posValueString)==0)
        show_error("Invalid UUID: "+argument[0], true);
    numericByte = (string_pos(currentNibble, posValueString)-1)*16;
    
    currentNibble = string_char_at(uuidString,i*2+2);
    if(string_pos(currentNibble, posValueString)==0)
        show_error("Invalid UUID: "+argument[0], true);
    numericByte += string_pos(currentNibble, posValueString)-1;
    
    write_ubyte(argument[1], numericByte);
}
