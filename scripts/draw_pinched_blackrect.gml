// a[0]: x
//   1 : y
//   2 : width
//   3 : height
//   4 : inset (dimensions of squares removed from corners)
//   5 : bezel? (whether to draw the bezel effect)

var x1, x2, x3, x4, y1, y2, y3, y4, dampen;
x1 = argument[0];
x2 = x1+argument[4];
x3 = x1+argument[2]-argument[4]-1;
x4 = x1+argument[2]-1;
y1 = argument[1];
y2 = y1+argument[4];
y3 = y1+argument[3]-argument[4]-1;
y4 = y1+argument[3]-1;
// main body
if(argument[5] > 1)
    draw_set_alpha(sqr(draw_get_alpha()));
draw_rectangle(x1, y2,      x4, y3,   false); // main segment (without top and bottom past inset)
if (argument[4] > 0)
{
    draw_rectangle(x2,   y1,   x3, y2-1, false); // top half
    draw_rectangle(x2,   y3+1, x3, y4,   false); // bottom half
}
if(argument[5] > 1)
    draw_set_alpha(sqrt(draw_get_alpha()));
// bezel 
if(argument[5] > 0 and argument[5] < 3)
{
    draw_rectangle(x2, y4, x3, y4, false); // bottom middle
    draw_rectangle(x4, y2, x4, y3, false); // right middle
    if (argument[4] > 0)
    {
        draw_rectangle(x1,   y3, x2-1, y3, false); // bottom left
        draw_rectangle(x3+1, y3, x4-1, y3, false); // bottom right
        draw_rectangle(x3, y1, x3, y2-1, false); // right top
        draw_rectangle(x3, y3, x3, y4-1, false); // right bottom
    }
}

