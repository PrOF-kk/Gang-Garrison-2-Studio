// argument[0] - name
// argument[1] - name of the variable this setting is bound to
// argument[2] - GML code to run upon change (argument[0] is new value)
// argument[3] - limit. If this is not 0, the value will be limited to this.
item_name[items] = argument[0];
item_type[items] = "editnum";
item_var[items] = argument[1];
item_value[items] = string(menu_get_var(items));
item_script[items] = argument[2];
item_limit[items] = argument[3];
items += 1;
