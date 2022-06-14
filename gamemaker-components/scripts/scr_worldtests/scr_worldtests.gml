TagScript(WorldTests, [tag_unit_test_spec]);
function WorldTests() {
	return [
		Describe("Worlds - ", function() {
			BeforeEach(function() {
				game = instance_create_depth(0, 0, 0, obj_game);
			});
			AfterEach(function() {
				instance_destroy(game);
			});
			Describe("Creation: ", function() {
				BeforeEach(function() {
					world = game.CreateWorld();
				});
				AfterEach(function() {
					//Do destroy world.
					game.DestroyWorld(world.entityId);

				});
				It("Should be able to create a game and load an empty world without crashing.", function() {

				});
				It("should have obj_game registered as an entity. And the world itself.", function() {
					var gameObj = world.entity.GetRef(EntityId.Game);
					var selfWorld = world.entity.GetRef(world.entityId);
					
					MatcherValueEqual(gameObj, game);
					MatcherValueEqual(world, selfWorld);
				});
			});
		})
	];
}

