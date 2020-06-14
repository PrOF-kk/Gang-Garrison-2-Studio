// Add a menu item that calls a script when clicked, and that has a display value.
// There is no variable binding for this kind of item, the script is expected to perform
// any desired state update itself.
// Useful for things like file dialogs.
// argument[0] - name
// argument[1] - script to run upon change (argument[0] is new value)
item_name[items] = argument[0];
item_type[items] = "editscript";
item_script[items] = argument[1];

items += 1;
