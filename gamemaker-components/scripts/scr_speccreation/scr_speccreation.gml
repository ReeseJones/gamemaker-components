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

/// @desc Describe a set of spec definitions.
/// @param {string} _description description
/// @param {function} _specDefinitions A function which describes the specs.
/// @returns {struct} Returns the test suite this describe created
function Describe(_description, _specDefinitions) {	
	var testSuite = new TestSuite();
	var suiteBinding = method(testSuite, _specDefinitions);
	testSuite.description = _description;
	testSuite.scriptLocation = ScrapeAnonFunctionLocation(_specDefinitions);
	
	//Describes may nest within each other to create groups.
	if(is_struct(self) && instanceof(self) == "TestSuite") {
		array_push(self.children, testSuite);
	}
	
	suiteBinding();
	
	return testSuite;
}

/// @desc Describe a specific unit test
/// @param {string} _description description of the spec
/// @param {function} _spec The function that preforms the test
function It(_description, _spec) {
	if(is_struct(self) && instanceof(self) == "TestSuite") {
		array_push(self.tests, new SpecDescription(_description, _spec));
	} else {
		throw "It spec defined outside of a test suite";	
	}
}

/// @desc Setup code to run before a set of specs
/// @param {function} _beforeSetup The function that sets up the context for the unit tests
function BeforeEach(_beforeSetup) {
	if(is_struct(self) && instanceof(self) == "TestSuite") {
		array_push(self.befores, _beforeSetup);
	} else {
		throw "BeforeEach defined outside of a test suite";	
	}
}

/// @desc Setup code to run after a set of specs
/// @param {function} _afterTests The function that cleans up the context after the unit tests
function AfterEach(_afterTests) {
	if(is_struct(self) && instanceof(self) == "TestSuite") {
		array_push(self.afters, _afterTests);
	} else {
		throw "BeforeEach defined outside of a test suite";	
	}
}


function VisitAllTestSuites(_testSuite, _beforeStack = [], _afterStack = [], _descriptionStack = [], _testResults = []) {
		array_push(_beforeStack, _testSuite.befores);
		array_push(_afterStack, _testSuite.afters);
		array_push(_descriptionStack, _testSuite.description);
		
		
		var testCount = array_length(_testSuite.tests);
		for(var i = 0; i < testCount; i += 1) {
			var spec = _testSuite.tests[i];
			var testContext = {};
			
			array_foreach(_beforeStack, function(_befores) {
				array_foreach(_befores, function(_before) {
					var boundFunc = method(self, _before);
					boundFunc();
				}, self);
			}, testContext);
			
			var desc = array_join(_descriptionStack) + spec.description;
			var passed = false;
			var newError = undefined;

			try {
				var testFunc = method(testContext, spec.spec);
				testFunc();
				passed = true;
			}
			catch(_error) {
				passed = false;
				newError = _error;
			}
		
			var testResults = passed ? "PASSED: " : "FAILED: ";
			testResults += desc;
			
			if(!passed) {
				testResults += "\n" + string(newError) + " - " + _testSuite.scriptLocation; 
			}
			
			array_push(_testResults, testResults);
			
			for(var j = array_length(_afterStack) - 1; j >= 0; j -= 1) {
				var _afters = _afterStack[j];
				array_foreach(_afters, function(_after) {
					var boundFunc = method(self, _after);
					boundFunc();
				}, testContext);
			}
		}
		
		var childrenCount = array_length(_testSuite.children);
		for(var i = 0; i < childrenCount; i += 1) {
			var childTestSuite = _testSuite.children[i];
			VisitAllTestSuites(childTestSuite, _beforeStack, _afterStack, _descriptionStack, _testResults);
		}
		
		
		array_pop(_beforeStack);
		array_pop(_afterStack);
		array_pop(_descriptionStack);
		
		return _testResults;
	}

TagScript(RunAllSpecs, [tag_command]);
function RunAllSpecs() {
	var unitTests = GetScriptIds(tag_unit_test_spec);
	var allTestSuites = [];

	var testScriptCount = array_length(unitTests);
	for(var i = 0; i < testScriptCount; i += 1) {
		var methodBinding = method(undefined, unitTests[i]);
		array_concat(allTestSuites, methodBinding(), allTestSuites);
	}
	
	var resultsArray = [];
	var testSuitesLength = array_length(allTestSuites);
	for(var i = 0; i < testSuitesLength; i+= 1) {
		var testSuite = allTestSuites[i];
		var results = VisitAllTestSuites(testSuite);
		array_concat(resultsArray, results, resultsArray);
	}
	
	array_foreach(resultsArray, show_debug_message);
	return resultsArray;
}