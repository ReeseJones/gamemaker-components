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
                matcher_value_equal(gameManager.worldExists(_world.entityId), true);
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
                it("it should mark the world's entity componet as is destroyed.", function() {
                    gameManager.destroyWorld(world.entityId);
                    matcher_is_true(world.components.entity.entityIsDestroyed);
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
                it("all worlds should have a reference to themeslves.", function() {
                    var _worldCount = 5;
                    var _worlds = [];
                    
                    for(var i = 0; i < _worldCount; i += 1) {
                        array_push(_worlds, gameManager.createWorld());    
                    }
                    
                    for(var i = 0; i < _worldCount; i += 1) {
                        var _curWorld = _worlds[i];
                        var _checkRef = _curWorld.entity.getRef(_curWorld.entityId);
                        matcher_value_equal(_curWorld, _checkRef);
                    }
                });
            });
            
            describe("cleanup - ", function() {
                before_each( function() {
                    world = gameManager.createWorld();
                    worldTwo = gameManager.createWorld();
                });
                it("it should throw if no world with that id is in the game", function() {
                    
                });
            });
        })
    ];
}

