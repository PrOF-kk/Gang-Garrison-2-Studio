// used by loadserverplugins(), relies on 7za.exe Included File
// argument[0] - Zip filename
// argument[1] - Destination

execute_program(temp_directory + "\7za.exe", 'x "'+argument[0]+'" -o"'+argument[1]+'" -aoa', true);
