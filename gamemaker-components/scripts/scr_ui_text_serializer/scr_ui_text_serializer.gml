object_serialize_as(obj_ui_text, obj_ui_text_serializer);
///@param {Struct.AssetGraph} _assetGraph
///@param {Id.Instance} _instance
function obj_ui_text_serializer(_assetGraph, _instance) {
    var _instanceDescription = asset_graph_instance_add(_assetGraph, _instance);

    instance_description_add_property_primitive(_instance, _instanceDescription, "textDescription");
}
