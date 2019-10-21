// sets the currently playing song
// if you specify sound -1, it will stop the current song

// argument[0] - sound resource
// [argument[1]] - loop

if(AudioControl.currentSong != -1) sound_stop(AudioControl.currentSong);

var loop;
loop = 0;
if (argument_count > 1)
    loop = argument[1];

AudioControl.currentSong = argument[0];
AudioControl.currentSongLoop = loop;

if(AudioControl.currentSong != -1) {
    AudioControl.currentSongPlayed = true;
    if(AudioControl.currentSongLoop) {
        sound_loop(AudioControl.currentSong);
    } else {
        sound_play(AudioControl.currentSong);
    }
}
