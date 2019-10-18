// Returns the number of players in team <argument[1]> which have class <argument[2]>, not counting <argument[0]>

var count;
count = 0

with(Player)
{
    if (id != argument[0] and team == argument[1] and class == argument[2])
        count += 1;
}

return count;
