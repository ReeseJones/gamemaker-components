///@param {Struct.UIElement} _root
function ui_render_elements(_root) {
    var _childrenNum = flexpanel_node_get_num_children(_root.flexNode);
    
    if(struct_exists(_root, "draw")) {
        if(is_callable(_root.draw)) {
            _root.draw();
        } else {
            throw "node draw was not callable.";
        }
    }
    
    var _scissor;
    var _renderChildren = _childrenNum > 0;
    
    if(_root.hadOverflow && _renderChildren) {
        _scissor = gpu_get_scissor();
        var _sTop = _scissor.y;
        var _sLeft = _scissor.x;
        var _sBottom = _sTop + _scissor.h;
        var _sRight = _sLeft + _scissor.w;

        var _x5 = max(_root.left, _sLeft);
        var _y5 = max(_root.top, _sTop);
        var _x6 = min(_root.right, _sRight);
        var _y6 = min(_root.bottom, _sBottom);
        
        var _width = _x6 - _x5;
        var _height = _y6 - _y5;
        
        // Do not render children if they are not in the clipping rectangle at all
        _renderChildren = rectangle_in_rectangle(_root.left, _root.top, _root.right, _root.bottom, _sLeft, _sTop, _sRight, _sBottom) != 0;
        
        if(_renderChildren) {
            gpu_set_scissor(_x5, _y5, _width, _height);
        }
    }
    
    if(_renderChildren) {
        for(var i = 0; i < _childrenNum; i += 1) {
          var _childNode = flexpanel_node_get_child(_root.flexNode, i);
          var _childElement = flexpanel_node_get_data(_childNode);
          ui_render_elements(_childElement);
      }
    }
    
    
    if(_root.hadOverflow && _renderChildren) {
        gpu_set_scissor(_scissor);
    }
}
