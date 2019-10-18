var LIMIT;
LIMIT = 30;

if (argument[0] == "")
    return "None (map order from gg2.ini)";
else if (string_length(argument[0]) <= LIMIT)
    return argument[0];
else
    return "..." + string_copy(argument[0], string_length(argument[0])-(LIMIT-3-1), LIMIT-3);
