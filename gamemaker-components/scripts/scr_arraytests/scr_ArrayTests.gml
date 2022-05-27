TagScript(ArrayTests, tag_unit_test);
function ArrayTests() {
	return [
		new TestCase("Array concat should combine two arrays into the original array without issue", function() {
			var a = [1, 2, 3];
			var b = [4, 5, 6];
			var expect = [1, 2, 3, 4, 5, 6];
			
			MatcherArraysEqual(array_concat(a, b, a), expect);
			MatcherArraysEqual(a, expect);
			MatcherArraysEqual(b, [4, 5, 6]);
		}),
		new TestCase("Array concat should combine two arrays into the second array without issue", function() {
			var a = [1, 2, 3];
			var b = [4, 5, 6];
			var expect = [1, 2, 3, 4, 5, 6];
			
			MatcherArraysEqual(array_concat(a, b, b), expect);
			MatcherArraysEqual(b, expect);
			MatcherArraysEqual(a, [1, 2, 3]);
		}),
		new TestCase("Array concat should combine two arrays into a new array", function() {
			var a = [1, 2, 3];
			var b = [4, 5, 6];
			var expect = [1, 2, 3, 4, 5, 6];
			
			MatcherArraysEqual(array_concat(a, b), expect);
			MatcherArraysEqual(a, [1, 2, 3]);
			MatcherArraysEqual(b, [4, 5, 6]);
		}),
		new TestCase("Array Shift should default remove first element in array", function() {
			var a = [1, 2, 3];
			var expectA = [2, 3];
			var expectResult = [1];
			
			MatcherArraysEqual(array_shift(a), expectResult);
			MatcherArraysEqual(a, expectA);
		}),
		new TestCase("Array Shift should remove be able to remove multiple elements in array", function() {
			var a = [1, 2, 3, 4, 5];
			
			MatcherArraysEqual(array_shift(a, 5), [1, 2, 3, 4, 5]);
			MatcherArraysEqual(a, []);
		}),
		new TestCase("Array Shift should throw if you try and shift more than the array size", function() {
			MatcherShouldThrow(function() {
				var a = [1, 2, 3, 4, 5];
				array_shift(a, 6);
			});
		}),
		new TestCase("Array Join should return the stringified values seperated by default nothing", function() {
			var a = [1, 2, 3, 4, 5];
			var expect = "12345";
			
			var result = array_join(a);
			MatcherValueEqual(result, expect);
			MatcherArraysEqual(a, [1, 2, 3, 4, 5]);
		}),
		new TestCase("Array Join should return the stringified values seperated by 1 character seperator", function() {
			var a = [1, 2, 3, 4, 5];
			var expect = "1,2,3,4,5";
			var seperator = ",";
			
			var result = array_join(a, seperator);
			MatcherValueEqual(result, expect);
			MatcherArraysEqual(a, [1, 2, 3, 4, 5]);
		}),
		new TestCase("Array Join should return the stringified values seperated by multi character seperator", function() {
			var a = [1, 2, 3, 4, 5];
			var expect = "1, 2, 3, 4, 5";
			var seperator = ", ";
			
			var result = array_join(a, seperator);
			MatcherValueEqual(result, expect);
			MatcherArraysEqual(a, [1, 2, 3, 4, 5]);
		}),
		new TestCase("array_delete_fast should remove the value at index of the array by swapping it to the end and popping", function() {
			var a = [1, 2, 3, 4, 5];
			var removeIndex = 2;
			
			array_delete_fast(a, removeIndex);
			MatcherArraysEqual(a, [1, 2, 5, 4]);
		}),
		new TestCase("array_remove should iterate over elements of an array and remove all matching values", function() {
			var a = [2, 1, 2, 2, 3, 4, 2, 5, 2];
			var removeValue = 2;
			
			array_remove(a, removeValue);
			MatcherArraysEqual(a, [1, 3, 4, 5]);
		}),
		new TestCase("array_remove_first should iterate over elements of an array and remove the first matching value", function() {
			var a = [2, 1, 2, 2, 3, 4, 2, 5, 2];
			var removeValue = 2;
			
			array_remove_first(a, removeValue);
			MatcherArraysEqual(a, [1, 2, 2, 3, 4, 2, 5, 2]);
		}),
		new TestCase("array_find_index should return the first index with matching value", function() {
			var a = [2, 1, 2, 2, 3, 4, 2, 5, 2];
			var findValue = 3;
			var expectedIndex = 4;
			
			MatcherValueEqual(array_find_index(a, findValue), expectedIndex);
		}),
		new TestCase("array_find_index should return -1 if value is not found", function() {
			var a = [2, 1, 2, 2, 3, 4, 2, 5, 2];
			var findValue = 10;
			var expectedIndex = -1;
			
			MatcherValueEqual(array_find_index(a, findValue), expectedIndex);
		}),
		new TestCase("array_find_value should return the first value which when passed in to the predicate returns true", function() {
			var sam = {name: "sam"};
			var a = [{name: "bob"}, {name: "trey"}, sam, {name: "Sarah"}];
			var findValue = sam;
			var result = array_find_value(a, function(_person) {
				return _person.name == searchName
			}, {searchName: "sam"});
			
			MatcherValueEqual(result, sam);
		}),
		new TestCase("array_map should call a method on every element of an array and copy the result to another array", function() {
			var a = [{name: "bob"}, {name: "trey"}, {name: "sam"}, {name: "Sarah"}];
			var expect =["bob", "trey", "sam", "Sarah"];
			var result = array_map(a, function(_person){ return _person.name});
			
			MatcherArraysEqual(result, expect);
		}),
		new TestCase("array_map should call a method on every element of an array and copy the result to another array and work with contexts", function() {
			var a = [{name: "bob"}, {name: "trey"}, {name: "sam"}, {name: "Sarah"}];
			var expect =["bob jones", "trey jones", "sam jones", "Sarah jones"];
			var context = {lastName: "jones"};
			var result = array_map(a, function(_person){ return _person.name + " " + lastName}, context);
			
			MatcherArraysEqual(result, expect);
		})
	];
}

