tag_script(test_uuid_generator_tests, [TAG_UNIT_TEST_SPEC]);
function test_uuid_generator_tests() {
    return [
        describe("uuid generator", function() {
            it("should be able generate good lookin uuid", function() {
                var _uuid = uuid_generate();
                matcher_is_true(is_string(_uuid));
                matcher_is_true(string_length(_uuid) == 36);
            });
        })
    ];
}