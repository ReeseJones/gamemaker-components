enum EntityId {
	Game = -42,
	World0 = 0,
	//Everything below starting entityId could be a world id (except for id reserved for game)
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


function SubscriptionMap() constructor {
	subscriptions = {};
	
	static GetEventSubscribers = function GetEventSubscribers(_emitterId, _eventType) {
		if(!variable_struct_exists(subscriptions, _emitterId)) {
			return undefined;	
		}
		var _emitterEventMap = subscriptions[$ _emitterId];
		if(!variable_struct_exists(_emitterEventMap, _eventType)) {
			return undefined;	
		}
		//Returns array of subscriberIds for this emitter and event.
		return _emitterEventMap[$ _eventType];		
	};
	
	static AddEventSubscriber = function AddEventSubscriber(_emitterId, _eventType, _listenerId) {
		if(!variable_struct_exists(subscriptions, _emitterId)) {
			return undefined;	
		}
		var _emitterEventMap = subscriptions[$ _emitterId];
		if(!variable_struct_exists(_emitterEventMap, _eventType)) {
			return undefined;	
		}
		//Returns array of subscriberIds for this emitter and event.
		return _emitterEventMap[$ _eventType];	
	}
}

function EventSystem(_world) constructor {
	world = _world;
	eventSequenceQueue = ds_priority_create();
	/*
		map of emitter Id to eventType subscribers
	*/
	subscriberMap = {};
	
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
