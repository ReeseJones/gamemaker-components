function editor_ui_create() {
    var _layerId = layer_get_id("editor_ui_layer");

    var _editor_ui_root = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editor_menubar = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editor_content_area = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editor_mainpanel = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editor_level_view = instance_create_layer(0, 0, _layerId, obj_ui_element);
    var _editor_subpanel = instance_create_layer(0, 0, _layerId, obj_ui_element);

    _editor_ui_root.sizeProperties.width = window_get_width();
    _editor_ui_root.sizeProperties.height = window_get_height();
    _editor_ui_root.sizeProperties.position.top = 0;
    _editor_ui_root.sizeProperties.position.left = 0;

    _editor_menubar.sizeProperties.width = 1;
    _editor_menubar.sizeProperties.height = 0.045;
    _editor_menubar.sizeProperties.position.top = 0;
    _editor_menubar.sizeProperties.position.left = 0;
    _editor_menubar.sprite_index = spr_button_blue;
    _editor_menubar.visible = true;
    _editor_menubar.image_blend = c_white;

    _editor_content_area.sizeProperties.width = 1;
    _editor_content_area.sizeProperties.height = 1 - _editor_menubar.sizeProperties.height;
    _editor_content_area.sizeProperties.position.top = 0.045;
    _editor_content_area.sizeProperties.position.left = 0.0;

    _editor_mainpanel.sizeProperties.width = 0.25;
    _editor_mainpanel.sizeProperties.height = 1;
    _editor_mainpanel.sprite_index = spr_bg_panel_clear_1;
    _editor_mainpanel.visible = true;
    _editor_mainpanel.image_blend = c_white;
    _editor_mainpanel.sizeProperties.position.top = 0;
    _editor_mainpanel.sizeProperties.position.left = 0;

    _editor_level_view.sizeProperties.width = 0.5;
    _editor_level_view.sizeProperties.height = 1
    _editor_level_view.sizeProperties.position.top = 0;
    _editor_level_view.sizeProperties.position.left = 0.25;

    _editor_subpanel.sizeProperties.width = 0.25;
    _editor_subpanel.sizeProperties.height = 1
    _editor_subpanel.sprite_index = spr_bg_panel_clear_1;
    _editor_subpanel.visible = true;
    _editor_subpanel.image_blend = c_white;
    _editor_subpanel.sizeProperties.position.top = 0;
    _editor_subpanel.sizeProperties.position.left = 0.75;

    node_append_child(_editor_ui_root, _editor_menubar);
    node_append_child(_editor_ui_root, _editor_content_area);

    node_append_child(_editor_content_area, _editor_mainpanel);
    node_append_child(_editor_content_area, _editor_level_view);
    node_append_child(_editor_content_area, _editor_subpanel);

    return {
         root: _editor_ui_root,
         menubar: _editor_menubar,
         mainPanel: _editor_mainpanel,
         subPanel: _editor_subpanel
    };
}