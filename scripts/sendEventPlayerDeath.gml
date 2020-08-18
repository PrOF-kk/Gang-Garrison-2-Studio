/**
 * Notify all clients of a "player death" event.
 *
 * argument[0]: The player whose character died
 * argument[1]: The player who inflicted the fatal damage (or noone)
 * argument[2]: The assistant (or a false value for none)
 * argument[3]: The source of the fatal damage
 */
var victim, killer, assistant, damageSource;
victim = argument[0];
killer = argument[1];
assistant = argument[2];
damageSource = argument[3];

fct_write_ubyte(global.sendBuffer, PLAYER_DEATH);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, victim));
if(instance_exists(killer))
    fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, killer));
else
    fct_write_ubyte(global.sendBuffer, 255);
    
if(instance_exists(assistant))
    fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, assistant));
else
    fct_write_ubyte(global.sendBuffer, 255);

fct_write_ubyte(global.sendBuffer, damageSource);
