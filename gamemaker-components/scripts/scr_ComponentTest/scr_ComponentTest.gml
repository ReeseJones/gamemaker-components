tag_script(component_system_tests, [TAG_UNIT_TEST_SPEC]);
function component_system_tests() {
    return [
    describe("ComponentSystem", function() {
        before_each(function() {
            testKernel = event_system_get_test_kernel();
            gameManager = testKernel.get("gameManager");
            worldOne = gameManager.createWorld(1);
            logger = worldOne.logger;
            testSystem = worldOne.system.component;
        });
        after_each(function() {
            worldOne = undefined;
            gameManager.cleanup();
        });
        describe("addComponent", function() {
            it("should throw if the entity is undefined", function() {
                matcher_should_throw( function() {
                    testSystem.addComponent(undefined);
                });
            });
            it("should set the component's entityRef to the entities ref", function() {
                var _ent = worldOne.createEntity(1337);
                var _comp = testSystem.addComponent(_ent);
                
                matcher_value_equal(_comp.entityRef, _ent);
            });
            it("should call the onCreate with method of the system on the component.", function() {
                var _onCreateSpy = spy_on(testSystem, "onCreate");
                var _ent = worldOne.createEntity(1337);
                
                var _comp = testSystem.addComponent(_ent);
                
                _onCreateSpy.toBeCalledTimes(1);
            });
        });
        describe("removeComponent", function() {
            it("", function() {
                
            });
        });
    })];
}