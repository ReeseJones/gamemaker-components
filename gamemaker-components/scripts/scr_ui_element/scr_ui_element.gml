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



function UIElement() : EventNode() constructor {
    flexNode = flexpanel_create_node({
        data: self,
        flex: 1,
        flexDirection: flexpanel_flex_direction.column,
    });
    isDraggable = false;
    isClickable = false;
    mouseIsOver = false;
    nodeDepth = 0;
    
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
    
    static remove = function() {
        var _parent = flexpanel_node_get_parent(flexNode);
        
        if(!is_undefined(_parent)) {
           flexpanel_node_remove_child(_parent, flexNode);
            ui_element_update_node_depth(self);
        }
    }
    
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
    
    static isConnected = function() {
        return flexpanel_node_get_parent(flexNode) != undefined;
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