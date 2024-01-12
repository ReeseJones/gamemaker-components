enum FLEX_DIRECTION {
    ROW,
    COLUMN,
}


enum OVERFLOW_TYPE {
    VISIBLE,
    HIDDEN,
    SCROLL,
}

enum LAYOUT_TYPE {
    NONE,
    FLEX,
    STACK,
    FIT_CONTENT,
}

enum FIT_CONTENT_TYPE {
    WIDTH,
    HEIGHT,
    BOTH,
}

///@param {Struct.EventNode} _uiRoot
function ui_calculate_layout(_uiRoot) {

    _uiRoot.width = display_get_gui_width();
    _uiRoot.height = display_get_gui_height();

    ui_calculate_layout_helper(_uiRoot);
}

///@param {Struct.EventNode} _node
function ui_calculate_layout_helper(_node) {
    //calculate my size

    if( is_real(_node.width) ) {
        _node.calculatedWidth = _node.width >= -1 &&_node.width <= 1
            ? _node.width * _node.parentNode.calculatedWidth
            : _node.width;
    }

    if( is_real(_node.height) ) {
        _node.calculatedHeight = _node.height >= -1 &&_node.height <= 1
            ? _node.height * _node.parentNode.calculatedHeight
            : _node.height;
    }
    
    var _childrenCount = array_length(_node.childNodes); 
    for(var _i = 0; _i < _childrenCount; _i += 1) {
        var _childNode = _node.childNodes[_i];
        ui_calculate_layout_helper(_childNode);
    }


    //size dynamic children
}

function ui_element_calculate_fixed_sizes() {
    
}





// Ratio Sizing - 100% or 50% of container
// fixed sizing - 300px;
// content sizing - as big as content // text for example
    // max width
    // max height
// sized by parent:
/*
    panel:
        width = 0.3; // 30% of parent
        height = 1.0; // 100% of parent
        overflow: VISIBLE
        layout: FLEX
        flexDirection: COULMN
        display: box

    Header:
        width = 1.0;
        height = 0.2;
        overflow = VISIBLE
        layout: NONE
        flexType: static
        flex = 0.2 // Reserves 1/5th of flex container
        display: controlled by flex

    ContentContainer:
        width: 1.0
        height: 1.0
        layout: STACK
        overflow: SCROLL
        flexType: grow
        flex: 1.0 // shares rest of flex
        display: controlled by flex

     WeaponDataContainer:
        width: 1.0
        height: 1.0
        overflow: VISIBLE
        layout: FLEX
        flexType: static
        flex: 1
        display: controlled by content
        fitMode: Height //width | Height | Both

      Weapon Header Row:
        width: 1.0
        height: 1.0
        overflow: visible
        layout: Flex
        flexDirection: ROW
        flexType: static
        flex: 1
        display: width controlled by width, height controlled by content
        fitMode: Height

     WeaponIcon: // Sizes to container. Maintain aspect ratio?

     Weapon Name:// size driven by content

     Weapon Stats:


*/