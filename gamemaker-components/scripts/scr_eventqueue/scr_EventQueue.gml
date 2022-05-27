function EventQueue() constructor {
	eventMap = {};
	eventQueue = ds_queue_create();
	eventQueueBuffer = ds_queue_create();
	debug = false;
	
	static SubscribeToEvent = function(_eventType, _callback) {
		var eventSubscribers = eventMap[$ _eventType];
		if(is_undefined(eventSubscribers)) {
			eventSubscribers = [];
			eventMap[$ _eventType] = eventSubscribers;
		}
		
		array_push(eventSubscribers, _callback);
	}
	
	static UnSubscribeFromEvent = function(_eventType, _callback) {
		var eventSubscribers = eventMap[$ _eventType];
		if(is_undefined(eventSubscribers)) {
			return;
		}
		
		array_remove(eventSubscribers, _callback);
	}
	
	static QueueEvent = function(_eventType, _eventData) {
		ds_queue_enqueue(eventQueueBuffer, new Event(_eventType, _eventData));
	}
	
	static FlushEventQueue = function() {
		//Swap the buffer into the main queue and process all events
		var queueSwap = eventQueue;
		eventQueue = eventQueueBuffer;
		eventQueueBuffer = queueSwap;
		
		//process all events until none left.
		while( !ds_queue_empty(eventQueue) ) {
			var event = ds_queue_dequeue(eventQueue);
			var subscribers = eventMap[$ event.eventType];
			if(!is_undefined(subscribers)) {		
				var subscriberCount = array_length(subscribers);
				for(var i = 0; i < subscriberCount; i += 1) { 
					var callback = subscribers[i];
					callback(event);
				}
			}
			if(debug) {
				show_debug_message(String("Event: ", EventName(event.eventType)));
			}
		}
	}
}

function event_queue_create() {
	return new EventQueue();	
}

function event_queue_destroy(_eventQueue) {

	//Cleanup root level data structures.
	_eventQueue.eventMap = -1;
	delete _eventQueue.eventMap;
	
	ds_queue_destroy(_eventQueue.eventQueue);
	_eventQueue.eventQueue = -1;
	ds_queue_destroy(_eventQueue.eventQueueBuffer);
	_eventQueue.eventQueueBuffer = -1;
	
	delete _eventQueue;
}