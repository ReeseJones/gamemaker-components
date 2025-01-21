///@param {Struct} _flexpanelStyle
function UIElement(_flexpanelStyle = undefined) : EventNode() constructor {
    
    if(is_undefined(_flexpanelStyle)) {
        _flexpanelStyle = {
            name: "UIElement",
            direction: "ltr",
            position: "relative",
            width: "100%",
            height: "100%",
            flexDirection: "column",
            flexGrow: 1,
            flexShrink: 1
        };
    }
    _flexpanelStyle.data = self;

    flexNode = flexpanel_create_node(_flexpanelStyle);

    isDraggable = false;
    isClickable = false;
    mouseIsOver = false;
    interceptPointerEvents = true;
    nodeDepth = 0;
    
    left = 0;
    top = 0;
    right = 0;
    bottom = 0;
    width = 0;
    height = 0;
    hadOverflow = false;
    contentWidth = 0;
    contentHeight = 0;
    
    textDescription = new UiTextDescription();
    
    spriteIndex = undefined;
    
    static draw = function() {

        var _col = c_white;
        var _alpha = 1;
        if(mouseIsOver) {
            _col = c_red;
        }

        if(spriteIndex != undefined) {
            draw_sprite_stretched_ext(spriteIndex, 0, left, top, width, height, _col, _alpha);
        }
        
        if(is_string(textDescription.text)) {
            var _xx = 0;
            var _yy = 0;
            switch(textDescription.halign) {
                case fa_right:
                    _xx = right;
                break;
                case fa_center:
                    _xx = (left + right) / 2;
                    break;
                case fa_left:
                default:
                    _xx = left;
                    break;
            }
            switch(textDescription.valign) {
                case fa_bottom:
                    _yy = bottom;
                break;
                case fa_middle:
                    _yy = (top + bottom) / 2;
                    break;
                case fa_top:
                default:
                    _yy = top;
                    break;
            }
            
            draw_set_color(mouseIsOver ? c_white : textDescription.color);
            draw_set_alpha(textDescription.alpha);
            draw_set_font(textDescription.font);
            draw_set_halign(textDescription.halign);
            draw_set_valign(textDescription.valign);

            _xx = round(_xx);
            _yy = round(_yy);
            draw_text_ext(_xx, _yy, textDescription.text, textDescription.lineSpacing, width);
        }
    }
    
    static append = function() {
        var _insertionSpot = flexpanel_node_get_num_children(flexNode);
        for(var i = 0; i < argument_count; i += 1) {
            var _el = argument[i];
            if( is_instanceof(_el, UIElement) ) {
                _el.remove();
                _el.parentNode = self;
                array_push(childNodes, _el);
                flexpanel_node_insert_child(flexNode, _el.flexNode, _insertionSpot);
                ui_element_update_node_depth(_el);
                _insertionSpot += 1;
            }
        }
    }
    
    ///@return {Struct.UIElement}
    static parent = function() {
        var _parent = flexpanel_node_get_parent(flexNode);
        
        if(is_undefined(_parent)) {
            return _parent;
        }
        return flexpanel_node_get_data(flexNode);
    }
    
    ///@desc Disconnects this node from its parent if it has one.
    static remove = function() {
        var _parent = flexpanel_node_get_parent(flexNode);
        
        if (!is_undefined(_parent)) {
            flexpanel_node_remove_child(_parent, flexNode);
            ui_element_update_node_depth(self);
            
            array_remove_first(parentNode.childNodes, self);
            parentNode = undefined;
        }
    }
    
    static removeAllChildren = function() {
        var _childrenCount = flexpanel_node_get_num_children(flexNode);
        var _tempChildren = [];
        for(var i = 0; i < _childrenCount; i += 1) {
            var _node = flexpanel_node_get_child(flexNode, i);
            var _uiElement = flexpanel_node_get_data(_node);
            array_push(_tempChildren, _uiElement);
        }
        flexpanel_node_remove_all_children(flexNode);
        
        for(var i = 0; i < _childrenCount; i += 1) {
            var _child = _tempChildren[i];
            ui_element_update_node_depth(_child);
            _uiElement.parentNode = undefined;
            
        }
        
        childNodes = [];
    }
    
    ///@desc Finds the root of this node.
    ///@return {Struct.UIElement}
    static getRoot = function() {
        var _currentElement = self;
        while(flexpanel_node_get_parent(_currentElement.flexNode) != undefined) {
            _currentElement =_currentElement.parent();
        }
        return flexpanel_node_get_data(_currentElement.flexNode);
    }
    
    static hasChildren = function() {
        return flexpanel_node_get_num_children(flexNode) > 0;
    }
    
    ///@desc returns true if it has a parent. A root node will appear not connected.
    static isConnected = function() {
        return flexpanel_node_get_parent(flexNode) != undefined;
    }
    
    static setText = function(_text, _useTextHeight = false) {
        textDescription.text = _text;
        
        if(is_string(textDescription.text) && _useTextHeight) {
            draw_set_font(textDescription.font);
            draw_set_halign(textDescription.halign);
            draw_set_valign(textDescription.valign);
            var _layout = flexpanel_node_layout_get_position(flexNode, false);
            var _textHeight = string_height_ext(textDescription.text, textDescription.lineSpacing, _layout.width);
            setHeight(_textHeight, flexpanel_unit.point);
        }

        return self;
    }
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static setWidth = function(_width, _unit) {
        flexpanel_node_style_set_width(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static setMinWidth = function(_width, _unit) {
        flexpanel_node_style_set_min_width(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static setMaxwidth = function(_width, _unit) {
        flexpanel_node_style_set_max_width(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _height
    ///@param {any} _unit flexpanel_unit
    static setHeight = function(_height, _unit) {
        flexpanel_node_style_set_height(flexNode, _height, _unit);
        return self;
    }
    
    ///@param {real} _height
    ///@param {any} _unit flexpanel_unit
    static setMinHeight = function(_height, _unit) {
        flexpanel_node_style_set_min_height(flexNode, _height, _unit);
        return self;
    }
    
    ///@param {real} _height
    ///@param {any} _unit flexpanel_unit
    static setMaxHeight = function(_height, _unit) {
        flexpanel_node_style_set_max_height(flexNode, _height, _unit);
        return self;
    }
    
    ///@desc Opposite of setting flex basis (size along flex axis), this sets the size along the cross axis.
    ///@param {any} _flexDirection flexpanel_flex_direction
    ///@param {real} _size
    ///@param {any} _unit flexpanel_unit
    static setCrossAxisSize = function(_flexDirection, _size, _unit) {
        switch(_flexDirection) {
            case flexpanel_flex_direction.row:
            case "row":
            case flexpanel_flex_direction.row_reverse:
            case "row-reverse":
                flexpanel_node_style_set_height(flexNode, _size, _unit);
                break;
            case flexpanel_flex_direction.column:
            case "column":
            case flexpanel_flex_direction.column_reverse:
            case "column-reverse":
                flexpanel_node_style_set_width(flexNode, _size, _unit);
                break;
            default: throw $"no direction: {_flexDirection}";
        }
        return self;
    }
    
    ///@param {real} _ratio // ratio of width to height
    static setAspectRatio = function(_ratio) {
        flexpanel_node_style_set_aspect_ratio(flexNode, _ratio);
        return self;
    }
    
    ///@param {any} _edge
    ///@param {real} _value
    ///@param {any} _unit flexpanel_unit
    static setPosition = function(_edge, _value, _unit ) {
        flexpanel_node_style_set_position(flexNode, _edge, _value, _unit);
        return self;
    }
    
    ///@param {any} _positionType flexpanel_position_type "relative" | "absolute" | "static"
    static setPositionType = function(_positionType ) {
        flexpanel_node_style_set_position_type(flexNode, _positionType);
        return self;
    }
    
    ///@param {any} _edge flexpanel_edge
    ///@param {real} _value
    static setMargin = function(_edge, _value) {
        flexpanel_node_style_set_margin(flexNode, _edge, _value);
        return self;
    }
    
    ///@param {any} _edge flexpanel_edge
    ///@param {real} _value
    static setPadding = function(_edge, _value) {
        flexpanel_node_style_set_padding(flexNode, _edge, _value);
        return self;
    }
    
    ///@param {any} _direction flexpanel_flex_direction
    static setFlexDirection = function(_direction) {
        flexpanel_node_style_set_flex_direction(flexNode, _direction);
        return self;
    }
    
    ///@param {any} _wrap flexpanel_wrap
    static setFlexWrap = function(_wrap) {
        flexpanel_node_style_set_flex_wrap(flexNode, _wrap);
        return self;
    }
    
    ///@param {real} _value
    ///@param {any} _unit flexpanel_unit
    static setFlexBasis = function(_value, _unit) {
        flexpanel_node_style_set_flex_basis(flexNode, _value, _unit);
        return self;
    }
    
    ///@param {real} _value
    static setFlexGrow = function(_value) {
        flexpanel_node_style_set_flex_grow(flexNode, _value);
        return self;
    }
    
    ///@param {real} _value
    static setFlexShrink = function(_value, _unit) {
        flexpanel_node_style_set_flex_shrink(flexNode, _value);
        return self;
    }
    
    ///@param {any} _justify flexpanel_justify
    static setJustifyContent = function(_justify) {
        flexpanel_node_style_set_justify_content(flexNode, _justify);
        return self;
    }
    
    ///@param {any} _align flexpanel_align
    static setAlignItems = function(_align) {
        flexpanel_node_style_set_align_items(flexNode, _align);
        return self;
    }
    
    ///@param {any} _align flexpanel_align
    static setAlignSelf = function(_align) {
        flexpanel_node_style_set_align_self(flexNode, _align);
        return self;
    }
    
    ///@param {any} _justify flexpanel_justify
    static setAlignContent = function(_justify) {
        flexpanel_node_style_set_align_content(flexNode, _justify);
        return self;
    }
    
    ///@param {any} _display flexpanel_display "flex" | "none"
    static setDisplay = function(_display) {
        flexpanel_node_style_set_display(flexNode, _display);
        return self;
    }
    
    ///@param {string} _name
    static setNodeName = function(_name) {
        flexpanel_node_set_name(flexNode, _name);
        return self;
    }
    
    static disposeFunc = function() {
        flexpanel_delete_node(flexNode);
        flexNode = undefined;
    }
    
    static toString = function() {
        var _name = "<UIElement>";
        if(!is_undefined(flexNode)) {
            var _nodeName = flexpanel_node_get_name(flexNode);
            if(!is_undefined(_nodeName)) {
                _name = $"<{_nodeName}>";
            }
        }
        return _name;
    }

}