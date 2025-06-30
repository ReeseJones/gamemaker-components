function test_asset_tagging_script_test() {
    return "debug text";
}

tag_asset(tag_names_tests, [TAG_UNIT_TEST_SPEC]);
function tag_names_tests() {
    return [
        describe("tag_asset", function() {
            after_each(function(){
                asset_clear_tags("test_asset_tagging_script_test");
            });
            it("should tag script functions by reference", function() {
                tag_asset(test_asset_tagging_script_test, ["special_test"]);
                
                var _tags = asset_get_tags(test_asset_tagging_script_test);
                matcher_array_contains(_tags, "special_test");
                matcher_array_contains(_tags, "script");
            });
            it("should tag script functions by name", function() {
                tag_asset("test_asset_tagging_script_test", ["special_test_2"]);

                var _tags = asset_get_tags("test_asset_tagging_script_test");
                matcher_array_contains(_tags, "special_test_2");
                matcher_array_contains(_tags, "script");
            });
            it("debug log all script names", function() {
                get_all_scripts();
            });
        })
    ];
}