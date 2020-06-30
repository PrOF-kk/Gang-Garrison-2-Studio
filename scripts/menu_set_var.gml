// Set the value of the tied variable for an item. The variable must be global.
// argument0: item number
// argument1: value
if not variable_global_exists(string_replace(item_var[argument0], "global.", "")) {
    show_error("Attempted to access variable "+item_var[argument0]+" but it does not exist.", false);
    return undefined;
}
return variable_global_set(string_replace(item_var[argument0], "global.", ""), argument1);
