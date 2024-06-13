function asset_graph_instance_exists(_assetGraph, _id) {
    _id = id_to_string(_id);
    return struct_exists(_assetGraph.instances, _id);
}


///@description adds or gets an already added assetGraph instance description
///@return {Struct.InstanceDescription}
function asset_graph_instance_add(_assetGraph, _instance) {
    var _id =  id_to_string(_instance.id);
    if(asset_graph_instance_exists(_assetGraph, _id)) {
        return _assetGraph.instances[$ _id];
    }

    var _instanceObjectName = object_get_name(_instance.object_index);
    var _instanceDesc = new InstanceDescription(_instanceObjectName, "instance", _id);

    _assetGraph.instances[$ _id] = _instanceDesc;
    array_push(_assetGraph.ids, _id);

    return _instanceDesc;
}

function asset_graph_struct_add(_assetGraph, _struct) {
    var _id = struct_get_id(_struct);

    if(asset_graph_instance_exists(_assetGraph, _id)) {
        throw $"Instance with id {_id} already added to graph.";
    }

    var _instanceDesc = new InstanceDescription(_struct.__ssn, "struct", _id);

    _assetGraph.instances[$ _id] = _instanceDesc;
    array_push(_assetGraph.ids, _id);

    return _instanceDesc;
}

struct_save_static(nameof(AssetGraph), AssetGraph)
function AssetGraph() constructor {
    instances = {};
    ids = [];
}