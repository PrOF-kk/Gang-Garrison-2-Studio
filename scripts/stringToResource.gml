/** 
 * Turns a string from resourceToString back into a sprite
 * argument[0]: The resource string
 * [argument[1]]: True if the resource is a background
 * [argument[2]]: The output file (loads the resource if empty)
 * Returns: the loaded resource
*/

var file, name, ext, isBackground, output
ext = string_copy(argument[0], 1, 3);
if (ext != "GIF")
{
    ext = string_copy(argument[0], 2, 3);
    if (ext != "PNG")
        return -1;
}

isBackground = 0;
output = 0;
if (argument_count > 1)
    isBackground = argument[1];
if (argument_count > 2)
    output = argument[2];

if (is_string(output))
    name = output + "." + ext;
else
    name = temp_directory + "\TmpResource." + ext;

file = file_bin_open(name, 2);
while(file_bin_position(file) < string_length(argument[0]))
    file_bin_write_byte(file, ord(string_char_at(argument[0], file_bin_position(file)+1)));
file_bin_close(file);

if (!is_string(output))
{
    if (isBackground)
        return background_add(name, 0, 0);
    else
        return sprite_add(name, 1, 1, 0, 0, 0); 
}
