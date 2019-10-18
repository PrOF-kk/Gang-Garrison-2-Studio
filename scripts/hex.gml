var i, strlen, result, byte;
strlen = string_length(argument[0]);
result = "";

for(i=1; i<=strlen; i+=1)
{
    byte = ord(string_char_at(argument[0], i));
    result += string_char_at("0123456789abcdef", 1+($F & (byte >> 4)));
    result += string_char_at("0123456789abcdef", 1+($F & byte));
}

return result;
