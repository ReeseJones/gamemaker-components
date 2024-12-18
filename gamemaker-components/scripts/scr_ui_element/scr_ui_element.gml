enum ELEMENT_LAYOUT_TYPE {
    NONE = 0,
    MANUAL = 1,
    FLEX_HORIZONTAL = 2,
    FLEX_VERTICAL = 3
}

enum LAYOUT_ALIGNMENT {
    CENTER,
    STRETCH,
    START,
    END,
}

enum LAYOUT_JUSTIFICATION {
    START,
    END,
    CENTER
}

///@param {real} _width A width equal to or less than 1.0 is interpreted as a percentage of the parents size
// A number greater than or equal to 2 is interpreted as a gui pixel size
// Undefined means something else calculates size
// 0.0 - 1.0 | N >= 2 | undefined
///@param {real} _height
///@param {Struct.Box} _border
///@param {Struct.Box} _padding
///@param {Struct.Box} _position
function ElementSizeDescription(_width = undefined, _height = undefined, _border = new Box(), _padding = new Box(), _position = new Box() ) constructor {
    width = _width;
    height = _height;
    border = _border;
    padding = _padding;
    position = _position;
    layout = ELEMENT_LAYOUT_TYPE.MANUAL;
    alignment = LAYOUT_ALIGNMENT.CENTER;
    justifyContent = LAYOUT_JUSTIFICATION.START;
    collides = true;
}

///@description The caculated sizes derived from the ElementSizeDescription
///@param {real} _width
///@param {real} _height
///@param {Struct.Box} _border
///@param {Struct.Box} _padding
///@param {Struct.Box} _position
function ElementSizeProperties(_width = undefined, _height = undefined, _border = new Box(), _padding = new Box(), _position = new Box() ) constructor {
    needsRecalculated = true;
    contentSize = 0;
    childOffset = new Vec2();

    width = _width;
    height = _height;
    innerWidth = _width;
    innerHeight = _height;
    border = _border;
    padding = _padding;
    position = _position;
}

///@description DO NOT USE. Just for autocomplete.
function ElementProperties() : EventNode() constructor {
    sizeProperties = new ElementSizeDescription();
    calculatedSize = new ElementSizeProperties();
    textDescription = new UiTextDescription();
    calculateSizeCallback = ui_calculate_element_size;
    drawElement = ui_element_draw;
}

