///@description Turns base 10 real into a hex string
function string_hex(_value) {
    var _s = sign(_value);
    var _v = abs(_value);

    var _output = "";

    while (_v > 0)  {
        var _c  = _v & 0xf;
        _output = chr(_c + ((_c < 10) ? 48 : 55)) + _output;
        _v = _v >> 4;
    }

    if (string_length(_output) == 0) {
        _output = "0";
    }

    return ((_s < 0) ? "-" : "") + _output;
}

///@description Turns hex string into base10 real.
function hex(_str) {
    var _result = 0;

    // special unicode values
    static zero = ord("0");
    static nine = ord("9");
    static a = ord("a");
    static f = ord("f");

    for (var i = 1; i <= string_length(_str); i++) {
        var _c = ord(string_char_at(string_upper(_str), i));
        // you could also multiply by 16 but you get more nerd points for bitshifts
        _result = _result << 4;
        // if the character is a number or letter, add the _value
        // it represents to the total
        if (_c >= zero && _c <= nine) {
            _result = _result + (_c - zero);
        } else if (_c >= a && _c <= f) {
            _result = _result + (_c - a + 10);
        // otherwise complain
        } else {
            throw "bad input for hex(_str): " + _str;
        }
    }

    return _result;
}