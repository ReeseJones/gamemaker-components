TagScript(ObjGameTests, [tag_unit_test_spec]);
function ObjGameTests() {
	return [
		Describe("obj_game - ", function() {
			BeforeEach(function(){
				game = instance_create_depth(0,0,0, obj_game);
			});
			AfterEach(function(){
				instance_destroy(obj_game);
			});
			It("It should create a pool of ids to assign to worlds up to ENTITY_INITIAL_ID", function() {
				var idPoolLength = array_length(game.worldIdPool);
				MatcherValueEqual(idPoolLength, ENTITY_INITIAL_ID);
			});
			It("WorldExists should return false if a world does not exist.", function() {
				MatcherValueEqual(game.WorldExists(3), false);
			});
			It("WorldExists should return a world ref if a world exists.", function() {
				var world = game.CreateWorld();
				MatcherValueEqual(game.WorldExists(world.entityId), true);
			});
			
			Describe("DestroyWorld - ", function() {
				BeforeEach(function(){
					world = game.CreateWorld();
				});
				It("it should throw if no world with that id is in the game", function(){
					MatcherShouldThrow(function() {
						game.DestroyWorld("fakeId");
					});
				});
				It("it should mark the world's entity componet as is destroyed.", function(){
					game.DestroyWorld(world.entityId);
					MatcherValueEqual(world.components.entity.entityIsDestroyed, true);
				});
			});
			
			Describe("CreateWorld - ", function() {
				It("it should return an instance of world", function() {
					var world = game.CreateWorld();
					MatcherValueEqual(instanceof(world), "World");
				});
				It("it should throw if there are no world ids left", function() {
					MatcherShouldThrow( function() {
						for(var i = 0; i <= ENTITY_INITIAL_ID; i += 1) {
							game.CreateWorld();
						}
					});
				});
				It("all worlds should have a reference to themeslves.", function() {
					var worldCount = 5;
					var worlds = [];
					
					for(var i = 0; i < worldCount; i += 1) {
						array_push(worlds, game.CreateWorld());	
					}
					
					for(var i = 0; i < worldCount; i += 1) {
						var curWorld = worlds[i];
						var checkRef = curWorld.entity.GetRef(curWorld.entityId);
						MatcherValueEqual(curWorld, checkRef);
					}
				});
			});
			
			Describe("UpdateWorlds - ", function() {
				BeforeEach(function() {
					
				});
				It("it should dispatch any events queued on the game first, then update the worlds", function() {
					
				});
			});
		})
	];
}

