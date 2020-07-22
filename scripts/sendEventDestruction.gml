/**
 * Notify all clients of a "building destruction" event.
 *
 * argument[0]: The owner of the destroyed building
 * argument[1]: The player who inflicted the fatal damage (or noone for owner detonation)
 * argument[2]: The healer of the destroyer (or noone)
 * argument[3]: The source of the fatal damage
 */
var owner, killer, healer, damageSource;
owner = argument[0];
killer = argument[1];
healer = argument[2];
damageSource = argument[3];

fct_write_ubyte(global.sendBuffer, DESTROY_SENTRY);
fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, owner));
if(instance_exists(killer)) {
    fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, killer));
} else {
    fct_write_ubyte(global.sendBuffer, 255);
}
if(instance_exists(healer)) {
    fct_write_ubyte(global.sendBuffer, ds_list_find_index(global.players, healer));
} else {
    fct_write_ubyte(global.sendBuffer, 255);
}  
fct_write_ubyte(global.sendBuffer, damageSource);
