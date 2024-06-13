object_serialize_as(obj_clickable, obj_clickable_serializer);
///@param {Struct.AssetGraph} _assetGraph
///@param {Asset.GMObject} _instance
function obj_clickable_serializer(_assetGraph, _instance) {
    var _instanceDescription = asset_graph_instance_add(_assetGraph, _instance);

    instance_description_add_property_instance_ref(_instance, _instanceDescription, "parentNode");
    instance_description_add_property_primitive(_instance, _instanceDescription, "nodeDepth");
    instance_description_add_property_primitive(_instance, _instanceDescription, "isDraggable");
    instance_description_add_property_array_instance_ref(_instance, _instanceDescription, "childNodes");

    // Serialize all children ui elements as well.
    array_foreach(_instance.childNodes, method({assetGraph: _assetGraph}, function(_childRef) {
        serialize(assetGraph, _childRef);
    }));

}
