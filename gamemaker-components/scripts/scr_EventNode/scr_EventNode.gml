enum EVENT_PHASE {
    NONE,
    CAPTURING_PHASE,
    AT_TARGET,
    BUBBLING_PHASE
}

///@param {string} _type
///@param {Any} _data
function EventData(_type, _data) constructor {
    type = _type;
    target = undefined;
    data = _data;
    eventPhase = EVENT_PHASE.NONE;
    immediateCancel = false;
    cancel = false;

    static stopImmediatePropagation = function() {
        immediateCancel = true;
    }
    
    static stopPropagation = function() {
        cancel = true;
    }
}

///@param {Struct.EventNode} _parent
///@param {Array<Struct.EventNode>} _children
function EventNode(_parent = undefined, _children = []) : Node(_parent, _children) constructor {
    eventCaptureSubscriberMap = {};
    eventBubbleSubscriberMap = {};
}

///@description Will turn a struct or instance into an event node.
///@param {Struct.EventNode OR Id.Instance<Any>} _target
///@return {Struct.EventNode}
function event_make_event_node(_target) {
    if( is_struct(_target) || instance_exists(_target) ) {
        _target.eventCaptureSubscriberMap = {};
        _target.eventBubbleSubscriberMap = {};

        return node_make_node(_target);;
    }

    throw "Could not be made into event node";
}

///@param {Struct.EventNode} _target
///@param {Struct.EventData} _event
function event_dispatch(_target, _event) {
    _event.target = _target;

    var _eventPath = [];
    var _currentNode = _target;

    while(!is_undefined(_currentNode)) {
        array_push(_eventPath, _currentNode);
        _currentNode = _currentNode.parentNode;
    }

    _event.eventPhase = EVENT_PHASE.CAPTURING_PHASE;
    //Do capture phase
    //Root to target
    var _eventPathLength = array_length(_eventPath);

    for (var i = _eventPathLength - 1; i > 0; i -= 1) {
        if(i == 0) {
            _event.eventPhase = EVENT_PHASE.AT_TARGET;
        }
        _currentNode = _eventPath[i];
        var _listeners = _currentNode.eventCaptureSubscriberMap[$ _event.type];
        event_dispatch_helper(_listeners, _event);
        if(_event.immediateCancel || _event.cancel) {
            return;
        }
    }

    //Do bubble phase
    //target to root
    for(var i = 0; i < _eventPathLength; i += 1) {
        if(i - 1 == 0) {
            _event.eventPhase = EVENT_PHASE.BUBBLING_PHASE;
        }
        _currentNode = _eventPath[i];
        var _listeners = _currentNode.eventBubbleSubscriberMap[$ _event.type];
        event_dispatch_helper(_listeners, _event);
        if(_event.immediateCancel || _event.cancel) {
            return;
        }
    }
}

///@param {Array<Function>} _listeners
///@param {Struct.EventData} _event
function event_dispatch_helper(_listeners, _event) {
    if(is_undefined(_listeners)) {
        return true;
    }

    var _listenerCount = array_length(_listeners);
    for( var i = 0; i < _listenerCount; i += 1) {
        var _listener = _listeners[i];
        _listener(_event);
        if(_event.immediateCancel) {
            return false;
        }
    }

    return true;
}

///@param {Struct.EventNode} _target
///@param {String} _eventName
///@param {Function} _callback
///@param {Bool} _capture
function event_add_listener(_target, _eventName, _callback, _capture = false) {
    var _eventSubscriberMap = event_target_subscriber_map(_target, _capture);
    var _listeners = _eventSubscriberMap[$ _eventName];

    if(is_undefined(_listeners)) {
        _listeners = [];
        _eventSubscriberMap[$ _eventName] = _listeners;
    }

    if(!array_contains(_listeners, _callback)) {
        array_push(_listeners, _callback);
    } else {
        throw "Cannot subscribe more than once per event per callback";
    }
}

///@param {Struct.EventNode} _target
///@param {String} _eventName
///@param {Function} _callback
///@param {Bool} _capture
function event_remove_listener(_target, _eventName, _callback, _capture = false) {
    var _eventSubscriberMap = event_target_subscriber_map(_target, _capture);
    var _listeners = _eventSubscriberMap[$ _eventName];

    if(is_undefined(_listeners)) {
        show_debug_message($"error: no listeners to remove from event {_eventName}");
        return;
    }

    array_remove_fast(_listeners, _callback);
}

///@param {Struct.EventNode } _target
function event_remove_all_listeners(_target) {
    delete _target.eventCaptureSubscriberMap;
    delete _target.eventBubbleSubscriberMap;
    _target.eventCaptureSubscriberMap = {};
    _target.eventBubbleSubscriberMap = {};
}

///@param {Struct.EventNode } _target
///@param {Bool} _capture
function event_target_subscriber_map(_target, _capture) {
    return _capture ? _target.eventCaptureSubscriberMap : _target.eventBubbleSubscriberMap;
}
