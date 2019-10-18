/* Receive a string with length prefix. Blocks until the complete string is read */

var size,buffer,result;
buffer = buffer_create;
if(receiveCompleteMessage(argument[0], argument[1], buffer) > 0) {
    buffer_destroy(buffer);
    return "";
}

if(argument[1] == 1) {
    size = read_ubyte(buffer);
} else {
    size = read_ushort(buffer);
}

if(receiveCompleteMessage(argument[0], size, buffer) > 0) {
    buffer_destroy(buffer);
    return "";
}

result = read_string(buffer, size);
buffer_destroy(buffer);
return result;
