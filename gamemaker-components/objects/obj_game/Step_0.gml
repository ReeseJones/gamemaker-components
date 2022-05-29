var worldCount = array_length(worlds);
for(var i = 0; i < worldCount; i += 1) {
	var world  = worlds[i];
	world.Step();
}