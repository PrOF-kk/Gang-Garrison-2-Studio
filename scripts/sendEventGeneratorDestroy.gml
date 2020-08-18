/**
 * argument[0]: The team who destroyed the bomb
 */
 
fct_write_ubyte(global.sendBuffer, GENERATOR_DESTROY);
fct_write_ubyte(global.sendBuffer, argument[0]);
