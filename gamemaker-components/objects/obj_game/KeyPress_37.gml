// Handle typing into keyboard
if( !is_instanceof(focus, UITextInput)) {
    return;
}

var _len = string_length(keyboard_string);
focus.setCursorPosition(_len - 1); 