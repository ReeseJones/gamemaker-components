enum EntityId {
	Game = -42,
	World0 = 0,
	//Everything below starting entityId could be a world id (except for id reserved for game)
}


/// @desc EventData holds the the information of an emitted event type which has helper references, event info and data
/// @param {Real} _world the id of listener who is wiating for a specific event type.
/// @param {String} _funcName The name of the function to call when the event type is emitted
/// @param {String} _componentName The name of the component which holds the function to call.
function EventData(_world, _eventEmitterId, _eventType, _data) constructor {
	world = _world
	eventEmitterId = _eventEmitterId;
	entityRef = undefined;
	eventType = _eventType;
	data = _data;
};


function EventSystem(_world) : ComponentSystem(_world) constructor {
	
	eventSequenceQueue = ds_priority_create();
	//TODO: Create subsriber map data structure
	/*
		map of emitter Id to eventType subscribers
	*/
	subscriberMap = {};
	
	function SubscribeToEvent(_targetEntityId, _eventType, _subscriberEntityId, _funcName, _componentName) {
		var _targetEntity = entity.GetRef(_targetEntityId);
		var _targetEventer = _targetEntity.components.eventer;
		var _eventSubscribers = _targetEventer.eventMap[$ _eventType];
		if(!is_array(_eventSubscribers)) {
			_eventSubscribers = [];
			eventMap[$ _eventType] = _eventSubscribers;
		}
		
		var eventSubscription = new EventSubscription(_subscriberEntityId, _funcName, _componentName);
		array_push(_eventSubscribers, eventSubscription);
	}
	
	function UnSubscribeFromEvent(_targetEntityId, _eventType, _entityId) {
		//TODO entity.GetRef has special case for world and game events
		var _targetEntity = entity.GetRef(_targetEntityId);
		//TODO which means that _targetEntity could be a struct or game obj. but it has to have its eventer under components.
		var _targetEventer = _targetEntity.components.eventer;

		var _eventSubscribers = _targetEventer.eventMap[$ _eventType];
		if(!is_array(_eventSubscribers)) {
			throw String("Entity with id ",  _targetEntityId, " has no subscribers to event ", _eventType, ". Failed to unsusbscribe.");
		}
		
		var listLength = array_length(_eventSubscribers);
		var i = listLength - 1;
		var swapIndex = i;
		while(i > -1) {
			var eventSubscriber = _eventSubscribers[i];
			if(eventSubscriber.entityId == _entityId) {
				delete eventSubscriber;
				_eventSubscribers[i] = _eventSubscribers[swapIndex];
				swapIndex -= 1;
				listLength -=1;
			}
			i -= 1;
		}
	
		array_resize(_eventSubscribers, listLength);
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
					var entityRef = entity.GetRef(subscriptionData.entityId);
					if(!entityRef) {
						array_delete_fast(subscribers, i);
						delete subscriptionData;
						continue;
					}

					var func, instanceRef;
					instanceRef = entityRef;
					if(subscriptionData.componentName) {
						//grabbing system reference from the world
						instanceRef = world[$ subscriptionData.componentName];
						func = instanceRef[$ subscriptionData.funcName];
					} else if(is_struct(entityRef)) {
						func = variable_struct_get(entityRef, subscriptionData.funcName);
					} else {
						func = variable_instance_get(entityRef, subscriptionData.funcName);
					}
					
					//callbacks are called with the scope of their own instance.
					with(instanceRef) {
						func(event);
					}
				}
			}
		
			if(_eventer.debug) {
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
