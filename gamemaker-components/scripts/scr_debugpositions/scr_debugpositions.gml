/*
	Courtesy of YellowAfterlife
*/

#macro __FILE__ debug_get_callstack_file(debug_get_callstack(), 0)
#macro __LINE__ debug_get_callstack_line(debug_get_callstack(), 0)
#macro __POS__  debug_get_callstack_pos (debug_get_callstack(), 0)

gml_pragma("global", "global.g_debug_get_callstack_pos = ds_map_create();");
function debug_get_callstack_pos(_callstack, _stackPos) {
	var _item = _callstack[_stackPos];
	
	var _pos = global.g_debug_get_callstack_pos[?_item];
	if (is_undefined(_pos)) {
	    _pos = _item;
	    if (string_copy(_pos, 1, 4) == "gml_")
	    switch (string_ord_at(_pos, 5)) {
	        case ord("S"): case ord("O"): // gml_Script_, gml_Object_
	            _pos = string_delete(_pos, 1, 11);
	            break;
	    }
	    global.g_debug_get_callstack_pos[?_item] = _pos;
	}
	return _pos;	
}

gml_pragma("global", "global.g_debug_get_callstack_file = ds_map_create();");
function debug_get_callstack_file(_callstack, _stackPos) {
	var _item = _callstack[_stackPos];
	var _file = global.g_debug_get_callstack_file[?_item];
 
	if (is_undefined(_file)) {
	    _file = _item;
	    var _pos = string_pos(":", _file);
		
	    if (_pos) {
			_file = string_copy(_file, 1, _pos - 1);
		}
	    
	    if (string_copy(_file, 1, 4) == "gml_") {
			switch ( string_ord_at(_file, 5) ) {
		        case ord("S"):
				case ord("O"):
		            _file = string_delete(_file, 1, 11);
		            break;
			}
		}

	    global.g_debug_get_callstack_file[?_item] = _file;
	}
	
	return _file;
}

gml_pragma("global", "global.g_debug_get_callstack_line = ds_map_create();");
function debug_get_callstack_line(_callstack, _stackPos) {
	
	var _item = _callstack[_stackPos];
	var _line = global.g_debug_get_callstack_line[?_item];
	
	if (is_undefined(_line)) {
	    var _pos = string_pos(":", _item);
	    if (_pos) {
	        _line = real(string_delete(_item, 1, _pos));
	    } else {
			_line = -1;
		}
	    global.g_debug_get_callstack_line[?_item] = _line;
	}
	
	return _line;
}

