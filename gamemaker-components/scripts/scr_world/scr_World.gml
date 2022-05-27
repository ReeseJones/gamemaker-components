function SystemEventSubscribers() constructor {	
		beginStep = [];
		step = [];
		endStep = [];
		drawBegin = [];
		draw = [];
		drawEnd = [];
		drawGUIBegin = [];
		drawGUI = [];
		drawGUIEnd = [];
		eventList = [beginStep, step, endStep, drawBegin, draw, drawEnd, drawGUIBegin, drawGUI, drawGUIEnd];
}

function World(_id, _worldSystems) constructor {
	entityId = _id;
	
	worldSequence = 0;
	ticksPerSecond = 10;
	secondsSinceLastTick = 0;
	tickProgress = 0;
	tickDt = 1 / ticksPerSecond;
	
	//These systems add behavior to the world.
	entitySystems = [];
	systemEventSubscribers = new SystemEventSubscribers();
	
	InitializeWorldSystems(_worldSystems);
	
	function SetTickRate(_fps) {
		ticksPerSecond = round(clamp(_fps, 0, 120));
	
		if(ticksPerSecond > 0) {
			tickDt = 1 / ticksPerSecond;
		}
	}
	
	function Step() {
		if(ticksPerSecond < 0) {
			return;	
		}

		var secondsPerTick = (1 / ticksPerSecond);
		var secondsSinceLastStep = delta_time / MICROSECONDS_PER_SECOND;
		secondsSinceLastTick += secondsSinceLastStep;
		tickProgress = secondsSinceLastTick / secondsPerTick;
		
		if( secondsSinceLastTick >= secondsPerTick ) {
			tickProgress = 0;
			secondsSinceLastTick -= secondsPerTick;
			
			var systemCount = array_length(entitySystems);
			for(var i = 0; i < systemCount; i += 1) {
				var system = entitySystems[i];
				if(system.enabled && is_method(system.SystemStep)) {
					system.SystemStep(tickDt);
				}
			}
			
			//TODO ADD BACK COMPONENTS UPDATES
			
			worldSequence += 1;
		}
	}
	
	function DebugDraw() {
		/// @description Debug Draw
		var debugText = [
		"FPS: " + string(fps),
		"Real FPS: " + string(fps_real),
		"World Sequence: " + string(worldSequence),
		"Target Ticks Per Second: " + string(ticksPerSecond),
		"Seconds Per Tick: " + string(tickDt),
		"Last tick: " + string(secondsSinceLastTick),
		"Tick Progress: " + string(tickProgress),
		"Instance Count: " + string(instance_count)
		];
		debugText = array_join(debugText, "\n");
		draw_text(32, 32, debugText);		
	}
	
	function InitializeWorldSystems(_worldSystems) {
		//Auto added world systems
		array_push(_worldSystems, 
			[Entity, EntitySystem, []],
			[Eventer, EventerSystem, [EntityTree]],
			[EntityTree, EntityTreeSystem, []]
		);
	
		var selfRef = self;
		var systemDependencyQueue = ds_queue_create();
		
		var systemsCount = array_length(_worldSystems);
		for(var i = 0; i < systemsCount; i += 1) {
			var systemRegistration = _worldSystems[i];
			
			var componentConstructor = systemRegistration[0];
			var systemConstructor = systemRegistration[1];
			var componentDependencies = systemRegistration[2];
			
			//auto add these system dependencies to all systems added to the world.
			array_push(componentDependencies, Entity, Eventer, EntityTree);
		
			var componentName = string_lowercase_first(script_get_name(componentConstructor));
			if( variable_struct_exists(selfRef, componentName) ) {
				var msg = String("System with name ", componentName, " could not be registered because this variable name is already in use on the world.");
				throw(msg);
			}
			
			var newSystem = new systemConstructor(selfRef);
			selfRef[$ componentName] = newSystem;
			array_push(entitySystems, newSystem);

			//Queue this system to have its dependencies wired so they can reference each other.
			ds_queue_enqueue(systemDependencyQueue, {
				system: newSystem,
				dependencies: array_map(componentDependencies, function(_dep) {
					return string_lowercase_first(script_get_name(_dep));
				})
			});
		}

		//Iterate through all the systems to wire up their depedencies.
		while( !ds_queue_empty(systemDependencyQueue) ) {
			var sysMetadata = ds_queue_dequeue(systemDependencyQueue);
			var numOfDeps = array_length(sysMetadata.dependencies);
			for(var j = 0; j < numOfDeps; j += 1) {
				var depName = sysMetadata.dependencies[@ j];
				if(variable_struct_exists(selfRef, depName)) {
					sysMetadata.system[$ depName] = selfRef[$ depName];
				} else {
					throw(String("System " , sysMetadata.system.name ," could not find dep with name ", depName));	
				}
			}
		}
	
		ds_queue_destroy(systemDependencyQueue);
		systemDependencyQueue = -1;
	
		//Manually-dynamically add an eventer component to the world for event management.
		entity.AddComponent(_id, Eventer);
	
		//All dependencies are wired and we call the start code on the systems.
		var systemCount = array_length(entitySystems);
		for(var i = 0; i < systemCount; i += 1) {
			var sys = entitySystems[i];
			if(is_method(sys.SystemStart)) {
				sys.SystemStart();	
			}
		}

	}
	
	function RegisterSystemEvents(_newSystem) {
		
	}
	
}