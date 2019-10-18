//Removes a player from all kill tables (on leave/team change)
//Arg 0 : Player to be cleared

with (Player) {
    domination_kills_delete(dominationKills, argument[0]);
}

domination_kills_clear(argument[0].dominationKills);
