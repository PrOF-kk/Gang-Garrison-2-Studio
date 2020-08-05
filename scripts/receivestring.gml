/* Receive a string with length prefix. Blocks until the complete string is read */

var size,buffer,result;
buffer = fct_buffer_create;
if(receiveCompleteMessage(argument[0], argument[1], buffer) > 0) {
    fct_buffer_destroy(buffer);
    return "";
}

if(argument[1] == 1) {
    size = fct_read_ubyte(buffer);
} else {
    size = fct_read_ushort(buffer);
}

if(receiveCompleteMessage(argument[0], size, buffer) > 0) {
    fct_buffer_destroy(buffer);
    return "";
}

result = fct_read_string(buffer, size);
fct_buffer_destroy(buffer);
return result;
