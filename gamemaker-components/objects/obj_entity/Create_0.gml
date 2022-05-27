/// @description Set entity values
world = undefined;
components = { entity: { entityIsDestroyed: false}};

function RunComponentStepMethod(_methodName) {
	if(!world) {
		return;	
	}
	var tick = world.tickDt;
	var componentList = components.entity.components;
	var componentCount = array_length(componentList);
	for(var i = 0; i < componentCount; i += 1) {
		var component = componentList[i];
		var func = world[$ component.name][$ _methodName];
		if(component.enabled && func) {
			func(component, tick);
		}
	}
}

function RunComponentDrawMethod(_methodName) {
	if(!world) {
		return;	
	}
	var tick = world.tickProgress;
	var componentList = components.entity.components;
	var componentCount = array_length(componentList);
	for(var i = 0; i < componentCount; i += 1) {
		var component = componentList[i];
		var func = world[$ component.name][$ _methodName];
		if(component.visible && func) {
			func(component, tick);
		}
	}
}