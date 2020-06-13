// dealDamage( sourcePlayer, damagedObject, damageDealt )
with(argument[1])
{
    if(variable_local_exists(id, "deathmatch_invulnerable"))
    {
        if(argument[1].deathmatch_invulnerable != 0)
            return 0;
    }
}

argument[1].hp -= argument[2];
