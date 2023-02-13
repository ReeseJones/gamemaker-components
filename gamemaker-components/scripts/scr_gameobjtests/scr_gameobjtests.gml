tag_script(obj_game_tests, [TAG_UNIT_TEST_SPEC]);
function obj_game_tests() {
    return [
        describe("obj_game - ", function() {
            before_each(function() {
                gameInstance = instance_create_depth(0,0,0, obj_game);
            });
            after_each(function(){
                instance_destroy(obj_game);
            });
            it("it should create a pool of ids to assign to worlds up to ENTITY_INITIAL_ID", function() {
                var _idPoolLength = array_length(gameInstance.worldIdPool);
                matcher_value_equal(_idPoolLength, ENTITY_INITIAL_ID);
            });
            it("WorldExists should return false if a world does not exist.", function() {
                matcher_value_equal(gameInstance.worldExists(3), false);
            });
            it("WorldExists should return a world ref if a world exists.", function() {
                var _world = gameInstance.createWorld();
                matcher_value_equal(gameInstance.worldExists(_world.entityId), true);
            });
            
            describe("DestroyWorld - ", function() {
                before_each( function() {
                    world = gameInstance.createWorld();
                });
                it("it should throw if no world with that id is in the game", function() {
                    matcher_should_throw( function() {
                        gameInstance.destroyWorld("fakeId");
                    });
                });
                it("it should mark the world's entity componet as is destroyed.", function() {
                    gameInstance.destroyWorld(world.entityId);
                    matcher_is_true(world.components.entity.entityIsDestroyed);
                });
            });
            
            describe("CreateWorld - ", function() {
                it("it should return an instance of world", function() {
                    var _world = gameInstance.createWorld();
                    matcher_is_true(is_instanceof(_world, World));
                });
                it("it should throw if there are no world ids left", function() {
                    matcher_should_throw( function() {
                        for(var i = 0; i <= ENTITY_INITIAL_ID; i += 1) {
                            gameInstance.createWorld();
                        }
                    });
                });
                it("all worlds should have a reference to themeslves.", function() {
                    var _worldCount = 5;
                    var _worlds = [];
                    
                    for(var i = 0; i < _worldCount; i += 1) {
                        array_push(_worlds, gameInstance.createWorld());    
                    }
                    
                    for(var i = 0; i < _worldCount; i += 1) {
                        var _curWorld = _worlds[i];
                        var _checkRef = _curWorld.entity.getRef(_curWorld.entityId);
                        matcher_value_equal(_curWorld, _checkRef);
                    }
                });
            });
            
            describe("UpdateWorlds - ", function() {
                before_each(function() {
                    
                });
                it("it should dispatch any events queued on the game first, then update the worlds", function() {
                    
                });
            });
        })
    ];
}

