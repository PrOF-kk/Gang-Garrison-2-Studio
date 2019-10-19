global.aFirst = false;
global.gg_birthday = false;
global.xmas = false;
if(current_month == 4 and current_day == 1)
{
    if(current_year != 2011) // April fools bubble disabled this year because of big release
        global.aFirst = true;
    else
        global.gg_birthday = true;
}

if(current_month == 9 and current_day == 7)
    global.gg_birthday = true;

if((current_month == 12 and current_day > 23) or (current_month == 1 and current_day < 3)) {
    global.xmas = true;
}

if(global.aFirst)
    sprite_assign(BubblesS, BubbleFaceS);

if(global.xmas)
    xmasTime();
