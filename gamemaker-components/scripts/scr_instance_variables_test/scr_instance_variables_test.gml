tag_script(instance_variables_test, [TAG_UNIT_TEST_SPEC]);
function instance_variables_test() {
    return [
        describe("instance_variables_test", function() {
            it("should show all variables of the game obj", function() {
                var _str = "";
                var _gameId = obj_game.id;
                var _array = variable_instance_get_names(_gameId);
                
                show_debug_message("Variables for " + object_get_name(obj_game) + string(_gameId));
                for (var i = 0; i < array_length(_array); i++)
                {
                    _str = _array[i] + ":" + string(variable_instance_get(_gameId, _array[i]));
                    show_debug_message(_str);
                }
            });
        })
    ];
}