#macro ENTITY_INITIAL_ID 100

///@param {Real} _entityId
///@param {struct.World} _world
function Entity(_entityId, _world) constructor {
    // Feather disable GM2017
    entityId = _entityId;
    world = _world;
    component = {};
    entityIsDestroyed = false;
    // Feather restore GM2017
}