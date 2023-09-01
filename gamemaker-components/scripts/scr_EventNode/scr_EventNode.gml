function EventNodeData() constructor {
    eventSubscriberMap = {};
}

///@param {Struct.EventNodeData OR Id.Instance<Any>} _target
function event_make_event_node(_target) {
    if(is_struct(_target) || instance_exists(_target)) {
        _target.eventSubscriberMap = {};
    } else {
        throw "Could not make target an event node";
    }
}

///@param {Struct.EventNodeData} _target
///@param {String} _eventName
///@param {Any} _data
function event_dispatch(_target, _eventName, _data) {
    var _listeners = _target.eventSubscriberMap[$ _eventName];

    if(is_undefined(_listeners)) {
        return
    }

    var _listenerCount = array_length(_listeners);
    for( var i = 0; i < _listenerCount; i += 1) {
        var _listener = _listeners[i];
        _listener(_data);
    }
}

///@param {Struct.EventNodeData} _target
///@param {String} _eventName
///@param {Function} _callback
function event_add_listener(_target, _eventName, _callback) {
    var _listeners = _target.eventSubscriberMap[$ _eventName];
        
        if(is_undefined(_listeners)) {
            _listeners = [];
            eventSubscriberMap[$ _eventName] = _listeners;
        }
        
        if(!array_contains(_listeners, _callback)) {
            array_push(_listeners, _callback);
        } else {
            throw "Cannot subscribe more than once per event per callback";
        }
}

///@param {Struct.EventNodeData} _target
///@param {String} _eventName
///@param {Function} _callback
function event_remove_listener(_target, _eventName, _callback) {
    with(_target) {
        var _listeners = eventSubscriberMap[$ _eventName];
        
        if(is_undefined(_listeners)) {
            show_debug_message($"error: no listeners to remove from event {_eventName}");
            return;
        }

        array_remove_fast(_listeners, _callback);
    }
}

///@param {Struct.EventNodeData } _target
function event_remove_all_listeners(_target) {
    event_make_event_node(_target);
}

