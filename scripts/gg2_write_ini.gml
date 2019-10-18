ini_open("gg2.ini");
if(is_string(argument[2]))
    ini_write_string(argument[0], argument[1], argument[2]);
else
    ini_write_real(argument[0], argument[1], argument[2]);
ini_close();
