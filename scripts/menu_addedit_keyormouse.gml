// argument[0] - name
// argument[1] - name of the variable this setting is bound to
// argument[2] - ini category, if one is used
// argument[3] - ini field, if one is used
item_name[items] = argument[0];
item_type[items] = "editkey";
item_var[items] = argument[1];
item_script[items] = undefined;

if argument_count > 2 {
    item_ini_category[items] = argument[2];
    item_ini_field[items] = argument[3];
} else {
    item_ini_category[items] = undefined;
}

items += 1;
