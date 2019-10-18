{
    // Argument 0: Class
    var result;
        
    result = ds_map_find_value(global.characterMap, argument[0]);
    if(result == 0)
        return -1;
        
    return result;
}
