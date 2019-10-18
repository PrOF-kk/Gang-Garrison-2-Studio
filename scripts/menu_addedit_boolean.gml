// argument[0] - name
// argument[1] - name of the variable this setting is bound to
// argument[2] - GML code to run upon change (argument[0] is new value)

menu_addedit_select(argument[0], argument[1], argument[2]);

menu_add_option(false, "No");
menu_add_option(true, "Yes");
