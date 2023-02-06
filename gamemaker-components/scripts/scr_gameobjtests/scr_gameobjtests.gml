tag_script(ObjGameTests, [TAG_UNIT_TEST_SPEC]);
function ObjGameTests() {
	return [
		describe("obj_game - ", function() {
			before_each(function(){
				game = instance_create_depth(0,0,0, obj_game);
			});
			after_each(function(){
				instance_destroy(obj_game);
			});
			it("it should create a pool of ids to assign to worlds up to ENTITY_INITIAL_ID", function() {
				var idPoolLength = array_length(game.worldIdPool);
				matcher_value_equal(idPoolLength, ENTITY_INITIAL_ID);
			});
			it("WorldExists should return false if a world does not exist.", function() {
				matcher_value_equal(game.WorldExists(3), false);
			});
			it("WorldExists should return a world ref if a world exists.", function() {
				var world = game.CreateWorld();
				matcher_value_equal(game.WorldExists(world.entityId), true);
			});
			
			describe("DestroyWorld - ", function() {
				before_each(function(){
					world = game.CreateWorld();
				});
				it("it should throw if no world with that id is in the game", function(){
					matcher_should_throw(function() {
						game.DestroyWorld("fakeId");
					});
				});
				it("it should mark the world's entity componet as is destroyed.", function(){
					game.DestroyWorld(world.entityId);
					matcher_value_equal(world.components.entity.entityIsDestroyed, true);
				});
			});
			
			describe("CreateWorld - ", function() {
				it("it should return an instance of world", function() {
					var world = game.CreateWorld();
					matcher_value_equal(instanceof(world), "World");
				});
				it("it should throw if there are no world ids left", function() {
					matcher_should_throw( function() {
						for(var i = 0; i <= ENTITY_INITIAL_ID; i += 1) {
							game.CreateWorld();
						}
					});
				});
				it("all worlds should have a reference to themeslves.", function() {
					var worldCount = 5;
					var worlds = [];
					
					for(var i = 0; i < worldCount; i += 1) {
						array_push(worlds, game.CreateWorld());	
					}
					
					for(var i = 0; i < worldCount; i += 1) {
						var curWorld = worlds[i];
						var checkRef = curWorld.entity.GetRef(curWorld.entityId);
						matcher_value_equal(curWorld, checkRef);
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

