// createGlobalDamageSource( name, sprite )
// creates a damage source which can be used for the kill log
// and registers it as a globalvar, so that it can be accessed directly
// from code just like a constant.

var name, sprite;

name = argument[0];
sprite = argument[1];

execute_string("globalvar " + name + ";");
variable_global_set(name, createDamageSource(sprite));

