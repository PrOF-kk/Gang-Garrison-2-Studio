// Reads the first value in a list, then moves it to the back of the list
if(ds_list_size(argument[0]) < 0)
    return NAN;

var n;
n = ds_list_find_value(argument[0], 0);
ds_list_delete(argument[0], 0);
ds_list_add(argument[0], n);
return n;

