tag_script(spec_creation_tests, [TAG_UNIT_TEST_SPEC]);
function spec_creation_tests() {
    return [
        describe("A spec", function() {
            before_each(function() {
                self.foo = 0;
            });
            it(" can use the `this` to share state", function() {
                matcher_value_equal(self.foo, 0);
                self.bar = "test pollution?";
            });

            it(" prevents test pollution by having an empty `this` created for the next spec", function() {
                matcher_value_equal(self.foo, 0);
                matcher_struct_property_exists(self, "bar", true);
            });
        })
    ];
}