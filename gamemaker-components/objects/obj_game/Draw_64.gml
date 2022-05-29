var worldCount = array_length(worlds);
for(var i = 0; i < worldCount; i += 1) {
	var world  = worlds[i];
	world.DrawGui();
}

if(worldCount > 0) {
	var world = worlds[0];
	world.DebugDraw();
}
