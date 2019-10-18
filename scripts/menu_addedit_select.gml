// argument[0] - name
// argument[1] - name of the variable this setting is bound to
// argument[2] - GML code to run upon change (argument[0] is new value)
// Call menu_add_option right after this function to add options for the select.
// You need to add at least one option or the menu will error out.

item_name[items] = argument[0];
item_type[items] = "editselect";
item_var[items] = argument[1];
item_value[items] = 0; // In this case, the index of the selected option
item_script[items] = argument[2];
item_options[items] = 0;
items += 1;
