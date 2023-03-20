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
            it("should call the onCreate method of the system on the component.", function() {
                var _onCreateSpy = spy_on(testSystem, "onCreate");
                var _ent = worldOne.createEntity(1337);
                
                var _comp = testSystem.addComponent(_ent);
                
                _onCreateSpy.toBeCalledTimes(1);
            });
        });
        describe("removeComponent", function() {
            it("can be called on entities that dont actually have the component.", function() {
                var _ent = worldOne.createEntity(1337);
                var _comp = testSystem.removeComponent(_ent);
            });
            it("will call the components destroy code.", function() {
                var _onDestroySpy = spy_on(testSystem, "destroy");
                var _ent = worldOne.createEntity(1337);
                
                var _comp = testSystem.addComponent(_ent);
                testSystem.removeComponent(_ent);
                
                _onDestroySpy.toBeCalledTimes(1);
            });
            it("should disable the component, set its visibility to false and mark it destroyed", function() {
                var _ent = worldOne.createEntity(1337);
                var _comp = testSystem.addComponent(_ent);
                testSystem.removeComponent(_ent);
                
                matcher_is_false(_comp.enabled);
                matcher_is_false(_comp.visible);
                matcher_is_true(_comp.componentIsDestroyed);
                matcher_is_true(testSystem.componentsDirty);
            });
            it("should not mark components dirty if no component is removed", function() {
                var _ent = worldOne.createEntity(1337);
                testSystem.removeComponent(_ent);
                
                matcher_is_false(testSystem.componentsDirty);
            });
        });
    })];
}