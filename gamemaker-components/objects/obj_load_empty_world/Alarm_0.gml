random_set_seed(date_current_datetime());
var world = obj_game.LoadEmptyWorld();
var instanceLayerName = "Instances";
/*
	var newEntity = world.entity.CreateEntityDefault(200, 200, instanceLayerName);
	world.entity.addComponent(newEntity, TestComp);
	world.entity.addComponent(newEntity, EntityTree);
	world.entity.addComponent(newEntity, RectangleSizing);
	world.entity.addComponent(newEntity, RectangleLayout);

	var newEntityTwo = world.entity.CreateEntityDefault(200, 200, instanceLayerName);
	var entTreeComp =  world.entity.addComponent(newEntityTwo, EntityTree);
					   world.entity.addComponent(newEntityTwo, RectangleSizing);
	var rectLayout =   world.entity.addComponent(newEntityTwo, RectangleLayout);

	world.entityTree.SetParent(entTreeComp, newEntity);
	rectLayout.left = 0.2;
	rectLayout.right = 0.2;
	rectLayout.top = 0.2;
*/
/*
for (var i = 0; i < 20; i +=1 ) {
	var xxx = random(1920);
	var yyy = random(1080);
	var wall;

	if(random(1) > 0.5) {
		wall = world.entity.InstanceCreateLayer(obj_wall_rectangle, xxx, yyy, instanceLayerName);
	} else {
		wall = world.entity.InstanceCreateLayer(obj_wall_circle, xxx, yyy, instanceLayerName);
	}
	

	var wd, hg;
	wd = 32 + random(120);
	hg = 32 + random(120);
	world.entity.SetSize(wall, wd, hg);
	world.entity.SetImageAngle(wall, random(360));
	world.entity.SetImageScale(wall, wd / MASK_RESOLUTION, hg / MASK_RESOLUTION);
}
*/


/*
var playerInst = world.entity.InstanceCreateLayer(obj_solid_dynamic, 900, 540, instanceLayerName);
world.entity.addComponent(playerInst, KinematicMovement);
world.kinematicMovement.SetDirectionAngle(playerInst, 45);
world.kinematicMovement.SetSpeed(playerInst, 20);
*/
var newInst = {};

world.entity.registerEntity(newInst);