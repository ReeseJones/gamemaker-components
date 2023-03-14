tag_script(event_system_tests, [TAG_UNIT_TEST_SPEC]);
function event_system_tests() {
    return [
    describe("EventSystem", function() {
        before_each(function() {
            testKernel = event_system_get_test_kernel();
            gameManager = testKernel.get("gameManager");
            worldOne = gameManager.createWorld(1);
            eventSystem = worldOne.system.event;
            testSystem = worldOne.system.component;
        });
        after_each(function(){
            worldOne = undefined;
            gameManager.cleanup();
        })

        it("shouldnt crash loading the event system", function(){
            gameManager.updateWorlds();
            //TODO: Write the rest of the tests
        });
        
    })];
}