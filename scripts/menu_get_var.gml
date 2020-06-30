// Get the value of the tied variable for an item. The variable must be global.
// argument[0]: item number
if not variable_global_exists(string_replace(item_var[argument0], "global.", "")) {
    show_error("Attempted to access variable "+item_var[argument0]+" but it does not exist.", false);
    return undefined;
}
return variable_global_get(string_replace(item_var[argument0], "global.", ""));
