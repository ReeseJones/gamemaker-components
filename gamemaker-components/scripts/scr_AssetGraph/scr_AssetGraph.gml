function asset_graph_instance_exists(_assetGraph, _instance) {
    return struct_exists(_assetGraph.instances, _instance.id);
}

function asset_graph_instance_add(_assetGraph, _instance) {
    if(asset_graph_instance_exists(_assetGraph, _instance)) {
        throw $"Instance with id {_instance.id} already added to graph.";
    }

    var _instanceObjectName = object_get_name(_instance.object_index);
    var _instanceDesc = new InstanceDescription(_instanceObjectName, _instance.id);

    _assetGraph.instances[$ int64(_instance.id)] = _instanceDesc;

    return _instanceDesc;
}

struct_save_static(nameof(AssetGraph), AssetGraph)
function AssetGraph() constructor {
    instances = {};
    structs = {};
}