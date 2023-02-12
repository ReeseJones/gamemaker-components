 /// @desc Test case holds unit test data
/// @param {string} _description The description of this unit test
/// @param {Function} _test The function which runs the test code
/// @param {Function} [_before] The function which sets up data in the test instance before the test is ran.
/// @param {Function} [_after] The function which tears down data in the test instsance after the test is ran.
function TestCase(_description, _test, _before = undefined, _after = undefined) constructor {
    description = _description;
    test = _test;
    before = _before
    after = _after
}

tag_script(run_all_unit_tests, [TAG_COMMAND]);
function run_all_unit_tests() {
    var _unitTests = get_script_ids(TAG_UNIT_TEST);
    var _allTests = [];

    var _testScriptCount = array_length(_unitTests);
    for(var i = 0; i < _testScriptCount; i += 1) {
        var _func = _unitTests[i]
        array_concat_ext(_allTests, _func(), _allTests);
    }
    
    var _testResults = array_map(_allTests, function(_testCase) {
        var _passed = false;
        var _newError = undefined;
        if(is_method(_testCase.before)) {
            _testCase.before();
        }
        try {
            _testCase.test();
            _passed = true;
        }
        catch(_error) {
            _passed = false;
            _newError = _error;
        }
        if(is_method(_testCase.after)) {
            _testCase.after();
        }
        
        return {
            description: _testCase.description,
            passed: _passed,
            error: _passed ? "" : string(_newError),
            toString: function toString() {
                var _passText = passed ? "PASSED: " : "FAILED: ";
                _passText += description;
                if(string_length(error) > 0) {
                    _passText += "\n" + error;
                }
                return passText;
            }
        };
    });

    var _testCount = array_length(_testResults);
    for(var i = 0; i < _testCount; i += 1) {
        show_debug_message(string(_testResults[i]));
    }

    return _testResults;
}