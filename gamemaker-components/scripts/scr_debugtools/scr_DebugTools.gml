function DebugTools(_instance) : Component(_instance) constructor {
	timer = 0;
}

function DebugToolsSystem(_world) : ComponentSystem(_world) constructor {
	
	function SystemStart() {
		
	}
	
	function SystemCleanup() {
		
	}
	
	function SystemStep(_dt) {
		if(mouse_check_button(1)) {
			var wallInst = world.entity.InstanceCreateLayer(obj_solid_static, mouse_x, mouse_y, "Instances");
		}
		
		if(mouse_check_button(2)) {
			var playerInst = world.entity.InstanceCreateLayer(obj_solid_dynamic, 900, 540, "Instances");
			world.entity.AddComponent(playerInst, KinematicMovement);
			world.kinematicMovement.SetDirectionAngle(playerInst, 45);
			world.kinematicMovement.SetSpeed(playerInst, 20);	
		}
	}
	
}