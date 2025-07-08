///@description Returns true if the value is a string and is not empty.
function string_valid(_str) {
    return is_string(_str) && string_length(_str) > 0;
}