//TODO: Handle typing into keyboard. this is debug print output for testing text inputs
if( !is_instanceof(focus, UITextInput)) {
    return;
}

show_debug_message($"Key pressed: {keyboard_lastkey} -- Last Char: {keyboard_lastchar}");
show_debug_message($"keyboard string: {keyboard_string}");