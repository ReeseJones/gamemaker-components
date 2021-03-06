enum EntityId {
	Game = -42,
	World0 = 0,
	World1 = 1,
	World2 = 2,
	//Everything below starting entityId could be a world id (except for 0 reserved for game)
}

function EventSubscription(_entityId, _funcName, _componentName) constructor {
	entityId = _entityId;
	funcName =_funcName;
	componentName = _componentName;
};

function EventData(_world, _eventEmitterId, _eventType, _data) constructor {
	world = _world
	eventEmitterId = _eventEmitterId;
	entityRef = undefined;
	eventType = _eventType;
	data = _data;
};

function Eventer(_instance) : Component(_instance) constructor {
	eventMap = {};
	eventQueue = ds_queue_create();
	eventQueueBuffer = ds_queue_create();
	debug = false;
}

function EventerSystem(_world) : ComponentSystem(_world) constructor {
	
	function SubscribeToEvent(_targetEntityId, _eventType, _subscriberEntityId, _funcName, _componentName) {
		var targetEntity = entity.GetRef(_targetEntityId);
		var targetEventer = targetEntity.components.eventer;
		var eventSubscribers = targetEventer.eventMap[$ _eventType];
		if(!is_array(eventSubscribers)) {
			eventSubscribers = [];
			eventMap[$ _eventType] = eventSubscribers;
		}
		
		var eventSubscription = new EventSubscription(_subscriberEntityId, _funcName, _componentName);
		array_push(eventSubscribers, eventSubscription);
	}
	
	function UnSubscribeFromEvent(_targetEntityId, _eventType, _entityId) {
		//TODO entity.GetRef has special case for world and game events
		var targetEntity = entity.GetRef(_targetEntityId);
		//TODO which means that targetEntity could be a struct or game obj. but it has to have its eventer under components.
		var targetEventer = targetEntity.components.eventer;

		var eventSubscribers = targetEventer.eventMap[$ _eventType];
		if(!is_array(eventSubscribers)) {
			throw String("Entity with id ",  _targetEntityId, " has no subscribers to event ", _eventType, ". Failed to unsusbscribe.");
		}
		
		var listLength = array_length(eventSubscribers);
		var i = listLength - 1;
		var swapIndex = i;
		while(i > -1) {
			var eventSubscriber = eventSubscribers[i];
			if(eventSubscriber.entityId == _entityId) {
				delete eventSubscriber;
				eventSubscribers[i] = eventSubscribers[swapIndex];
				swapIndex -= 1;
				listLength -=1;
			}
			i -= 1;
		}
	
		array_resize(eventSubscribers, listLength);
	}
	
	function QueueEvent(_entityId, _eventType, _eventData) {
		var inst = entity.GetRef(_entityId);
		if(!inst) {
			show_debug_message(String("Could not find entity ", _entityId, "'s instance."));
			return;
		}
		var eventData = new EventData(world, _entityId, _eventType, _eventData);
		ds_queue_enqueue(inst.components.eventer.eventQueueBuffer, eventData);
	}
	
	//Requires Entity Tree
	function QueueEventDown(_entityId, _eventType, _eventData) {
		var inst = entity.GetRef(_entityId);
		if(!inst) {
			show_debug_message(String("Could not find entity ", _entityId, "'s instance."));
			return;	
		}
		var newEvent = new EventData(world, _entityId, _eventType, _eventData);
		
		entityTree.ForeachEntityDown(_entityId, function(_inst) {
			var currentEventer = _inst.components.eventer;
			if(currentEventer) {
				ds_queue_enqueue(currentEventer.eventQueueBuffer, event);
			}
		}, false, {
			event: newEvent,
		});
	}
	
	//Requires Entity Tree
	function QueueEventUp(_entityId, _eventType, _eventData) {
		var inst = entity.GetRef(_entityId);
		if(!inst) {
			show_debug_message(String("Could not find entity ", _entityId, "'s instance."));
			return;	
		}
		var newEvent = new EventData(world, _entityId, _eventType, _eventData);
		
		entityTree.ForeachEntityUp(_entityId, function(_inst) {
			var currentEventer = _inst.components.eventer;
			if(currentEventer) {
				ds_queue_enqueue(currentEventer.eventQueueBuffer, event);
			}
		}, false, {
			event: newEvent,
		});
	}
	
	RegisterSystemEvent(ES_END_STEP);
	function EndStep(_eventer, _dt) {
		//Swap the buffer into the main queue and process all events
		var queueSwap = _eventer.eventQueue;
		_eventer.eventQueue = _eventer.eventQueueBuffer;
		_eventer.eventQueueBuffer = queueSwap;
		
		var eventQueue = _eventer.eventQueue;
		var eventMap = _eventer.eventMap;

		while( !ds_queue_empty(eventQueue) ) {
			var event = ds_queue_dequeue(eventQueue);
			var subscribers = eventMap[$ event.eventType];
			event.entityRef = entity.GetRef(event.eventEmitterId);

			if(is_array(subscribers)) {	
				var subscriberCount = array_length(subscribers);
				for(var i = subscriberCount - 1; i > -1; i -= 1) {
					var subscriptionData = subscribers[i];
					
					//Clean up subscriptions to things which no longer point to entities
					var inst = entity.GetRef(subscriptionData.entityId);
					if(!inst) {
						array_delete_fast(subscribers, i);
						delete subscriptionData;
						continue;
					}
					
					var func;
					if(subscriptionData.componentName) {
						func = world[$ subscriptionData.componentName][$ subscriptionData.funcName];
					} else {
						func = variable_instance_get(inst, subscriptionData.funcName);
					}
					func(event);
				}
			}
			if(debug) {
				show_debug_message(String("Entity: ", _eventer.GetEntityId(), " Event: ", EventName(event.eventType)));
			}
		}
		
	}
	
	function Cleanup(_eventer) {
		delete _eventer.eventMap;
		_eventer.eventMap = undefined;
		ds_queue_destroy(_eventer.eventQueue);
		_eventer.eventQueue = undefined;
		ds_queue_destroy(_eventer.eventQueueBuffer);
		_eventer.eventQueueBuffer = undefined;
	}
}
