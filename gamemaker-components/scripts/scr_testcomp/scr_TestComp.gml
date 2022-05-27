function TestComp(_instance) : Component(_instance) constructor {
	timer = 0;
}

function TestCompSystem(_world) : ComponentSystem(_world) constructor {
	
	function Create(_component) {
		show_debug_message("TestComponent Created!");
	}
	
	function Step(_component, _dt) {
		_component.timer += 1;
		
		if(_component.timer % 60 == 0) {
			show_debug_message("tick!!!");
		}
		
		if(_component.timer > 180) {
			//entity.EntityDestroy(_component.GetEntityId());
		}
		
		var rectSize = _component.instance.components.rectangleSizing;
		
		if(rectSize) {
			rectSize.width = display_get_gui_width()  * abs(cos(_component.timer / 10));
			rectSize.height = display_get_gui_height()  * abs(sin((_component.timer + 1.5) / 10));
		}
	}
	
	function Destroy(_component) {
		show_debug_message("TestComponent Destroyed!");
	}
	
	function Cleanup(_component) {
		show_debug_message("TestComponent Cleaned up!");
	}
	
}