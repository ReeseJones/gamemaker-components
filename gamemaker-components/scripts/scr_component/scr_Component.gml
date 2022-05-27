function Component(_ref) constructor {
	name = string_lowercase_first(instanceof(self));
	entityRef = _ref;
	//Run Update on this component
	enabled = true;
	//Run Draw on this component
	visible = true;
	componentIsDestroyed = false;
	
	static GetEntityId = function() {
		return entityRef.components.entity.id;
	}
}

function ComponentSystem(_world) constructor {
	name = string_lowercase_first(instanceof(self));
	//Run update of this entire system
	enabled = true;
	//Run draw of this entire system
	visible = true;
	//What world this system belongs too
	world = _world
	
	componentList = [];
	componentsDirty = false;
	
	function SystemStart() {
		//Called after all systems are registered to the world.
	}
	
	function SystemCleanup() {
		//Called when the world is destroyed.
	}
	
	function SystemStep() {
		//Called once per each step of updating the world.
		//Note this happens only when the world state progresses.
		//This happens at most only the specified ticksPerSecond
		//If the ticksPerSecond exceeds the FPS the game is running at
		//then the updates will effectivley only run at the fps
		//TODO: dt should be fixed for step, double check that it is.
	}
	
	
	function Create(_component) {
		//Runs after all values have been deserialized
		//Or after a component has been dynamically added.
	}
	
	//The step functions happen once per world simulation update.
	//The dt these are passed is a fixed time based on the intended
	//number of frames per second the world simulates at.
	
	function BeginStep(_component, _dt) {
		//Runs in the world step phase. Before step and endStep
	}
	
	function Step(_component, _dt) {
		//Runs in the world step phase. After BeginStep and before endStep
	}
	
	function EndStep(_component, _dt) {
		//Runs in the world step phase. After BeginStep and Step
	}
	
	//All draw Methods happen at the the maximum FPS the game can run.
	//Drawing happens seperate from the world updates.
	//the delta time passed to the draw functions is a percentage of
	//the elapsed current world step. A number from 0 - 1
	
	function DrawBegin(_component, _dt) {
		
	}
	
	function Draw(_component, _dt) {
	
	}
	
	function DrawEnd(_component, _dt) {
	
	}
	
	function DrawGuiBegin(_component, _dt) {
	
	}
	
	function DrawGui(_component, _dt) {
	
	}
	
	function DrawGuiEnd(_component, _dt) {
	
	}
	
	function Destroy(_component) {
		// When RemoveComponent is called the destroy code runs immdiately.
		// When an entity is destroyed and its components are removed this code also runs.
		
		//The component/entity is immidately marked as destroyed, but will not be cleaned up until
		//The end of the step phase immdiately following the cleanup event.
		
		// NOTE: The simulation continues to run after this, so it may be wise to leave
		// some resources/assets/references alive until cleanup.
	}
	
	function Cleanup(_component) {
		// Similar to Destroy except this code runs after all the step events when the entities
		// and components are removed from the world and systems. Should be used to clean up
		// resources that the component allocated that are not automatically cleaned up.
	}
	
	//TODO: Figure out how world/system/entity/component serilization will work.
	
	function SerializeBinary(_component, _buffer) {
		
	}
	
	function SerializeJson(_component, _buffer) {
		
	}
	
	function DeserializeBinary(_component, _buffer) {
		
	}
	
	function DeserializeJson(_component, _buffer) {
		
	}
	
	function CleanComponentList() {
		if(componentsDirty) {
			componentsDirty = false;
			var listLength = array_length(componentList);
			var i = listLength - 1;
			var swapIndex = i;
			while(i > -1) {
				if(componentList[i].componentIsDestroyed) {
					componentList[i] = componentList[swapIndex];
					swapIndex -= 1;
					listLength -=1;
				}
				i -= 1;
			}
			array_resize(componentList, listLength);
		}
	}
	
	static RegisterSystemEvent = function RegisterSystemEvent(_method) {
		
	}
}