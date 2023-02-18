tag_script(game_manager_tests, [TAG_UNIT_TEST_SPEC]);
function game_manager_tests() {
    return [
        describe("GameManager", function() {
            before_each(function() {
                inputDeviceManager = new InputDeviceManager();
                inputManager = new InputManager(inputDeviceManager);
                gameManager = new GameManager(inputDeviceManager, inputManager);
            });
            after_each(function() {
                gameManager.cleanup();
            });
            it("it should create a pool of ids to assign to worlds up to ENTITY_INITIAL_ID", function() {
                var _idPoolLength = array_length(gameManager.worldIdPool);
                matcher_value_equal(_idPoolLength, ENTITY_INITIAL_ID);
            });
            it("WorldExists should return false if a world does not exist.", function() {
                matcher_value_equal(gameManager.worldExists(3), false);
            });
            it("WorldExists should return a world ref if a world exists.", function() {
                var _world = gameManager.createWorld();
                matcher_value_equal(gameManager.worldExists(_world.id), true);
            });
            
            describe("DestroyWorld - ", function() {
                before_each( function() {
                    world = gameManager.createWorld();
                });
                it("it should throw if no world with that id is in the game", function() {
                    matcher_should_throw( function() {
                        gameManager.destroyWorld("fakeId");
                    });
                });
                it("it should mark the world's isDestroyed property as true.", function() {
                    gameManager.destroyWorld(world.id);
                    matcher_is_true(world.isDestroyed);
                });
            });
            
            describe("CreateWorld - ", function() {
                it("it should return an instance of world", function() {
                    var _world = gameManager.createWorld();
                    matcher_is_true(is_instanceof(_world, World));
                });
                it("it should throw if there are no world ids left", function() {
                    matcher_should_throw( function() {
                        for(var i = 0; i <= ENTITY_INITIAL_ID; i += 1) {
                            gameManager.createWorld();
                        }
                    });
                });
            });
            
            describe("cleanup - ", function() {
                
            });
        })
    ];
}

