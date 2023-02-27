function scrape_anon_function_location(_method) {
    var _searchTerm = "gml_GlobalScript_";
    var _searchTermLength = string_length(_searchTerm)
    var _scrName = script_get_name(_method);
    var _strLen = string_length(_scrName);
    var _namePos = string_last_pos(_searchTerm, _scrName);

    if(_namePos == 0) {
        return "OOPS DAISY";
    }
    
    var _count = _strLen - _namePos - _searchTermLength + 1;
    return string_copy(_scrName, _namePos + _searchTermLength, _count);
}

function get_debug_callstack_string() {
    var _callStack = debug_get_callstack();
    var _callSite = _callStack[2];
    var _colIndex = string_pos(":", _callSite);
    var _strLen = string_length(_callSite);
    var _copyCount = _strLen - _colIndex;
    var _lineNumber = string_copy(_callSite, _colIndex + 1, _copyCount);
    return "\nLine number: " + _lineNumber;
}

function matcher_arrays_equal(_a, _b) {
    var _callbackString = get_debug_callstack_string();
    
    if(!is_array(_a)) {
        throw "Arrays not equal: _a is not an array." + _callbackString;
    }
    if(!is_array(_b)) {
        throw "Arrays not equal: _b is not an array." + _callbackString;
    }
    if(array_length(_a) != array_length(_b)) {
        throw string_join("", "Arrays not equal: _a is different length than _b. _a is ", _a, " and _b is ", _b, _callbackString);
    }
    if(!array_equals(_a, _b)) {
        throw string_join("", "Arrays not equal: _a is different than _b. _a is ", _a, " and _b is ", _b, _callbackString);
    }
}

function matcher_should_throw(_throwingMethod) {
    var _callbackString = get_debug_callstack_string();
    
    if(!is_method(_throwingMethod)) {
        throw "matcher_should_throw expects to be passed a method it calls which will execute and test for throwing.";
    }
    var _didThrow = false;
    try {
        _throwingMethod();
    }
    catch(_error) {
        _didThrow = true;
    }
    
    if(!_didThrow) {
        throw "Expected method to throw. " + _callbackString;
    }
}

function matcher_value_equal(_a, _b) {
    var _callbackString = get_debug_callstack_string();
    
    if(_a != _b) {
        throw string_join("", "_a is not equal to _b. _a is ", _a, " and _b is ", _b, _callbackString);
    }
}

function matcher_is_array(_a) {
    var _callbackString = get_debug_callstack_string();
    
    if(!is_array(_a)) {
        throw string_join("", "_a is not an array. _a is ", _a, _callbackString);
    }
}

function matcher_is_defined(_a) {
    var _callbackString = get_debug_callstack_string();

    if(is_undefined(_a)) {
        throw "_a is undefined." + _callbackString;
    }
}

function matcher_struct_property_exists(_struct, _propName, _not = false) {
    var _callbackString = get_debug_callstack_string();

    if(variable_struct_exists(_struct, _propName) && _not) {
        var _message = _not ? 
              string_join("", "Property with name ", _propName, " found on struct." ) 
            : string_join("", "Property ", _propName, " is missing.");
        throw _message + _callbackString;
    }
}

function matcher_is_true(_a) {
    var _callbackString = get_debug_callstack_string();
    
    if(_a != true) {
        throw "_a is not true." + _callbackString;
    }
}

function matcher_is_instanceof(_instance, _type) {
    var _callbackString = get_debug_callstack_string();
    
    if(!is_instanceof(_instance, _type)) {
        throw "instance is not of the specified type." + _callbackString;
    }
}

