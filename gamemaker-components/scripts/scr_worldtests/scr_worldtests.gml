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
					game.DestroyWorld(world.entityId);
				});
				It("Should be able to create a game and load an empty world without crashing.", function() {
					MatcherIsDefined(world);
				});
				It("should have a reference to itself using GetRef and the world ID.", function() {
					var selfWorld = world.entity.GetRef(world.entityId);
					MatcherValueEqual(world, selfWorld);
				});
			});
		})
	];
}

