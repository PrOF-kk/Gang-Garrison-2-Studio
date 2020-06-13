// Get the value of the tied variable for an item
// argument[0]: item number
if not variable_global_exists(item_var[argument0]) {
    show_error("Attempted to access variable "+item_var[argument0]+" but it does not exist.", false);
    return undefined;
}
return variable_global_get(item_var[argument0]);
