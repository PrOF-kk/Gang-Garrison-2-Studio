// damageGenerator( sourcePlayer, damagedObject, damageDealt )
var object;
object = argument[1].object_index;

if(object_is_ancestor(object, Character) or object == Character )
    damageCharacter( argument[0], argument[1], argument[2] );
else if(object_is_ancestor(object, Sentry) or object == Sentry )
    damageSentry( argument[0], argument[1], argument[2] );
else if(object_is_ancestor(object, Generator) or object == Generator )
    damageGenerator( argument[0], argument[1], argument[2] );
else // This is probably a mistake, error
    show_message("ERROR: Tried to apply damage to an entity that#"+
                 "probably doesn't have health. Please report this error.##"+
                 "Technical information for debuggers: "
                    + string(argument[0].class) + " "
                    + string(argument[1].object_index)+ " "
                    + string(argument[2]));

