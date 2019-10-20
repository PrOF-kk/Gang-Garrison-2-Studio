//Low effort drop-in replacement for show_message_ext
//Basic response line-like response system
//Replace as soon as possible
var response, input, text, firstLabel, secondLabel, thirdLabel

text = argument[0]
firstLabel = argument[1];
thirdLabel = argument[3];
response = -1;
input = "";

secondLabel = "rabeuiò<blevfPGVEWQQYéVfe<vbyiev<";
if (argument[2] != "")
    secondLabel = argument[2];

while(reponse == -1) {
    input = get_string(text + "#" + firstLabel + "#" + secondLabel + "#" + thirdLabel, firstLabel);
    switch input {
        case firstLabel:
            response = 1;
            break;
        case secondLabel:
            response = 2;
            break;
        case thirdLabel:
            response = 3;
            break;
        default:
            response = -1;
            break;
    }
}
return response;
