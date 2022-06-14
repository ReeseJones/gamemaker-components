function IsEqual(_val1, _val2) {
	return _val1 == _val2;
}


function ValueOrDefault(_value, _default) {
	if(is_undefined(_value)) {
		return _default;	
	}
	return _value;
}

function InstanceName(_id) {
	if ( instance_exists(_id) ) {
		return object_get_name(_id.object_index);	
	}
	return "undefined";
}

function String(values) {
	var concatString = "";
	
	for(var i = 0; i < argument_count; i += 1) {
		if(is_string(argument[i])) {
			concatString += argument[i];
		} else {
			concatString += string(argument[i]);
		}
			
	}
	
	return concatString;
}

function string_lowercase_first(_str) {
	var strLength = string_length(_str);
	if(strLength == 0) { 
		return "";	
	}

	var firstChar = string_char_at(_str, 1);
	var lowercaseChar = string_lower(firstChar);
	var copyLength = strLength - 1;
	if(copyLength > 0) {
		return lowercaseChar + string_copy(_str, 2, copyLength);
	}
	return lowercaseChar;
}