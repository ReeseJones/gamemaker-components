tag_script(array_tests, [TAG_UNIT_TEST_SPEC]);
function array_tests() {
return [
    describe("Arrays", function() {
        it("array_concat_ext should combine two arrays into the original array without issue", function() {
            var a = [1, 2, 3];
            var b = [4, 5, 6];
            var _expect = [1, 2, 3, 4, 5, 6];

            matcher_arrays_equal(array_concat_ext(a, b, a), _expect);
            matcher_arrays_equal(a, _expect);
            matcher_arrays_equal(b, [4, 5, 6]);
        });
        it("array_concat_ext should combine two arrays into the second array without issue", function() {
            var a = [1, 2, 3];
            var b = [4, 5, 6];
            var _expect = [1, 2, 3, 4, 5, 6];
            
            matcher_arrays_equal(array_concat_ext(a, b, b), _expect);
            matcher_arrays_equal(b, _expect);
            matcher_arrays_equal(a, [1, 2, 3]);
        });
        it("array_concat_ext should combine two arrays into a new array", function() {
            var a = [1, 2, 3];
            var b = [4, 5, 6];
            var _expect = [1, 2, 3, 4, 5, 6];
            
            matcher_arrays_equal(array_concat_ext(a, b), _expect);
            matcher_arrays_equal(a, [1, 2, 3]);
            matcher_arrays_equal(b, [4, 5, 6]);
        });
        it("array_shift should default remove first element in array", function() {
            var a = [1, 2, 3];
            var _expectA = [2, 3];
            var _expectResult = [1];
            
            matcher_arrays_equal(array_shift(a), _expectResult);
            matcher_arrays_equal(a, _expectA);
        });
        it("array_shift should remove be able to remove multiple elements in array", function() {
            var a = [1, 2, 3, 4, 5];
            
            matcher_arrays_equal(array_shift(a, 5), [1, 2, 3, 4, 5]);
            matcher_arrays_equal(a, []);
        });
        it("array_shift should throw if you try and shift more than the array size", function() {
            matcher_should_throw(function() {
                var a = [1, 2, 3, 4, 5];
                array_shift(a, 6);
            });
        });
        it("array_join should return the stringified values seperated by default nothing", function() {
            var a = [1, 2, 3, 4, 5];
            var _expect = "12345";
            
            var _result = array_join(a);
            matcher_value_equal(_result, _expect);
            matcher_arrays_equal(a, [1, 2, 3, 4, 5]);
        });
        it("array_join should return the stringified values seperated by 1 character _seperator", function() {
            var a = [1, 2, 3, 4, 5];
            var _expect = "1,2,3,4,5";
            var _seperator = ",";
            
            var _result = array_join(a, _seperator);
            matcher_value_equal(_result, _expect);
            matcher_arrays_equal(a, [1, 2, 3, 4, 5]);
        });
        it("array_join should return the stringified values seperated by multi character _seperator", function() {
            var a = [1, 2, 3, 4, 5];
            var _expect = "1, 2, 3, 4, 5";
            var _seperator = ", ";
            
            var _result = array_join(a, _seperator);
            matcher_value_equal(_result, _expect);
            matcher_arrays_equal(a, [1, 2, 3, 4, 5]);
        });
        it("array_delete_fast should remove the value at index of the array by swapping it to the end and popping", function() {
            var a = [1, 2, 3, 4, 5];
            var _removeIndex = 2;
            
            array_delete_fast(a, _removeIndex);
            matcher_arrays_equal(a, [1, 2, 5, 4]);
        });
        it("array_remove should iterate over elements of an array and remove all matching values", function() {
            var a = [2, 1, 2, 2, 3, 4, 2, 5, 2];
            var _removeValue = 2;
            
            array_remove(a, _removeValue);
            matcher_arrays_equal(a, [1, 3, 4, 5]);
        });
        it("array_remove_first should iterate over elements of an array and remove the first matching value", function() {
            var a = [2, 1, 2, 2, 3, 4, 2, 5, 2];
            var _removeValue = 2;
            
            array_remove_first(a, _removeValue);
            matcher_arrays_equal(a, [1, 2, 2, 3, 4, 2, 5, 2]);
        });
        it("array_find_value should return the first value which when passed in to the predicate returns true", function() {
            var _sam = {name: "sam"};
            var a = [{name: "bob"}, {name: "trey"}, _sam, {name: "Sarah"}];

            findValue = "sam";
            var _result = array_find_value(a, function(_person) {
                return _person.name == findValue;
            });
            
            matcher_value_equal(_result, _sam);
        });
        it("can have arbitrary code in macros", function() {
            var _testArguments = function() {
                COPY_PARAMS;
                matcher_is_array(_params);
                matcher_arrays_equal(_params, ["3", "2", "1", 1, 2, 3]);
            }

            _testArguments("3", "2", "1", 1, 2, 3);
        });
    })
];
}