function UiElementAbsolutePositions() constructor {
    left = 0;
    right = 0;
    bottom = 0;
    right = 0;
}

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
    
    static draw = function() {
        if(struct_exists(self, "spriteIndex")) {
            var _col = c_white;
            var _alpha = 1;
            if(mouseIsOver) {
                _col = c_red;
            }
            draw_sprite_stretched_ext(self[$ "spriteIndex"], 0, left, top, right - left, bottom - top, _col, _alpha);
        }
    }
    
    ///@param {Struct.UIElement} _uiElement
    ///@param {real} _position
    static append = function(_uiElement, _position = undefined) {
        //First remove it from node its in.
        _uiElement.remove();
        
        var _childrenCount = flexpanel_node_get_num_children(flexNode);
        if(!is_real(_position)) {
            _position = _childrenCount;
        }
        if(_position < 0 || _position > _childrenCount) {
            throw $"Invalid position specified when appending child node: {_position}. Must be between 0 and {_childrenCount}";
        }
        
        flexpanel_node_insert_child(flexNode, _uiElement.flexNode, _position);
        ui_element_update_node_depth(_uiElement);
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
        
        if(!is_undefined(_parent)) {
           flexpanel_node_remove_child(_parent, flexNode);
            ui_element_update_node_depth(self);
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
        }
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
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static width = function(_width, _unit) {
        flexpanel_node_style_set_width(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static minWidth = function(_width, _unit) {
        flexpanel_node_style_set_min_width(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static maxwidth = function(_width, _unit) {
        flexpanel_node_style_set_max_width(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static height = function(_width, _unit) {
        flexpanel_node_style_set_height(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static minHeight = function(_width, _unit) {
        flexpanel_node_style_set_min_height(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _width
    ///@param {any} _unit flexpanel_unit
    static maxHeight = function(_width, _unit) {
        flexpanel_node_style_set_max_height(flexNode, _width, _unit);
        return self;
    }
    
    ///@param {real} _ratio // ratio of width to height
    static aspectRatio = function(_ratio) {
        flexpanel_node_style_set_aspect_ratio(flexNode, _ratio);
        return self;
    }
    
    ///@param {any} _edge
    ///@param {real} _value
    ///@param {any} _unit flexpanel_unit
    static position = function(_edge, _value, _unit ) {
        flexpanel_node_style_set_position(flexNode, _edge, _value, _unit);
        return self;
    }
    
    ///@param {any} _edge
    ///@param {any} _positionType flexpanel_position_type "relative" | "absolute" | "static"
    static positionType = function(_edge, _positionType ) {
        flexpanel_node_style_set_position_type(flexNode, _positionType);
        return self;
    }
    
    ///@param {any} _edge flexpanel_edge
    ///@param {real} _value
    static margin = function(_edge, _value) {
        flexpanel_node_style_set_margin(flexNode, _edge, _value);
        return self;
    }
    
    ///@param {any} _edge flexpanel_edge
    ///@param {real} _value
    static padding = function(_edge, _value) {
        flexpanel_node_style_set_padding(flexNode, _edge, _value);
        return self;
    }
    
    ///@param {any} _direction flexpanel_flex_direction
    static flexDirection = function(_direction) {
        flexpanel_node_style_set_flex_direction(flexNode, _direction);
    }
    
    ///@param {any} _wrap flexpanel_wrap
    static flexWrap = function(_wrap) {
        flexpanel_node_style_set_flex_wrap(flexNode, _wrap);
        return self;
    }
    
    ///@param {real} _value
    ///@param {any} _unit flexpanel_unit
    static flexBasis = function(_value, _unit) {
        flexpanel_node_style_set_flex_basis(flexNode, _value, _unit);
        return self;
    }
    
    ///@param {real} _value
    static flexGrow = function(_value) {
        flexpanel_node_style_set_flex_grow(flexNode, _value);
        return self;
    }
    
    ///@param {real} _value
    static flexShrink = function(_value, _unit) {
        flexpanel_node_style_set_flex_shrink(flexNode, _value);
        return self;
    }
    
    ///@param {any} _justify flexpanel_justify
    static justifyContent = function(_justify) {
        flexpanel_node_style_set_justify_content(flexNode, _justify);
        return self;
    }
    
    ///@param {any} _align flexpanel_align
    static alignItems = function(_align) {
        flexpanel_node_style_set_align_items(flexNode, _align);
        return self;
    }
    
    ///@param {any} _align flexpanel_align
    static alignSelf = function(_align) {
        flexpanel_node_style_set_align_self(flexNode, _align);
        return self;
    }
    
    ///@param {any} _justify flexpanel_justify
    static alignContent = function(_justify) {
        flexpanel_node_style_set_align_content(flexNode, _justify);
        return self;
    }
    
    ///@param {any} _display flexpanel_display "flex" | "none"
    static display = function(_display) {
        flexpanel_node_style_set_display(flexNode, _display);
        return self;
    }
    
    ///@param {string} _name
    static nodeName = function(_name) {
        flexpanel_node_set_name(flexNode, _name);
        return self;
    }
    
    static disposeFunc = function() {
        flexpanel_delete_node(flexNode);
        flexNode = undefined;
    }
    
}

///@description depth first node taversal. calls callback on all nodes
///@param {Struct.UIElement} _uiElement
///@param {function} _callback
///@param {bool} _includeRoot
function ui_element_foreach(_uiElement, _callback, _includeRoot = false) {
    if(_includeRoot) {
        _callback(_uiElement);
    }
    var _childLength = flexpanel_node_get_num_children(_uiElement.flexNode);
    for(var i = 0; i < _childLength; i += 1) {
        var _child = flexpanel_node_get_child(_uiElement.flexNode, i);
        var _childEl = flexpanel_node_get_data(_child);
        ui_element_foreach(_childEl, _callback, true);
    }
}

///@param {Struct.UIElement} _uiElement
///@param {function} _callback
///@param {bool} _includeRoot
function ui_element_foreach_parent(_uiElement, _callback, _includeRoot = false) {
    if(_includeRoot) {
        _callback(_uiElement);
    }
    var _parent = _uiElement.parent();
    if(!is_undefined(_parent)) {
        ui_element_foreach_parent(_parent, _callback, true);
    }
}

///@param {Struct.UIElement} _uiElement
function ui_element_update_node_depth(_uiElement) {

    var _parent = _uiElement.parent();
    if(is_undefined(_parent)) {
        _uiElement.nodeDepth = 0;
    } else {
        _uiElement.nodeDepth = _parent.nodeDepth + 1;
    }
    
    var _childCount = flexpanel_node_get_num_children(_uiElement.flexNode);
    for(var i = 0; i < _childCount; i += 1) {
        var _childNode = flexpanel_node_get_child(_uiElement.flexNode, i);
        var _childUIElement = flexpanel_node_get_data(_childNode);
        ui_element_update_node_depth(_childUIElement);
    }
}