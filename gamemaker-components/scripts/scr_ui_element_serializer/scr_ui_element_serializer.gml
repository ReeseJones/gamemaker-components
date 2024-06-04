object_serialize_as(obj_ui_element, obj_ui_element_serializer, obj_ui_element_deserializer);
///@param {Struct.AssetGraph} _assetGraph
///@param {Asset.GMObject} _instance
function obj_ui_element_serializer(_assetGraph, _instance) {
    var _instanceDescription = asset_graph_instance_add(_assetGraph, _instance);

    instance_description_add_property_instance_ref(_instance, _instanceDescription, "parentNode");
    instance_description_add_property_primitive(_instance, _instanceDescription, "nodeDepth");
    instance_description_add_property_array_instance_ref(_instance, _instanceDescription, "childNodes");

    instance_description_add_property_primitive(_instance, _instanceDescription, "isDraggable");
    instance_description_add_property_primitive(_instance, _instanceDescription, "sizeProperties");
    // Done need to save calculated values.
    // instance_description_add_property_primitive(_instance, _instanceDescription, "calculatedSize");
}

function obj_ui_element_deserializer() {

}