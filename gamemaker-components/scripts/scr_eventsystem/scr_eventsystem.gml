/// @param {struct.Entity} _entity A reference to which thing this component is bound to.
function Event(_entity): Component(_entity) constructor{
    static staticIntialization();
}

///@param {Struct.GameManager} _gameManager
///@param {Struct.LoggingService} _logger
///@param {Struct.WorldTimeManager} _timeManager
function EventSystem(_gameManager, _logger, _timeManager) : ComponentSystem() constructor {
    static componentConstructor = Event;
    static staticIntialization();
    
    gameManager = _gameManager;
    logger = _logger;
    timeManager = _timeManager;

    //emitterId -> eventType -> SubscriptionData[]
    subscriptionMap = {};
    eventQueue = undefined;
    subscriberMatcherData = new SubscriberData(0, 0, "");
    // Feather restore GM2017
    static systemStart = function() {
        eventQueue = ds_map_create();
    }

    static systemCleanup = function() {
        if(ds_exists(eventQueue, ds_type_map)) {
            ds_map_destroy(eventQueue);
            eventQueue = -1;
        }
    }

    ///@param {Real} _dt Delta time in second since last step
    static systemStep = function(_dt) {
        var _eventsForSequence = eventQueue[? timeManager.worldSequence];
        
        if(!is_array(_eventsForSequence)) {
            return;
        }
        
        var _queuedEventCount = array_length(_eventsForSequence);
        
        for(var i = 0; i < _queuedEventCount; i += 1) {
            var _eventData = _eventsForSequence[i];
            
            var _eventMap = subscriptionMap[$ _eventData.entityId];
            if(is_undefined(_eventMap)) {
                continue;
            }

            var _subscriberList = _eventMap[$ _eventData.eventType];
            if(is_undefined(_subscriberList)) {
                continue;
            }
            
            var _subscriberCount = array_length(_subscriberList);
            
            for(var j = 0; j < _subscriberCount; j += 1) {
                var _subscriberData = _subscriberList[j];
                
                
                var _listenerWorld = gameManager.getWorldRef(_subscriberData.listenerWorldId);
                if(is_undefined(_listenerWorld)) {
                    // TODO: Remove this subscriber Data
                    continue;
                }

                var _listener = _listenerWorld.getRef(_subscriberData.listenerId);
                // TODO: Remove if entity is destroyed OR undefined
                if(is_undefined(_listener)) {
                    // TODO: Remove this subscriber data
                    continue;
                }

                //TODO: Introduce method/reference caching
                var _methodParts = string_split(_subscriberData.methodAddress, ".");
                var _componentName = _methodParts[0];
                var _system = _listenerWorld.system[$ _componentName];
                
                if(is_undefined(_system)) {
                    throw string_join("", "Could not find system with name", _componentName, " on listener world: ", _subscriberData.listenerWorldId);
                }
                
                /*
                //Commented this out because it will throw if its not a method anyways.
                var _method = _system[$ _methodParts[1]];
                if(!is_method(_method)) {
                    throw string_join("", "Could not find method with name: ", _methodParts[1], " on system: ", _system.name);
                }
                */
                var _methodName = _methodParts[1];
                _system[$ _methodName](_eventData);
            }
        }

        ds_map_delete(eventQueue, timeManager.worldSequence);
    }

    ///@param {Real} _listenerWorldId id of Entity interested in this event
    ///@param {Real} _listenerId id of Entity interested in this event
    ///@param {string} _methodAddress
    ///@param {string} _eventType
    ///@param {Real} _emitterId
    static subscribe = function(_listenerWorldId, _listenerId, _methodAddress, _eventType, _emitterId) {
        var _listenerWorld = gameManager.getWorldRef(_listenerWorldId);
        if(is_undefined(_listenerWorld)) {
            //logger.logError(LOG_LEVEL.URGENT, "EventSystem.Subscribe: Could not subscribe to entity ", _emitterId, " because listener world with id ", _listenerWorldId, " did not exist.");
            logger.logWarning(LOG_LEVEL.URGENT, "EventSystem.Subscribe: subscribing listener on world that doesnt exist.");
            //return;
        }

        var _emitter = world.getRef(_emitterId);
        if(is_undefined(_emitter)) {
            //logger.logError(LOG_LEVEL.URGENT, "EventSystem.Subscribe: Could not subscribe to entity ", _emitterId, " because it did not exist on world ", _emitterWorldId);
            logger.logWarning(LOG_LEVEL.URGENT, "EventSystem.Subscribe: subscribing to emitter that doesnt exist in this world: ", world.id);
            //return;
        }
        
        if(is_defined(_listenerWorld)) {
            var _listener = _listenerWorld.getRef(_listenerId);
            if(is_undefined(_listener)) {
                //logger.logError(LOG_LEVEL.URGENT, "EventSystem.Subscribe: Could not subscribe because the listener does not exist ", _listenerId);
                logger.logWarning(LOG_LEVEL.URGENT, "EventSystem.Subscribe: subscribing listener that doesnt exist in this on world: ", _listenerWorldId);
                //return;
            }

            var _methodParts = string_split(_methodAddress, ".");
            var _system = _listenerWorld.system[$ _methodParts[0]];
            var _method = _system[$ _methodParts[1]];
            if(!is_method(_method)) {
                logger.logWarning(LOG_LEVEL.URGENT, "EventSystem.Subscribe: Could not subscribe because the method at ", _methodAddress, " did not exist in the listener world.");
                //return;
            }
        }
        
        var _eventMap = subscriptionMap[$ _emitterId];
        if(is_undefined(_eventMap)) {
            _eventMap = {};
            subscriptionMap[$ _emitterId] = _eventMap;
        }

        var _subscriberList = _eventMap[$ _eventType];
        if(is_undefined(_subscriberList)) {
            _subscriberList = [];
            _eventMap[$ _eventType] = _subscriberList;
        }

        var _newSubscriberData = new SubscriberData(_listenerId, _listenerWorldId, _methodAddress);
        array_push(_subscriberList, _newSubscriberData);
    }
    
    ///@param {Real} _listenerWorldId id of Entity interested in this event
    ///@param {Real} _listenerId id of Entity interested in this event
    ///@param {string} _methodAddress
    ///@param {string} _eventType
    ///@param {Real} _emitterId
    static unsubscribe = function(_listenerWorldId, _listenerId, _methodAddress, _eventType, _emitterId) {
        var _eventMap = subscriptionMap[$ _emitterId];
        if(is_undefined(_eventMap)) {
            return;
        }
        
        var _subscriberList = _eventMap[$ _eventType];
        if(is_undefined(_subscriberList)) {
            return;
        }
        
        subscriberMatcherData.listenerId = _listenerId;
        subscriberMatcherData.listenerWorldId = _listenerWorldId;
        subscriberMatcherData.methodAddress = _methodAddress;

        var _subscriberIndex = array_find_index(_subscriberList, subscriberMatcher);
        if (_subscriberIndex == -1) { 
            return;
        }

        array_delete_fast(_subscriberList, _subscriberIndex);
    }

    ///@param {string} _eventType
    ///@param {Real} _entityId
    ///@param {Any} _data
    ///@param {Real} _worldSequenceNumber
    static dispatch = function(_eventType, _entityId, _data, _worldSequenceNumber = timeManager.worldSequence + 1) {
        if(_worldSequenceNumber <= timeManager.worldSequence) {
            logger.logWarning(LOG_LEVEL.INFORMATIONAL, "Tried to dispatch event to old sequence number: ", _worldSequenceNumber, ". Current: ",  timeManager.worldSequence);
            return;
        }

        var _sequenceEventQueue = getOrInsertEventQueue(_worldSequenceNumber);
        
        array_push(_sequenceEventQueue, new EventData(_eventType, _data, _entityId));
    }

    ///@param {Real} _worldSequenceNumber
    ///@return {Array<Any>}
    static getOrInsertEventQueue = function(_worldSequenceNumber) {
        var _eventsForSequence = eventQueue[?_worldSequenceNumber];
        if(is_undefined(_eventsForSequence)) {
            _eventsForSequence = [];
            eventQueue[?_worldSequenceNumber] = _eventsForSequence;
        }

        return _eventsForSequence;
    }
    
    ///@param {Struct.SubscriberData} _subscriberData
    ///@return {Bool}
    static subscriberMatcher = function(_subscriberData) {
        return subscriberMatcherData.listenerId == _subscriberData.listenerId
            && subscriberMatcherData.listenerWorldId == _subscriberData.listenerWorldId
            && subscriberMatcherData.methodAddress == _subscriberData.methodAddress;
    }
    
}
