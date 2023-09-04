///@param {Struct.Node} _parentNode
///@param {Array<Struct.Node>} _childNodes
function Node(_parentNode = undefined, _childNodes = []) constructor {
    parentNode = _parentNode;
    childNodes = _childNodes;
}


///@return {Struct.Node}
function node_make_node(_instanceOrStruct) {
    if( is_struct(_instanceOrStruct) || instance_exists(_instanceOrStruct) ) {

        _instanceOrStruct.parentNode = undefined;
        _instanceOrStruct.childNodes = [];
        
         return _instanceOrStruct;
    }

    throw "Could not be made into event node";
}

///@param {Struct.Node} _parent
///@param {Struct.Node} _child
function node_append_child(_parent, _child) {
    node_remove(_child);
    _child.parentNode = _parent;
    array_push(_parent.childNodes, _child);
}

///@param {Struct.Node} _node
function node_remove(_node) {
    if(_node.parentNode != undefined) {
        array_remove_first(_node.parentNode.childNodes, _node);
        _node.parentNode = undefined;
    }
}

///@param {Struct.Node} _node
function node_root_node(_node) {
    while(_node.parentNode != undefined) {
        _node = _node.parentNode;
    }

    return _node;
}

///@param {Struct.Node} _node
function node_has_children(_node) {
    return array_length(_node.childNodes) > 0;
}

///@param {Struct.Node} _parent
///@param {Struct.Node} _child
function node_is_immediate_child(_parent, _child) {
    return array_contains(_parent.childNodes, _child);
}

///@param {Struct.Node} _parent
///@param {Struct.Node} _child
function node_contains(_parent, _child) {
    // A node does not contain itself
    if(_parent == _child) {
        return false;
    }

        while(_child != undefined) {
            if(_parent == _child) {
                return true;
            }
            _child = _child.parentNode;
        }

        return false;
}

///@param {Struct.Node} _node
function node_is_connected(_node) {
    return _node.parentNode != undefined;
}