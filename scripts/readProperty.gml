/** 
 * Reads a property with error checking
 * argument[0]: A map of properties
 * argument[1]: The property name
 * argument[2]: The type of the property {STRING, REAL, BOOL}
 * [argument[3]]: Default value in case of error
 * Returns the property or the default value
*/

var prop, defValue;
prop = ds_map_find_value(argument[0], argument[1]);
defValue = 0;

if (argument_count > 3)
    defValue = argument[3];

switch(argument[2]) {
    case STRING:
        if (is_string(prop)) return prop;
        return string(defValue);
    break;
    case REAL:
        if (is_string(prop) && stringIsReal(prop)) return real(prop);
        return real(defValue);
    break;
    case BOOL:
        if (is_string(prop)) {
            if (prop == "true" || prop == "false") return (prop == "true");
        }
        if (is_real(defValue)) return (defValue == true);
        if (string(defValue) == "true") return true;
        else return false;
    break;
    case HEX:
        if (!is_string(prop)) return defValue; 
        prop = string_lower(string_replace(prop, "$", ""));
        var i, j, h;
        h = $0;
        for(i=1; i<=string_length(prop); i+=1) {
            j = string_pos(string_char_at(prop, i), "0123456789abcdef")-1;
            if (j < 0)
                return $0;
            h = (h|j)*16;
        }
        return h/16;        
    break;
    default: 
        show_error("Unknown property type in readProperty script for '" + string(argument[1]) + "'.", false);
}
