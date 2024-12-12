///@desc This creates rather large ararays, so use sparingly.
///@param {Id.Layer} _layerId
///@param {Function} _method
function layer_foreach_instance(_layerId, _method) {
    var _elements = layer_get_all_elements(_layerId);
    var _count = array_length(_elements);
    for(var i = 0; i < _count; i += 1) {
         var _instId = layer_instance_get_instance(_elements[i]);
         _method(_instId);
     }
}