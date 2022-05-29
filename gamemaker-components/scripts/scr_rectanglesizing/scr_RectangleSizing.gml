function RectangleSizing(_instance) : Component(_instance) constructor {
	x = 0;
	y = 0;
	width = 64;
	height = 64;
	debug = true;
	debugCol = make_color_rgb(random(255), random(255), random(255));
}

function RectangleSizingSystem(_world) : ComponentSystem(_world) constructor {
	function DrawGui(_component, _dt) {
		if(_component.debug) {
			draw_set_color(_component.debugCol);
			draw_rectangle(_component.x, _component.y, _component.x + _component.width, _component.y + _component.height, true);
		}
	}
}
