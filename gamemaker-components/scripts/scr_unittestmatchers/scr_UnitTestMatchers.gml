function GetDebugCallstackString() {
	var callStack = debug_get_callstack();
	array_shift(callStack, 2);
	return "\n" + array_join(callStack, "\n");
}

function MatcherArraysEqual(_a, _b) {
	var callbackString = GetDebugCallstackString();
	
	if(!is_array(_a)) {
		throw "Arrays not equal: _a is not an array." + callbackString;
	}
	if(!is_array(_b)) {
		throw "Arrays not equal: _b is not an array." + callbackString;
	}
	if(array_length(_a) != array_length(_b)) {
		throw String("Arrays not equal: _a is different length than _b. _a is ", _a, " and _b is ", _b) + callbackString;
	}
	if(!array_equals(_a, _b)) {
		throw String("Arrays not equal: _a is different than _b. _a is ", _a, " and _b is ", _b) + callbackString;
	}
}

function MatcherShouldThrow(_throwingMethod) {
	var callbackString = GetDebugCallstackString();
	
	if(!is_method(_throwingMethod)) {
		throw "MatcherShouldThrow expects to be passed a method it calls which will execute and test for throwing.";
	}
	var didThrow = false;
	try {
		_throwingMethod();
	}
	catch(_error) {
		didThrow = true;
	}
	
	if(!didThrow) {
		throw "Expected method to throw. " + callbackString;
	}
}

function MatcherValueEqual(_a, _b) {
	var callbackString = GetDebugCallstackString();
	
	if(_a != _b) {
		throw String("_a is not equal to _b. _a is ", _a, " and _b is ", _b) + callbackString;
	}
}
