// argument[0] - name
// argument[1] - name of the variable this setting is bound to
// argument[2] - script to run upon change (argument[0] is new value)
// argument[3] - ini category, if one is used
// argument[4] - ini field, if one is used
// Call menu_add_option right after this function to add options for the select.
// You need to add at least one option or the menu will error out.
item_name[items] = argument[0];
item_type[items] = "editselect";
item_var[items] = argument[1];
item_value[items] = string(menu_get_var(items));
item_script[items] = argument[2];
item_options[items] = 0;

if argument[3] != "" {
    item_ini_category[items] = argument[3];
    item_ini_field[items] = argument[4];
}

items += 1;
