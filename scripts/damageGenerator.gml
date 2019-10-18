// damageGenerator( sourcePlayer, damagedGenerator, damageDealt )

argument[1].alarm[0] = argument[1].regenerationBuffer / global.delta_factor;
argument[1].isShieldRegenerating = false;

if (argument[2] > argument[1].shieldHp) //allow overkill to be applied directly to the target
{
    dealDamage( argument[0], argument[1], (argument[2] - argument[1].shieldHp) + (argument[1].shieldHp * argument[1].shieldResistance) );
    argument[1].shieldHp = 0;
}
else
{
    dealDamage( argument[0], argument[1], argument[2] * argument[1].shieldResistance );
    argument[1].shieldHp -= argument[2];
}

