function array_deep_copy(_value) {
	static array_deep_copy_helper = function(_destination, _source) {
		
		if(!is_array(_source)) {
			throw ("_source is not an array");
		}
		
		var sourceLength = array_length(_source);
		
		for(var i = 0; i < sourceLength; i += 1)
		{
			var propVal = _source[i];
			var copiedValue;
			if(is_struct(propVal)) {
				copiedValue = struct_deep_copy(propVal);
			} else if(is_array(propVal) ) {
				copiedValue = array_deep_copy(propVal);
			} else {
				copiedValue = propVal;	
			}
			
			_destination[@i] = copiedValue;
		}
	};
	
	var destination = array_create(array_length(_value));
	array_deep_copy_helper(destination, _value);
	return destination;
}

function array_join(_array, _seperator = "") {
	var joinedValues = "";
	var arrayLength = array_length(_array);
	for(var i = 0; i < arrayLength; i += 1 ) {
		joinedValues += string(_array[@i]) + _seperator;
	}
	var seperatorLength = string_length(_seperator);
	var joinedValuesLength = string_length(joinedValues);
	var stringDeleteIndex =  1 + joinedValuesLength - seperatorLength;
	return string_delete(joinedValues, stringDeleteIndex, seperatorLength);
}

//WARNING: Does not maintain order of array!!!
function array_delete_fast(_array, _index) {
	var arrayEnd = array_length(_array) - 1;
	_array[_index] = _array[arrayEnd];
	array_pop(_array);
}

function array_foreach(_array, _method, _context = undefined) {
	var arrayLength = array_length(_array);
	if(_context) {
		_method = method(_context, _method);	
	}
	for(var i = 0; i < arrayLength; i += 1) {
		_method(_array[@ i], i, _array);	
	}
}

function array_remove(_array, _value) {
	var listLength = array_length(_array);
	var i = 0;
	while(i < listLength) {
		var value = _array[@ i];
		if(value == _value) {
			array_delete(_array, i, 1);
			listLength -= 1;
		} else {
			i += 1;
		}
	}
	
	return _array;
}

function array_remove_first(_array, _value) {
	var arrayLength = array_length(_array);
	for(var i = 0; i < arrayLength; i += 1) {
		if(_array[@ i] == _value) {
			array_delete(_array, i, 1);
			break;
		}
	}

	return _array;
}

//WARNING: Does not maintain order of array!!!
function array_remove_fast(_array, _value) {
	var listLength = array_length(_array);
	var i = listLength - 1;
	var swapIndex = i;

	while(i > -1) {
		if(_array[i] == _value) {
			_array[i] = _array[swapIndex];
			swapIndex -= 1;
			listLength -=1;
		}
		i -= 1;
	}
	
	array_resize(_array, listLength);
	
	return _array;
}

function array_find_index(_array, _value) {
	var arrayLength = array_length(_array);
	for(var i = 0; i < arrayLength; i += 1) {
		if(_array[@ i] == _value) {
			return i;	
		}
	}
	return -1;
}

function array_find_value(_array, _method, _context = undefined) {
	if(_context) {
		_method = method(_context, _method);
	}
	var arrayLength = array_length(_array);
	for(var i = 0; i < arrayLength; i += 1) {
		var val = _array[@ i];
		if( _method(val) ) {
			return val;
		}
	}
	return undefined;
}

function array_concat(_arrayA, _arrayB, _arrayDest = undefined) {
	var aLength = array_length(_arrayA);
	var bLength = array_length(_arrayB);
	if(is_array(_arrayDest)) {
		array_resize(_arrayDest, aLength + bLength);
	} else {
		_arrayDest = array_create(aLength + bLength);
	}
	
	if(_arrayA == _arrayDest) {
		//copy b to end of a
		array_copy(_arrayDest, aLength, _arrayB, 0, bLength);
	} else {
		//copy b to the end
		array_copy(_arrayDest, aLength, _arrayB, 0, bLength);
		//copy a to the beggining
		array_copy(_arrayDest, 0,       _arrayA, 0, aLength);
	}

	return _arrayDest;
}

///@desc array_map iterates every element of an array and transforms it using method to destArray
///@param {array} _array
///@param {Function} _method
///@param {Mixed|Undefined} _context
///@param {array} _destArray
///@return {Array<Mixed>}
function array_map(_array, _method, _context = undefined, _destArray = []) {
	var arrayLength = array_length(_array);
	if( !is_array(_destArray) ) {
		_destArray = array_create(arrayLength);	
	}
	if(_context) {
		_method = method(_context, _method);	
	}
	
	array_resize(_destArray, arrayLength);
	for(var i = 0; i < arrayLength; i += 1) {
		_destArray[@ i] = _method(_array[@ i], i, _array);	
	}
	return _destArray;
}

function array_shift(_array, _length = 1) {
	var arrayLength = array_length(_array);
	var newLength = arrayLength - _length;
	if(_length > arrayLength) {
		throw String("Attmped to shift array with length(", arrayLength, ")", " (", _length , ") elements. Cannot shift greater than array length.");	
	}
	
	var shiftedValues = array_create(_length);
	array_copy(shiftedValues, 0, _array, 0, _length);
	for(var i = _length; i <= newLength; i += 1) {
		_array[i - _length] = _array[i];
	}
	array_resize(_array, newLength);
	return shiftedValues;
}
