/// @desc Description for SpecDescription
/// @param {string} _description description of the spec
/// @param {function} _spec The function that preforms the test
function SpecDescription(_description, _spec) constructor {
    description = _description;
    spec = _spec;
}

function TestSuite() constructor {
    description = "";
    tests = [];
    befores = [];
    afters = [];
    children = [];
    scriptLocation = "";
}

/// @desc describe a set of spec definitions.
/// @param {string} _description description
/// @param {function} _specDefinitions A function which describes the specs.
/// @returns {struct} Returns the test suite this describe created
function describe(_description, _specDefinitions) {    
    var _testSuite = new TestSuite();
    var _suiteBinding = method(_testSuite, _specDefinitions);
    _testSuite.description = _description;
    _testSuite.scriptLocation = scrape_anon_function_location(_specDefinitions);

    //Describes may nest within each other to create groups.
    if(is_struct(self) && is_instanceof(self, TestSuite)) {
        array_push(self.children, _testSuite);
    }

    _suiteBinding();

    return _testSuite;
}

/// @desc describe a specific unit test
/// @param {string} _description description of the spec
/// @param {function} _spec The function that preforms the test
function it(_description, _spec) {
    if(is_struct(self) && is_instanceof(self, TestSuite)) {
        array_push(self.tests, new SpecDescription(_description, _spec));
    } else {
        throw "it spec defined outside of a test suite";    
    }
}

/// @desc Setup code to run before a set of specs
/// @param {function} _beforeSetup The function that sets up the context for the unit tests
function before_each(_beforeSetup) {
    if(is_struct(self) && is_instanceof(self, TestSuite)) {
        array_push(self.befores, _beforeSetup);
    } else {
        throw "before_each defined outside of a test suite";    
    }
}

/// @desc Setup code to run after a set of specs
/// @param {function} _afterTests The function that cleans up the context after the unit tests
function after_each(_afterTests) {
    if(is_struct(self) && is_instanceof(self, TestSuite)) {
        array_push(self.afters, _afterTests);
    } else {
        throw "before_each defined outside of a test suite";    
    }
}

/// @desc describe a set of spec definitions.
/// @param {Struct.TestSuite} _testSuite
/// @param {Array<Any>} _beforeStack
/// @param {Array<Any>} _afterStack
/// @param {Array<Any>} _descriptionStack
/// @param {Array<Any>} _testResults
/// @returns {Array<Any>}
function visit_all_test_suites(_testSuite, _beforeStack = [], _afterStack = [], _descriptionStack = [], _testResults = []) {
        array_push(_beforeStack, _testSuite.befores);
        array_push(_afterStack, _testSuite.afters);
        array_push(_descriptionStack, _testSuite.description);
        
        
        var _testCount = array_length(_testSuite.tests);
        for(var i = 0; i < _testCount; i += 1) {
            var _spec = _testSuite.tests[i];
            var _testContext = {};
            
            array_foreach(_beforeStack, method(_testContext, function(_befores) {
                array_foreach(_befores, method(self, function(_before) {
                    var _boundFunc = method(self, _before);
                    _boundFunc();
                }));
            }));
            
            //Adding two strings together: TODO: delete once better type info
            // Feather disable once GM1009
            var _desc = array_join(_descriptionStack) + _spec.description;
            var _passed = false;
            var _newError = undefined;

            try {
                var _testFunc = method(_testContext, _spec.spec);
                _testFunc();
                _passed = true;
            }
            catch(_error) {
                _passed = false;
                _newError = _error;
            }
        
            var _currentTestResults = _passed ? "PASSED: " : "FAILED: ";
            _currentTestResults += _desc;
            
            if(!_passed) {
                _currentTestResults += "\n" + string(_newError) + " - " + _testSuite.scriptLocation; 
            }
            
            array_push(_testResults, _currentTestResults);
            
            for(var j = array_length(_afterStack) - 1; j >= 0; j -= 1) {
                var _afters = _afterStack[j];
                array_foreach(_afters, method(_testContext, function(_after) {
                    var _boundFunc = method(self, _after);
                    _boundFunc();
                }));
            }
        }
        
        var _childrenCount = array_length(_testSuite.children);
        for(var i = 0; i < _childrenCount; i += 1) {
            var _childTestSuite = _testSuite.children[i];
            visit_all_test_suites(_childTestSuite, _beforeStack, _afterStack, _descriptionStack, _testResults);
        }
        
        
        array_pop(_beforeStack);
        array_pop(_afterStack);
        array_pop(_descriptionStack);
        
        return _testResults;
    }

tag_script(run_all_specs, [TAG_COMMAND]);
function run_all_specs() {
    var _unitTests = get_script_ids(TAG_UNIT_TEST_SPEC);
    var _allTestSuites = [];

    var _testScriptCount = array_length(_unitTests);
    for(var i = 0; i < _testScriptCount; i += 1) {
        // Should be asset id.
        // Feather disable once GM1041
        var _methodBinding = method(undefined, _unitTests[i]);
        array_concat_ext(_allTestSuites, _methodBinding(), _allTestSuites);
    }
    
    var _resultsArray = [];
    var _testSuitesLength = array_length(_allTestSuites);
    for(var i = 0; i < _testSuitesLength; i+= 1) {
        var _testSuite = _allTestSuites[i];
        var _results = visit_all_test_suites(_testSuite);
        array_concat_ext(_resultsArray, _results, _resultsArray);
    }
    
    //Intentionally passing show_debug_message
    // Feather disable once GM2017
    array_foreach(_resultsArray, show_debug_message);
    return _resultsArray;
}