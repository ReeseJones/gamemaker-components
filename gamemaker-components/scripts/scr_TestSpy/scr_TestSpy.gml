function test_spy() {
    COPY_PARAMS;
    array_push(calls, _params);

}

function test_spy_create() {
    static toBeCalled = function() {
        var _isCalled = array_length(calls) > 0;
        
        if(!_isCalled) {
            throw "Method was not called";
        }
    }
    
    var _newMethod = method({}, test_spy);
    _newMethod.calls = [];
    _newMethod.toBeCalled = toBeCalled;
}