if(instance_exists(argument[0])) {
    if(argument[0].object != -1) {
        argument[0].object.bubble.image_index = argument[1];
        argument[0].object.bubble.alarm[0] = 60 / global.delta_factor;
        argument[0].object.bubble.visible = true;
        argument[0].object.bubble.bubbleAlpha = 1;
        argument[0].object.bubble.fadeout = false;
    }
}
