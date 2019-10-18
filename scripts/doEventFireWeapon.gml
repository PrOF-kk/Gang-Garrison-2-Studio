/**
 * argument[0]: The player whose weapon was fired. Must have a character.
 * argument[1]: Random seed (0-65535)
 */

var old_seed;
old_seed = random_get_seed();
random_set_seed(argument[1]);
with(argument[0].object.currentWeapon)
    event_user(3);
random_set_seed(old_seed);
