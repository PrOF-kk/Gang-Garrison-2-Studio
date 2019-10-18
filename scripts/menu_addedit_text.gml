// argument[0] - name
// argument[1] - name of the variable this setting is bound to
// argument[2] - GML code to run upon change (argument[0] is new value)

item_name[items] = argument[0];
item_type[items] = "edittext";
item_var[items] = argument[1];
item_value[items] = menu_get_var(items);
item_script[items] = argument[2];
items += 1;
