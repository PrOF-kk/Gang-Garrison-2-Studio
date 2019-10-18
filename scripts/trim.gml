var len, firstNonspace, firstTrailingSpace, char;
len = string_length(argument[0]);

for(firstNonspace = 1; firstNonspace <= len; firstNonspace += 1) {
    char = string_char_at(argument[0], firstNonspace);
    if(char != ' ' and char != chr(9)) {
        break;
    }
}

for(firstTrailingSpace = len+1; firstTrailingSpace > firstNonspace; firstTrailingSpace -= 1) {
    char = string_char_at(argument[0], firstTrailingSpace-1);
    if(char != ' ' and char != chr(9)) {
        break;
    }
}

return string_copy(argument[0], firstNonspace, firstTrailingSpace-firstNonspace);
