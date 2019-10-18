/// Compare two Server objects by compatibility and ping

if(argument[0].compatible and not (argument[1].compatible))
    return -1;
if(argument[1].compatible and not (argument[0].compatible))
    return 1;

if(argument[0].ping != -1 and argument[1].ping == -1) {
    return -1;
}
if(argument[1].ping != -1 and argument[0].ping == -1) {
    return 1;
}

if(argument[0].ping < argument[1].ping)
    return -1;
if(argument[0].ping > argument[1].ping)
    return 1;
    
return 0;
