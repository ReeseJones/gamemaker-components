event_inherited();
textDescription = new UiTextDescription();
// After text has been layed out, it tries set its height based on enforced widths
postLayoutCallback = function() {
    if(!is_string(textDescription.text)) return;
    var _extraHeight = calculatedSize.border.top + calculatedSize.border.bottom + calculatedSize.padding.top + calculatedSize.padding.bottom;
    var _prevHeight = sizeProperties.height;
    sizeProperties.height = string_height_ext(textDescription.text, textDescription.lineSpacing, calculatedSize.innerWidth) + _extraHeight;
    
    if(_prevHeight != sizeProperties.height) {
        node_foreach_parent(id, function(_node) {
          //show_debug_message($"Needs recalculated ${_node} {object_get_name(_node.object_index)} {_node.nodeDepth}");
          _node.calculatedSize.needsRecalculated = true;
        });
    }
};