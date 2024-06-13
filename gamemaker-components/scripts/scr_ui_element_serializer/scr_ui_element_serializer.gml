object_serialize_as(obj_ui_element, obj_ui_element_serializer);
///@param {Struct.AssetGraph} _assetGraph
///@param {Asset.GMObject} _instance
function obj_ui_element_serializer(_assetGraph, _instance) {
    var _instanceDescription = asset_graph_instance_add(_assetGraph, _instance);

    instance_description_add_property_primitive(_instance, _instanceDescription, "sizeProperties");
}
