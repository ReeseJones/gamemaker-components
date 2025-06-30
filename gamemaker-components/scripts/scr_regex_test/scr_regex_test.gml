//tag_asset(regex_tests, [TAG_UNIT_TEST_SPEC]);
function regex_tests() {
    return [
        describe("regex", function() {
            it("regex /abc/ should match string 'abc'", function() {
                var _regexPattern = new Regex("abc");
                
                matcher_struct_property_exists(_disposableManager, "isDisposed");
            });
        })
    ];
}