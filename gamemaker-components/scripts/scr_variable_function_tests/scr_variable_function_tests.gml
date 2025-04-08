tag_script(scr_variable_function_tests, [TAG_UNIT_TEST_SPEC]);
function scr_variable_function_tests() {
    return [
        describe("is_handle", function() {
            before_each(function() {
                testInstance = instance_create_depth(0, 0, 0, obj_test_for_unit_test, {
                    testValue: 0,
                    testString: "I am a string",
                    testArray: ["I am", "an", "array", "with", 90, 10, obj_test_for_unit_test],
                    testObjectIndex: obj_test_for_unit_test,
                    testSpriteIndex: spr_mask_noclip,
                    testStructLiteral: {a: "1", b: 2, c: [3]},
                    testScript: scr_variable_function_tests,
                    testMethod: is_equal,
                });
            });
            after_each(function() {
                instance_destroy(testInstance);
            });
            it("should return false for structs", function() {
                matcher_is_false(is_handle(testInstance.testStructLiteral));
            });
            it("should return true object references", function() {
                matcher_is_true(is_handle(testInstance.testObjectIndex));
            });
            it("should return true function references", function() {
                matcher_is_true(is_handle(testInstance.testMethod));
            });
            it("should return false for methods", function() {
                matcher_is_false( is_handle ( method(testInstance, testInstance.testMethod) ) );
            });
            it("should return false for strings", function() {
                matcher_is_false( is_handle( testInstance.testString ) );
            });
            it("should return false for arrays", function() {
                matcher_is_false( is_handle( testInstance.testArray ) );
            });
        })
    ];
}