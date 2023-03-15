///@self TestSpyInstance
///@return {Any}
function test_spy_callable() {
    COPY_PARAMS;
    array_push(callsToSpy, _params);

    if(callThrough && is_defined(originalMethod)) {
        return method_call(originalMethod, _params);
    }

    return returnValue;
}

///@return {struct.TestSpyInstance}
function test_spy_create() {
    var _self = new TestSpyInstance();
    _self.spyMethod = method(_self, test_spy_callable)
    return _self;
}

///@param {Struct} _struct
///@param {String} _funcName
///@param {Bool} _callThrough
///@return {Struct.TestSpyInstance}
function spy_on(_struct, _funcName, _callThrough = false) {
    if(!variable_struct_exists(_struct, _funcName) || !is_method(_struct[$ _funcName]) ) {
        throw string_join("", "Cannot spy on struct with property ", _funcName, " because property does not exsit. Or is not a method.");
    }
    
    var _newSpy = test_spy_create();
    _newSpy.originalMethod = method(_struct, _struct[$ _funcName]);
    _newSpy.callThrough = _callThrough;
    _struct[$ _funcName] = _newSpy.spyMethod;
    return _newSpy;
}

///@param {Function} _spyMethod
///@param {Function} _originalMethod
function TestSpyInstance(_spyMethod = undefined, _originalMethod = undefined) constructor {
    // Feather disable GM2017
    callsToSpy = [];
    spyMethod = _spyMethod;
    originalMethod = _originalMethod;
    callThrough = false;
    returnValue = undefined;
    // Feather restore GM2017

    static toBeCalled = function() {
        var _isCalled = array_length(callsToSpy) > 0;
        
        if(!_isCalled) {
            throw "Method was not called";
        }
    }
        
    static toBeCalledWith = function() {
        COPY_PARAMS;
        var _firstCall = callsToSpy[0];
        var _sameParams = array_equals(_params, _firstCall);
        
        if(!_sameParams) {
            throw string_join("", _firstCall, " did not match ", _params);
        }
    }
    
    ///@param {Real} _expectedCount
    static toBeCalledTimes = function(_expectedCount) {
        COPY_PARAMS;
        var _callCount = array_length(callsToSpy);
        
        if(_callCount != _expectedCount) {
            throw string_join("", "Spy was called ", _callCount, " times instead of the expected ", _expectedCount, " times.");
        }
    }
    
    static andReturn = function(_value) {
        returnValue = _value;
        return self;
    }
}
