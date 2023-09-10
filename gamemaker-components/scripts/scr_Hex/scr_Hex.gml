///@description Turns base 10 real into a hex string
function string_hex(_value) {
    var s = sign(_value);
    var v = abs(_value);

    var output = "";

    while (v > 0)  {
        var c  = v & 0xf;
        output = chr(c + ((c < 10) ? 48 : 55)) + output;
        v = v >> 4;
    }

    if (string_length(output) == 0) {
        output = "0";
    }

    return ((s < 0) ? "-" : "") + output;
}

///@description Turns hex string into base10 real.
function hex(str) {
    var result = 0;

    // special unicode values
    static ZERO = ord("0");
    static NINE = ord("9");
    static A = ord("A");
    static F = ord("F");

    for (var i = 1; i <= string_length(str); i++) {
        var c = ord(string_char_at(string_upper(str), i));
        // you could also multiply by 16 but you get more nerd points for bitshifts
        result = result << 4;
        // if the character is a number or letter, add the _value
        // it represents to the total
        if (c >= ZERO && c <= NINE) {
            result = result + (c - ZERO);
        } else if (c >= A && c <= F) {
            result = result + (c - A + 10);
        // otherwise complain
        } else {
            throw "bad input for hex(str): " + str;
        }
    }

    return result;
}