// Initializes a custom level

// argument[0]: filename

{
  // get the leveldata
  var leveldata, tempfile;
  tempfile = "./custommap_walkmask.png";
  leveldata = GG2DLL_extract_PNG_leveldata(argument[0], tempfile);

  if(leveldata == "") {
    show_message("Error: this file does not contain level data.");
    return false;
  }
  // handle the leveldata
  if (!CustomMapProcessLevelData(leveldata, tempfile)) return false;
  
  if (room == BuilderRoom) background_replace(BuilderBGB, argument[0], false, false);
  else background_replace(CustomMapB, argument[0], false, false);

  return true;
}
