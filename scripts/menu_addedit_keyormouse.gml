// argument[0] - name
// argument[1] - name of the variable this setting is bound to
// argument[2] - script to run upon change (argument[0] is new value)
// argument[3] - ini category, if one is used
// argument[4] - ini field, if one is used
item_name[items] = argument[0];
item_type[items] = "editkey";
item_var[items] = argument[1];
item_script[items] = argument[2];

if argument[3] != "" {
    item_ini_category[items] = argument[3];
    item_ini_field[items] = argument[4];
}

items += 1;
