tag_script(disposable_tests, [TAG_UNIT_TEST_SPEC]);
function disposable_tests() {
    return [
        describe("disposable manager", function() {
            it("should have isDisposed value.", function() {
                var _disposableManager = new DisposableManager();
                
                matcher_struct_property_exists(_disposableManager, "isDisposed");
            });
            it("should have isDisposed and it should be false initially.", function() {
                var _disposableManager = new DisposableManager();
                
                matcher_value_equal(_disposableManager.isDisposed, false);
            });
            it("should be disposed after calling disposeFunc.", function() {
                var _disposableManager = new DisposableManager();
                
                _disposableManager.disposeFunc();
                
                matcher_value_equal(_disposableManager.isDisposed, true);
            });
        })
    ];
}