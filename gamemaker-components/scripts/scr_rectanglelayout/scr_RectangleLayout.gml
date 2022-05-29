function RectangleLayout(_instance) : Component(_instance) constructor {
	top = 0;
	left = 0;
	bottom = 0;
	right = 0;
}

function RectangleLayoutSystem(_world) : ComponentSystem(_world) constructor {
	
	function EndStep(_rectLayout, _dt) {
		var inst = _rectLayout.instance;
		var rectSizing = inst.components.rectangleSizing;
		var entityTree = inst.components.entityTree;
		if(!entityTree || !rectSizing) {
			return;	
		}
		if(!entityTree.parent) {
			return;	
		}
		var parent = entity.GetRef(entityTree.parent);
		if(!parent) {
			return;	
		}
		parentRect = parent.components.rectangleSizing;
		if(!parentRect) {
			return;	
		}
		
		var top = parentRect.y + (_rectLayout.top * parentRect.height);
		var left = parentRect.x + (_rectLayout.left * parentRect.width);
		var bottom = parentRect.y + parentRect.height - (_rectLayout.bottom * parentRect.height);
		var right = parentRect.x + parentRect.width - (_rectLayout.right * parentRect.width);
		
		rectSizing.x = left;
		rectSizing.y = top;
		rectSizing.width = right - left;
		rectSizing.height = bottom - top;
	}
	
}
