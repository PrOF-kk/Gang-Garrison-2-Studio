//argument 0: x
//argument 1: y
//argument 2: Object
//argument 3: base hspeed
//argument 4: base vspeed
//argument 5: rotatespeed
//argument 6: image_index
//argument 7: override randomized hs/vspeed
var gib;
gib = instance_create(argument[0],argument[1],argument[2]);
if (argument[7]) {
    gib.hspeed = argument[3];
    gib.vspeed = argument[4];
}else{
    gib.hspeed = (argument[3]+random_range(-8,9));
    gib.vspeed = (argument[4]+random_range(-8,9));
}
gib.rotspeed = argument[5];
gib.image_index = argument[6];
