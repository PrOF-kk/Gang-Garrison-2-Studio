// _gearSpecSet(gearSpec, context, key, value)

var gearSpec, context, key, value;

gearSpec = argument[0];
context = argument[1];
key = argument[2];
value = argument[3];

if(ds_map_exists(gearSpec, context + " " + key))
{
    ds_map_replace(gearSpec, context + " " + key, value);
}
else
{
    ds_map_add(gearSpec, context + " " + key, value);
}
