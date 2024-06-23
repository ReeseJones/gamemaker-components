function editor_ui_create() {
    var _layerId = layer_get_id("editor_ui_layer");

    var _editorUiRoot = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorMenubar = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorContentArea = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorMainPanel = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorLevelView = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorSubpanel = instance_create_layer(0, 0, _layerId, obj_ui_element);

    _editorUiRoot.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _editorUiRoot.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;

    _editorMenubar.sizeProperties.height = 64;
    _editorMenubar.sprite_index = spr_button_blue;
    _editorMenubar.visible = true;
    _editorMenubar.image_blend = c_white;

    _editorContentArea.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL;
    _editorContentArea.sizeProperties.alignment = LAYOUT_ALIGNMENT.CENTER;

    _editorMainPanel.sizeProperties.width = 0.25;
    _editorMainPanel.sizeProperties.height = 0.8;
    _editorMainPanel.sprite_index = spr_bg_panel_clear_1;
    _editorMainPanel.visible = true;
    _editorMainPanel.image_blend = c_white;

    _editorLevelView.sizeProperties.height = 1

    _editorSubpanel.sizeProperties.width = 0.25;
    _editorSubpanel.sizeProperties.height = 0.5;
    _editorSubpanel.sprite_index = spr_bg_panel_clear_1;
    _editorSubpanel.visible = true;
    _editorSubpanel.image_blend = c_white;

    node_append_child(_editorUiRoot, _editorMenubar);
    node_append_child(_editorUiRoot, _editorContentArea);

    node_append_child(_editorContentArea, _editorMainPanel);
    node_append_child(_editorContentArea, _editorLevelView);
    node_append_child(_editorContentArea, _editorSubpanel);

    return {
         root: _editorUiRoot,
         menubar: _editorMenubar,
         mainPanel: _editorMainPanel,
         subPanel: _editorSubpanel
    };
}