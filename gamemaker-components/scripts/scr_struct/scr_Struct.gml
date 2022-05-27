function struct_deep_copy(_value) {
	static struct_deep_copy_helper = function(_destination, _source) {
		
		if(!is_struct(_source)) {
			throw ("_source is not a struct");
		}
		
		var props = variable_struct_get_names(_source);
		var propCount = array_length(props);
		
		for(var i = 0; i < propCount; i += 1)
		{
			var propName = props[i];
			var propVal = _source[$ propName];
			var copiedValue;
			if(is_struct(propVal)) {
				copiedValue = struct_deep_copy(propVal);
			} else if(is_array(propVal) ) {
				copiedValue = array_deep_copy(propVal);
			} else {
				copiedValue = propVal;	
			}
			
			_destination[$propName] = copiedValue;
		}
	};
	
	var destination = {};
	struct_deep_copy_helper(destination, _value);
	return destination;
}

function struct_foreach(_struct, _method, _context = undefined) {
	var keys = variable_struct_get_names(_struct);
	
	var arrayLength = array_length(keys);
	if(_context) {
		_method = method(_context, _method);	
	}
	for(var i = 0; i < arrayLength; i += 1) {
		_method(_struct[$ keys[i]], _struct);	
	}
}
