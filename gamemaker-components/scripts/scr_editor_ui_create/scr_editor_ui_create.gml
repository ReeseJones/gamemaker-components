function editor_ui_create() {
    var _layerId = layer_get_id("editor_ui_layer");

    var _editorUiRoot = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorMenubar = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorContentArea = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorMainPanel = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorLevelView = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editorSubpanel = instance_create_layer(0, 0, _layerId, obj_ui_element);

    _editorUiRoot.sizeProperties.width = window_get_width();
    _editorUiRoot.sizeProperties.height = window_get_height();
    _editorUiRoot.sizeProperties.position.top = 0;
    _editorUiRoot.sizeProperties.position.left = 0;

    _editorMenubar.sizeProperties.width = 1;
    _editorMenubar.sizeProperties.height = 0.045;
    _editorMenubar.sizeProperties.position.top = 0;
    _editorMenubar.sizeProperties.position.left = 0;
    _editorMenubar.sprite_index = spr_button_blue;
    _editorMenubar.visible = true;
    _editorMenubar.image_blend = c_white;

    _editorContentArea.sizeProperties.width = 1;
    _editorContentArea.sizeProperties.height = 1 - _editorMenubar.sizeProperties.height;
    _editorContentArea.sizeProperties.position.top = 0.045;
    _editorContentArea.sizeProperties.position.left = 0.0;

    _editorMainPanel.sizeProperties.width = 0.25;
    _editorMainPanel.sizeProperties.height = 1;
    _editorMainPanel.sprite_index = spr_bg_panel_clear_1;
    _editorMainPanel.visible = true;
    _editorMainPanel.image_blend = c_white;
    _editorMainPanel.sizeProperties.position.top = 0;
    _editorMainPanel.sizeProperties.position.left = 0;

    _editorLevelView.sizeProperties.width = 0.5;
    _editorLevelView.sizeProperties.height = 1
    _editorLevelView.sizeProperties.position.top = 0;
    _editorLevelView.sizeProperties.position.left = 0.25;

    _editorSubpanel.sizeProperties.width = 0.25;
    _editorSubpanel.sizeProperties.height = 1
    _editorSubpanel.sprite_index = spr_bg_panel_clear_1;
    _editorSubpanel.visible = true;
    _editorSubpanel.image_blend = c_white;
    _editorSubpanel.sizeProperties.position.top = 0;
    _editorSubpanel.sizeProperties.position.left = 0.75;

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