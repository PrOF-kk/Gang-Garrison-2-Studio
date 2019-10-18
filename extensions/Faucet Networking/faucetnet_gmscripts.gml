#define read_delimited_string
var bytesleft, result;
bytesleft = buffer_bytes_left(argument[0]);
result = _fnet_hidden_read_delimited_string(argument[0], argument[1]);
if(bytesleft == buffer_bytes_left(argument[0]))
	if(argument[1] != "")
		return -1;

return result;

#define read_cstring
var bytesleft, result;
bytesleft = buffer_bytes_left(argument[0]);
result = _fnet_hidden_read_cstring(argument[0]);
if(bytesleft == buffer_bytes_left(argument[0]))
	return -1;

return result;