/**
 * argument[0]: The player whose weapon was fired. Must have a character.
 * argument[1]: Random seed (0-65535)
 */
 
fct_write_ubyte(global.sendBuffer, WEAPON_FIRE);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, argument[0]));

fct_write_ushort(global.sendBuffer, argument[0].object.x*5);
fct_write_ushort(global.sendBuffer, argument[0].object.y*5);
fct_write_byte(global.sendBuffer, argument[0].object.hspeed*8.5);
fct_write_byte(global.sendBuffer, argument[0].object.vspeed*8.5);

fct_write_ushort(global.sendBuffer, argument[1]);
