#macro COPY_PARAMS var _params=[] for(var __i = 0; __i < argument_count; __i += 1) array_push(_params, argument[__i])

function array_create_empty() {
    return [];
}

/// @param {Array<any>}     _source
/// @param {Array<any>}     _destination
/// @param {Function}       _callback
/// @return {Array<any>}
function array_deep_copy(_source, _destination = [], _callback = undefined) {
    if(!is_array(_source)) {
        throw ("_source is not an array");
    }
    if(!is_array(_destination)) {
        throw ("_destination is not an array");
    }

    var _sourceLength = array_length(_source);

    for(var i = 0; i < _sourceLength; i += 1)
    {
        var _propVal = _source[i];
        var _copiedValue = undefined;
        if(is_struct(_propVal)) {
            _copiedValue = struct_deep_copy(_propVal, {}, _callback);
        } else if(is_array(_propVal) ) {
            // Is any value
            // Feather disable once GM1043
            _copiedValue = array_deep_copy(_propVal, [], _callback);
        } else {
            _copiedValue = _propVal;
        }

        _destination[@i] = _copiedValue;
    }

    if(is_callable(_callback)) {
        _callback(_source, _destination);
    }

    return _destination;
}

/// @function              array_join(array, seperator = "")
/// @description           Joins all the elements of the array together as a string seperated by the seperator.
/// @param {Array<Any>}    _array The array of which to join the elements.
/// @param {String}        _seperator The string which to put inbetween joined elements.
/// @return {String}
function array_join(_array, _seperator = "") {
    var _joinedValues = "";
    var _arrayLength = array_length(_array);
    for(var i = 0; i < _arrayLength; i += 1 ) {
        _joinedValues += string(_array[@i]) + _seperator;
    }
    var _seperatorLength = string_length(_seperator);
    var _joinedValuesLength = string_length(_joinedValues);
    var _stringDeleteIndex = 1 + _joinedValuesLength - _seperatorLength;
    return string_delete(_joinedValues, _stringDeleteIndex, _seperatorLength);
}

/// @function              array_delete_fast(array, index)
/// @description           Warning: Deletes the value at _index, but does not preserve array order.
/// @param {Array<Any>}    _array The array to delete from
/// @param {Real}          _index The index of the array which will be removed.
function array_delete_fast(_array, _index) {
    var _arrayEnd = array_length(_array) - 1;
    _array[_index] = _array[_arrayEnd];
    array_pop(_array);
}

/// @function              array_remove(array, value)
/// @description           Removes all values in the array which match value
/// @param {Array<Any>}    _array The array to search
/// @param {Any}           _value The value which will be removed from the array
/// @return {Array<Any>}
function array_remove(_array, _value) {
    var _arrayLength = array_length(_array);
    var i = 0;
    while(i < _arrayLength) {
        var _checkVal = _array[@ i];
        if(_checkVal == _value) {
            array_delete(_array, i, 1);
            _arrayLength -= 1;
        } else {
            i += 1;
        }
    }
    
    return _array;
}

/// @function              array_remove_first(array, value)
/// @description           Removes the first element in the array which matches value
/// @param {Array<Any>}    _array The array to search
/// @param {Any}           _value The value which will be removed from the array. Only the first is removed.
/// @return {Array<Any>}
function array_remove_first(_array, _value) {
    var _index = array_get_index(_array, _value);
    array_delete(_array, _index, 1);

    return _array;
}

/// @function              array_remove_fast(array, value)
/// @description           Removes all values from array with equal to _value. WARNING: Does not preserve array order.
/// @param {Array<Any>}    _array The array to search
/// @param {Any}           _value The value which will be removed from the array. ALL are removed.
/// @return {Array<Any>}
function array_remove_fast(_array, _value) {
    var _arrayLength = array_length(_array);
    var i = _arrayLength - 1;
    var _swapIndex = i;

    while(i > -1) {
        if(_array[i] == _value) {
            _array[i] = _array[_swapIndex];
            _swapIndex -= 1;
            _arrayLength -=1;
        }
        i -= 1;
    }

    array_resize(_array, _arrayLength);

    return _array;
}


/// @function                array_find_value(array, method)
/// @description             Returns the first value from the array where the predicate returns true. Or undefined if no match.
/// @param {Array}           _array    The array to search
/// @param {Function}        _method   The predicate. Will return the value that this predicate returns true for.
/// @return {Any}
function array_find_value(_array, _method) {
    var _arrayLength = array_length(_array);
    for(var i = 0; i < _arrayLength; i += 1) {
        var _val = _array[@ i];
        if( _method(_val) ) {
            return _val;
        }
    }
    return undefined;
}


/// @function                  array_concat_ext(arrayA, arrayB, arrayDest = undefined)
/// @description               Returns two arrays concatted. Optionally into a specfific array.
/// @param {Array<Any>}        _arrayA    First array
/// @param {Array<Any>}        _arrayB    Second array
/// @param {Array<Any>}        _arrayDest  Destination array
/// @return {Array<Any>}
function array_concat_ext(_arrayA, _arrayB, _arrayDest = undefined) {
    var _aLength = array_length(_arrayA);
    var _bLength = array_length(_arrayB);
    if(is_array(_arrayDest)) {
        array_resize(_arrayDest, _aLength + _bLength);
    } else {
        _arrayDest = array_create(_aLength + _bLength);
    }
    
    if(_arrayA == _arrayDest) {
        //copy b to end of a
        array_copy(_arrayDest, _aLength, _arrayB, 0, _bLength);
    } else {
        //copy b to the end
        array_copy(_arrayDest, _aLength, _arrayB, 0, _bLength);
        //copy a to the beggining
        array_copy(_arrayDest, 0,       _arrayA, 0, _aLength);
    }

    return _arrayDest;
}

///@description Find the index of an element via a search on sorted elements
///@param {array} _array
///@param {any} _value
function array_binary_search(_array, _value) {
    var _start = 0;
    var _end = array_length(_array) - 1;

    // Iterate while start not meets end
    while (_start <= _end) {

        // Find the mid index
        var _mid = floor((_start + _end) / 2);

        // If element is present at 
        // mid, return the index
        if (_array[_mid] == _value) return _mid;

        // Else look in left or 
        // right half accordingly
        else if (_array[_mid] < _value)
            _start = _mid + 1;
        else
            _end = _mid - 1;
    }

    return -1;
}

///@desc Insert an element into a already sorted array.
///@param {array} _array
///@param {any} _value
function array_insert_sorted(_array, _value) {
    var _start = 0;
    var _end = array_length(_array);

    while (_start < _end) {
        var _mid = floor((_start + _end) / 2);

        if (_array[_mid] < _value) {
            _start = _mid + 1;
        } else { 
            _end = _mid;
        }
    }

    array_insert(_array, _start, _value);

    return -1;
}

///@desc Insert an element into a already sorted array.
///@param {array} _array
///@param {any} _value
function array_insert_sorted_unique(_array, _value) {
    var _start = 0;
    var _end = array_length(_array);

    while (_start < _end) {
        var _mid = floor((_start + _end) / 2);

        if(_array[_mid] == _value) {
            return false;
        } else if (_array[_mid] < _value) {
            _start = _mid + 1;
        } else { 
            _end = _mid;
        }
    }

    array_insert(_array, _start, _value);
    return true;
}