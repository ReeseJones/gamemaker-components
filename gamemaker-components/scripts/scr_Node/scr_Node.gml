///@param {Struct.Node} _parentNode
///@param {Array<Struct.Node>} _childNodes
function Node(_parentNode = undefined, _childNodes = []) constructor {
    parentNode = _parentNode;
    childNodes = _childNodes;
    nodeDepth = 0;
}


///@return {Struct.Node}
function node_make_node_like(_instanceOrStruct) {
    if( is_struct(_instanceOrStruct) || instance_exists(_instanceOrStruct) ) {

        _instanceOrStruct.parentNode = undefined;
        _instanceOrStruct.childNodes = [];
        _instanceOrStruct.nodeDepth = 0;
        
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
    node_update_depth(_child);
}

///@param {Struct.Node} _node
function node_remove(_node) {
    if(_node.parentNode != undefined) {
        array_remove_first(_node.parentNode.childNodes, _node);
        _node.parentNode = undefined;
        node_update_depth(_node);
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
function node_update_depth(_node) {
    if(is_undefined(_node.parentNode)) {
        _node.nodeDepth = 0;
    } else {
        _node.nodeDepth = _node.parentNode.nodeDepth + 1;
        //TODO: THIS IS A HACK FOR DEPTH
        _node.depth = -_node.nodeDepth;
    }
    
    var _childCount = array_length(_node.childNodes);
    for(var i = 0; i < _childCount; i += 1) {
        var _childNode = _node.childNodes[i];
        node_update_depth(_childNode);
    }
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

///@description depth first node taversal. calls callback on all nodes
///@param {Struct.Node} _node
///@param {Function} _callback
///@param {bool} _includeRoot
function node_foreach(_node, _callback, _includeRoot = false) {
    if(_includeRoot) {
        _callback(_node);
    }
    var _childLength = array_length(_node.childNodes);
    for(var i = 0; i < _childLength; i += 1) {
        var _child = _node.childNodes[i];
        node_foreach(_child, _callback, true);
    }
}

///@description Traverse up the node tree towards the parent.
///@param {Struct.Node} _node
///@param {Function} _callback
///@param {bool} _includeRoot
function node_foreach_parent(_node, _callback, _includeRoot = false) {
    if(_includeRoot) {
        _callback(_node);
    }

    if(is_defined(_node.parentNode)) {
        node_foreach_parent(_node.parentNode, _callback, true);
    }
}

///@param {Struct.Node} _node
function node_get_root(_node) {
    while(is_defined(_node.parentNode)) {
        _node = _node.parentNode;
    }
    return _node;
}