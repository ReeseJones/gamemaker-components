tag_script(variable_foreach_test, [TAG_UNIT_TEST_SPEC]);
function variable_foreach_test() {
    return [
        describe("variable_foreach", function() {
            it("iterates through all properties of struct", function() {
                var _a = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};
                iteratedValues = [];

                variable_foreach(_a, function(_value, _key, _struct) {
                    static testCount = 0;
                    array_push(iteratedValues, _value);
                    show_debug_message($"{testCount++}: {_value}");
                });
            });
        })
    ];
}