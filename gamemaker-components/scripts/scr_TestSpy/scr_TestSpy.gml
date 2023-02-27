function test_spy_callable() {
    COPY_PARAMS;
    array_push(callsToSpy, _params);
}

function test_spy_create() {
    var _self = new TestSpyInstance();
    _self.spyMethod = method(_self, test_spy_callable)
    return _self;
}

///@param {Function} _spyMethod
function TestSpyInstance(_spyMethod = undefined) constructor {
    // Feather disable GM2017
    callsToSpy = [];
    spyMethod = _spyMethod;
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
}
