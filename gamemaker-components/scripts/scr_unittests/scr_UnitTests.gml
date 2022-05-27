 function TestCase(_description, _test, _before = undefined, _after = undefined) constructor {
	description = _description;
	test = _test;
	before = _before
	after = _after
}

TagScript(GetAllScripts, tag_command);
function GetAllScripts() {
	static allScripts = tag_get_asset_ids(tag_script, asset_script);
	array_foreach(allScripts, function(scrIndex) {
		show_debug_message(script_get_name(scrIndex));
		
	});
	return allScripts;
}

TagScript(RunAllUnitTets, tag_command);
function RunAllUnitTets() {
	var unitTests = GetScriptIds(tag_unit_test);
	var allTests = [];

	var testScriptCount = array_length(unitTests);
	for(var i = 0; i < testScriptCount; i += 1) {
		var methodBinding = method(undefined, unitTests[i]);
		array_concat(allTests, methodBinding(), allTests);
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
			error: passed ? "" : newError,
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