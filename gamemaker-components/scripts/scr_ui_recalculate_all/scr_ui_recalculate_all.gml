function ui_mark_tree_recaculate(_node) {
    node_foreach_parent(_node, function(_node) {
        _node.calculatedSize.needsRecalculated = true;
    });
    node_foreach(_node, function(_node) {
        _node.calculatedSize.needsRecalculated = true;
    }, true);
}