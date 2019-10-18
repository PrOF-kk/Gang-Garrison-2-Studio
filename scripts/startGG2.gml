//Append each parameter
//void startGG2([string parameters])

var params,a;
params = "-restart";
for(a = 1; a <= parameter_count(); a += 1)
{
  var p;
  p = parameter_string(a);
  if (p == "-map")
  {
    a+= 1;
  } 
  else if (p != "-restart")
  {
    params += " "+p;
  }
}

if (is_string(argument[0]))
    argument[0] = " " + argument[0];
else
    argument[0] = "";

//Restart
execute_program(parameter_string(0), params + argument[0], false);
