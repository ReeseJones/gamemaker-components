tag_script(world_tests, [TAG_UNIT_TEST_SPEC]);
function world_tests() {
    return [
        describe("Worlds - ", function() {
            before_each(function() {
                game = instance_create_depth(0, 0, 0, obj_game);
            });
            after_each(function() {
                instance_destroy(game);
            });
            describe("Creation: ", function() {
                before_each(function() {
                    world = game.createWorld();
                });
                after_each(function() {
                    game.destroyWorld(world.entityId);
                });
                it("Should be able to create a game and load an empty world without crashing.", function() {
                    matcher_is_defined(world);
                });
                it("should have a reference to itself using getRef and the world ID.", function() {
                    var _selfWorld = world.entity.getRef(world.entityId);
                    matcher_value_equal(world, _selfWorld);
                });
            });
        })
    ];
}

