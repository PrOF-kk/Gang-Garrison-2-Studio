{
    sound_volume(argument[2], calculateVolume(argument[0], argument[1]));
    sound_pan(argument[2], calculatePan(argument[0]));
    
    sound_loop(argument[2]);
}
