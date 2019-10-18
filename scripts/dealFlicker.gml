// dealFlicker( flickeredCharacter )
argument[0].cloakAlpha = max(argument[0].cloakAlpha, 0.3);
argument[0].cloakFlicker = true;
argument[0].alarm[7] = 3 / global.delta_factor;

