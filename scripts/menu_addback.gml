// Add a "back" action. This will also be run on pressing escape.
// Only one "back" action per menu is allowed. It will be drawn as
// the last item in the menu.
// argument[0] - name. Passing an empty string means the button won't be drawn, but the escape action will still be set.
// argument[1] - GML code to execute on escape or when the button is pushed

menu_text_back = argument[0];
menu_script_back = argument[1];
