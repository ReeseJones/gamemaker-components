function UiRoot(_instance) : Component(_instance) constructor {
	focusedElement = undefined;
	cameraId = 0;
}

function UiRootSystem() : ComponentSystem() constructor {
	
	function BeginStep(_uiRoot, _dt) {
		var rectSize = _uiRoot.instance.components.rectangleSizing;
		rectSize.x = 0;
		rectSize.y = 0;
		rectSize.width = display_get_gui_width();
		rectSize.height = display_get_gui_height();
	}
	
	function DrawGui(_component, _dt) {
		if(_component.debug) {
			draw_set_color(_component.debugCol);
			draw_rectangle(_component.x, _component.y, _component.x + _component.width, _component.y + _component.height, true);
		}
	}
}
