/// @desc EventSubscription stores the data required to identify two entities (emitter and listener) and the eventType
/// @param {Real} _entityId the id of listener who is wiating for a specific event type.
/// @param {String} _funcName The name of the function to call when the event type is emitted
/// @param {String} _componentName The name of the component which holds the function to call.
function EventSubscription(_entityId, _funcName, _componentName) constructor {
	entityId = _entityId;
	funcName =_funcName;
	componentName = _componentName;
};


function SubscriptionMap() constructor {
	/// Map<eventType, Map<emitterId, Array<Any>>>
	subscriptions = {};
	
	/**
	 * @function getEventSubscribers
	 * @param {Real} _emitterId  the integer id of the entity which the event is emitted from
	 * @param {String} _eventType the eventType
	 * @returns {Array}
	 */
	static getEventSubscribers = function getEventSubscribers(_emitterId, _eventType) {
		if(!variable_struct_exists(subscriptions, _eventType)) {
			return [];
		}
		var _emitterEventMap = subscriptions[$ _eventType];
		//Returns array of subscriberIds for this emitter and event.
		return _emitterEventMap[$ _emitterId];
	};
	
	/**
	 * @function addEventSubscriber
	 * @param {Real} _emitterId  the integer id of the entity which the event is emitted from
	 * @param {String} _eventType the eventType
	 * @param {Any} _data the integer id of the entity which the event is emitted from
	 */
	static addEventSubscriber = function addEventSubscriber(_emitterId, _eventType, _data) {
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
