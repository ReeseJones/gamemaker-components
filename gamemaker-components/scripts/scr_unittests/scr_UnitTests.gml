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

TagScript(RunAllUnitTets, [tag_command]);
function RunAllUnitTets() {
	var unitTests = GetScriptIds(tag_unit_test);
	var allTests = [];

	var testScriptCount = array_length(unitTests);
	for(var i = 0; i < testScriptCount; i += 1) {
		var func = unitTests[i]
		array_concat(allTests, func(), allTests);
	}
	
	var testResults = array_map(allTests, function(_testCase) {
		var passed = false;
		var newError = undefined;
		if(is_method(_testCase.before)) {
			_testCase.before();
		}
		try {
			_testCase.test();
			passed = true;
		}
		catch(_error) {
			passed = false;
			newError = _error;
		}
		if(is_method(_testCase.after)) {
			_testCase.after();
		}
		
		return {
			description: _testCase.description,
			passed: passed,
			error: passed ? "" : String(newError),
			toString: function toString() {
				var passText = passed ? "PASSED: " : "FAILED: ";
				passText += description;
				if(string_length(error) > 0) {
					passText += "\n" + error;
				}
				return passText;
			}
		};
	});
	
	var testCount = array_length(testResults);
	for(var i = 0; i < testCount; i += 1) {
		show_debug_message(String(testResults[i]));
	}
	
	return testResults;
}