// This function attempts to read a message of the length given in arg1.
// It won't return unless the complete message is read or an error occurs.

// If the message is received completely, it returns 0
// If the socket had to be closed due to an error or loss of connection, it returns 2
// If there was some other error (probably wrong arguments), it returns 3

// The given buffer will be cleared before reading the message.
// The socket's receive buffer will contain the message as well.

// argument 0: Socket
// argument 1: size of the message to receive
// argument 2: Buffer

var buffer;
fct_buffer_clear(argument[2]);

do {
    if(fct_socket_has_error(argument[0])) {
        return 2;
    }
} until(fct_tcp_receive(argument[0], argument[1]));

fct_write_buffer(argument[2], argument[0]);

return 0;
