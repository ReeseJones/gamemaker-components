///@param {Struct.MechComponentData} _mechComponentData
function component_card_create(_mechComponentData) {
    var _root = instance_create_depth(0, 0, 0, obj_ui_element);
    var _title = instance_create_depth(0, 0, 0, obj_ui_text);
    var _contentContainer = instance_create_depth(0, 0, 0, obj_ui_element);
    var _statContainer = instance_create_depth(0, 0, 0, obj_ui_element);
    var _graphicContainer = instance_create_depth(0, 0, 0, obj_ui_element);
    var _graphic = instance_create_depth(0, 0, 0, obj_ui_element);
    var _typeContainer = instance_create_depth(0, 0, 0, obj_ui_element);
    var _dimensionContainer = instance_create_depth(0, 0, 0, obj_ui_element);

    var _typeText = instance_create_depth(0, 0, 0, obj_ui_text);
    var _subtypeText = instance_create_depth(0, 0, 0, obj_ui_text);
    var _sizeText = instance_create_depth(0, 0, 0, obj_ui_text);
    var _socketsText = instance_create_depth(0, 0, 0, obj_ui_text);
    var _boxPadd = new Box(4, 8, 4, 8);

    node_append_child(_root, _title);
    node_append_child(_root, _contentContainer);
    _root.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _root.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _root.sizeProperties.width = 1;
    _root.sizeProperties.height = 200;
    _root.sprite_index = spr_bg_slate;
    _root.visible = true;

    _title.sizeProperties.padding = new Box(8, 8, 8, 8);
    _title.sizeProperties.height = undefined;
    _title.sizeProperties.width = 1;
    _title.sprite_index = spr_button_blue;
    _title.textDescription.text = _mechComponentData.displayName;
    _title.textDescription.color = c_white;
    _title.textDescription.font = font_ui_large;
    _title.textDescription.halign = fa_center;
    _title.textDescription.valign = fa_middle;

    node_append_child(_contentContainer, _statContainer);
    node_append_child(_contentContainer, _graphicContainer);
    _contentContainer.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL;
    _contentContainer.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _contentContainer.sizeProperties.width = 1;
    _contentContainer.sizeProperties.height = undefined;
    _contentContainer.visible = false;


    node_append_child(_statContainer, _typeContainer);
    node_append_child(_statContainer, _dimensionContainer);
    _statContainer.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _statContainer.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _statContainer.sizeProperties.width = 0.4;
    _statContainer.sizeProperties.height = 1;
    _statContainer.sprite_index = spr_bg_panel_clear_1;
    _statContainer.visible = false;

    node_append_child(_graphicContainer, _graphic);
    _graphicContainer.sizeProperties.height = 1;
    _graphicContainer.visible = true;
    _graphicContainer.sprite_index = spr_bg_panel_clear_1;

    _graphic.sprite_index = _mechComponentData.spriteIndex;
    _graphic.sizeProperties.width = _mechComponentData.width * 16;
    _graphic.sizeProperties.height = _mechComponentData.height * 16;
    _graphic.sizeProperties.position.top = 0.5;
    _graphic.sizeProperties.position.left = 0.5;
    _graphic.visible = true;


    node_append_child(_typeContainer, _typeText);
    node_append_child(_typeContainer, _subtypeText);
    _typeContainer.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _typeContainer.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _typeContainer.sizeProperties.width = 1;
    _typeContainer.visible = false;

    node_append_child(_dimensionContainer, _sizeText);
    node_append_child(_dimensionContainer, _socketsText);
    _dimensionContainer.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _dimensionContainer.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _dimensionContainer.sizeProperties.width = 1;
    _dimensionContainer.visible = false;
    
    _typeText.textDescription.text = $"{_mechComponentData.type}";
    _typeText.textDescription.color = c_white;
    _typeText.textDescription.font = font_ui_small;
    _typeText.textDescription.halign = fa_left;
    _typeText.textDescription.valign = fa_middle;
    _typeText.sprite_index = spr_bg_slate;
    _typeText.sizeProperties.padding = _boxPadd;
    _subtypeText.textDescription.text = $"{_mechComponentData.subtype}";
    _subtypeText.textDescription.color = c_white;
    _subtypeText.textDescription.font = font_ui_small;
    _subtypeText.textDescription.halign = fa_left;
    _subtypeText.textDescription.valign = fa_middle;
    _subtypeText.sprite_index = spr_bg_slate;
    _subtypeText.sizeProperties.padding = _boxPadd;
    _sizeText.textDescription.text = $"Size: {_mechComponentData.width} x {_mechComponentData.height}";
    _sizeText.textDescription.color = c_white;
    _sizeText.textDescription.font = font_ui_small;
    _sizeText.sprite_index = spr_bg_slate;
    _sizeText.textDescription.halign = fa_left;
    _sizeText.textDescription.valign = fa_middle;
    _sizeText.sizeProperties.padding = _boxPadd;
    _socketsText.textDescription.text = $"Sockets: {array_length(_mechComponentData.socketPositions)}";
    _socketsText.textDescription.color = c_white;
    _socketsText.textDescription.font = font_ui_small;
    _socketsText.sprite_index = spr_bg_slate;
    _socketsText.textDescription.halign = fa_left;
    _socketsText.textDescription.valign = fa_middle;
    _socketsText.sizeProperties.padding = _boxPadd;

    return _root
}