
tag_script(game_manager_tests, [TAG_UNIT_TEST_SPEC]);
function game_manager_tests() {
    return [
        describe("GameManager", function() {
            before_each(function() {
                testTimeProvider = { getDeltaSeconds: function() { return 0.1;} };
                testTimeManager = new WorldTimeManager(testTimeProvider);
                testWorldFactory = {
                    testTimeManager: testTimeManager,
                    create: function() {
                    return new World(testTimeManager, []);
                }};
                gameManager = new GameManager(testWorldFactory);
            });
            after_each(function() {
                gameManager.cleanup();
                gameManager = undefined;
            });
            it("WorldExists should return false if a world does not exist.", function() {
                matcher_value_equal(gameManager.worldExists(3), false);
            });
            it("WorldExists should return true if a world exists.", function() {
                var _world = gameManager.createWorld("d");
                matcher_value_equal(gameManager.worldExists(_world.id), true);
            });
            
            describe("DestroyWorld - ", function() {
                before_each( function() {
                    world = gameManager.createWorld(0);
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
                    var _world = gameManager.createWorld("newWorld");
                    matcher_is_true(is_instanceof(_world, World));
                });
                it("it should throw if a world with that ID already exists", function() {
                    matcher_should_throw( function() {
                        var _world = gameManager.createWorld("newWorld");
                        var _world2 = gameManager.createWorld("newWorld");
                    });
                });
            });
            
            describe("getWorldRef - ", function() {
                 it("it should return a reference to a world if it exists", function() {
                    var _world = gameManager.createWorld("one");
                    matcher_value_equal(gameManager.getWorldRef(_world.id), _world);
                });
                it("it should return undefined if the world does not exist", function() {
                    var _world = gameManager.createWorld(3);
                    var _notAWorld = "notAWorld";
                    matcher_value_equal(gameManager.getWorldRef(_notAWorld), undefined);
                });
            });
            
             describe(" destroy world - ", function() {
                it("world is not removed on destruction", function() {
                    var _world = gameManager.createWorld(-3);
                    gameManager.destroyWorld(_world.id);
                    var _worldRef = gameManager.getWorldRef(_world.id);
                    matcher_value_equal(_worldRef, _world);
                });
                it("it should remove the world after an update loop", function() {
                    var _world = gameManager.createWorld(-99999);
                    var _worldId = _world.id;
                    gameManager.destroyWorld(_worldId);
                    var _worldRef = gameManager.getWorldRef(_worldId);
                    matcher_value_equal(_worldRef, _world);
                    
                    gameManager.updateWorlds();
                    _worldRef = gameManager.getWorldRef(_worldId);
                    matcher_value_equal(_worldRef, undefined);
                });
            });
        })
    ];
}

