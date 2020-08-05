/*
argument[0]: Team of the intel being returned
*/
fct_write_ubyte(global.sendBuffer, RETURN_INTEL);
fct_write_ubyte(global.sendBuffer, argument[0]);
