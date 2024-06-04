tag_script(instance_variables_test, [TAG_UNIT_TEST_SPEC]);
function instance_variables_test() {
    return [
        describe("instance_variables_test", function() {
        before_each(function() {
            testInstance = instance_create_depth(0, 0, 0, obj_test_for_unit_test, {
                testValue: 0,
                testString: "I am a string",
                testArray: ["I am", "an", "array", "with", 90, 10, obj_test_for_unit_test],
                testObjectIndex: obj_test_for_unit_test,
                testSpriteIndex: spr_mask_noclip
            });
        });
        after_each(function() {
            instance_destroy(testInstance);
        });
            it("should show all variables of the testInstance obj", function() {
                var _str = "";
                var _gameId = testInstance.id;
                var _array = variable_instance_get_names(_gameId);
                
                show_debug_message("Variables for " + object_get_name(testInstance.object_index)+ ": " + string(_gameId));
                for (var i = 0; i < array_length(_array); i++)
                {
                    _str = _array[i] + ":" + string(variable_instance_get(_gameId, _array[i]));
                    show_debug_message(_str);
                }
            });
            it("can dynamicly access built in variables", function() {
                testInstance.x = 32;
                var _xVal = variable_instance_get(testInstance, "x");
                
                matcher_value_equal(testInstance.x, 32);
                matcher_value_equal(_xVal, 32);
            });
        })
    ];
}