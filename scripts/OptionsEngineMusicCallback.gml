if(room != Options)
{
    if (argument[0] == MUSIC_BOTH || argument[0] == MUSIC_INGAME_ONLY)
    {
        AudioControlPlaySong(global.IngameMusic, true);
    }
    else
    {
        AudioControlPlaySong(-1, false);
    }
}
else
{
    if(argument[0] == MUSIC_BOTH || argument[0] == MUSIC_MENU_ONLY)
    {
        AudioControlPlaySong(global.MenuMusic, true);
    }
    else
    {
        AudioControlPlaySong(-1, false);
    }
}
return argument0;
