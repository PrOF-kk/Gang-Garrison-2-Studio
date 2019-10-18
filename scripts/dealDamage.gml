// dealDamage( sourcePlayer, damagedObject, damageDealt )
with(argument[1])
{
    if(variable_local_exists("deathmatch_invulnerable"))
    {
        if(argument[1].deathmatch_invulnerable != 0)
            return 0;
    }
}

argument[1].hp -= argument[2];

execute_string( global.dealDamageFunction, argument[0], argument[1], argument[2] );

