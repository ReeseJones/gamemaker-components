function editor_ui_create() {
    var _layerId = 0; //layer_get_id("editor_ui_layer");

    var _editorUiRoot = instance_create_depth(0, 0, _layerId, obj_ui_element);
    var _editorMenubar = instance_create_depth(0, 0, _layerId, obj_ui_element);
    var _editorContentArea = instance_create_depth(0, 0, _layerId, obj_ui_element);
    var _editorMainPanel = instance_create_depth(0, 0, _layerId, obj_ui_element);
    var _editorMainPanelTitle = instance_create_depth(0, 0, _layerId, obj_ui_text);
    var _editorMainPanelContent = instance_create_depth(0, 0, _layerId, obj_ui_element);
    var _editorLevelView = instance_create_depth(0, 0, _layerId, obj_ui_element);
    var _editorSubpanel = instance_create_depth(0, 0, _layerId, obj_ui_element);
    var _editorSubpanelTitle = instance_create_depth(0, 0, _layerId, obj_ui_text);
    var _createMechEditorButton = instance_create_depth(0, 0, _layerId, obj_ui_text);

    _editorUiRoot.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _editorUiRoot.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _editorUiRoot.sizeProperties.collides = false;
    _editorUiRoot.nodeDepth = 1000;

    _editorMenubar.sizeProperties.height = 64;
    _editorMenubar.sprite_index = spr_button_blue;
    _editorMenubar.visible = true;
    _editorMenubar.image_blend = c_white;

    _editorContentArea.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_HORIZONTAL;
    _editorContentArea.sizeProperties.alignment = LAYOUT_ALIGNMENT.CENTER;
    _editorContentArea.sizeProperties.collides = false;

    _editorMainPanel.sizeProperties.width = 0.25;
    _editorMainPanel.sizeProperties.padding = new Box(16, 16, 16, 16);
    _editorMainPanel.sizeProperties.height = 0.8;
    _editorMainPanel.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _editorMainPanel.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _editorMainPanel.sprite_index = spr_bg_panel_clear_1;
    _editorMainPanel.visible = true;
    _editorMainPanel.image_blend = c_white;
    
    _editorMainPanelTitle.sizeProperties.padding = new Box(16, 16, 16, 16);
    _editorMainPanelTitle.textDescription.text = "Editor Main Panel but I have a lot of text you see. Good thing it wraps.";
    _editorMainPanelTitle.textDescription.halign = fa_left;
    _editorMainPanelTitle.textDescription.valign = fa_top;
    _editorMainPanelTitle.textDescription.color = c_black;
    _editorMainPanelTitle.sprite_index = spr_bg_panel_metal;
    _editorMainPanelTitle.visible = true;
    _editorMainPanelTitle.image_blend = c_white;

    _editorMainPanelContent.sizeProperties.padding = new Box(16, 16, 16, 16);
    _editorMainPanelContent.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _editorMainPanelContent.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _editorMainPanelContent.sprite_index = spr_bg_slate;
    _editorMainPanelContent.visible = true;
    _editorMainPanelContent.image_blend = c_white;

    _createMechEditorButton.textDescription.text = "Start Mech Editor";
    _createMechEditorButton.textDescription.halign = fa_center;
    _createMechEditorButton.textDescription.valign = fa_middle;
    _createMechEditorButton.textDescription.color = c_black;
    _createMechEditorButton.sprite_index = spr_bg_panel_metal;
    _createMechEditorButton.visible = true;
    _createMechEditorButton.image_blend = c_white;
    _createMechEditorButton.sizeProperties.padding = new Box(8, 8, 8, 8);
    event_add_listener(_createMechEditorButton, EVENT_CLICKED, function(_event) {
        show_debug_message("clicked mech edit button");
    });

    _editorLevelView.sizeProperties.height = 1
    _editorLevelView.sizeProperties.collides = false;

    _editorSubpanel.sizeProperties.width = 0.25;
    _editorSubpanel.sizeProperties.height = 0.8;
    _editorSubpanel.enableStencil = true;
    _editorSubpanel.sizeProperties.layout = ELEMENT_LAYOUT_TYPE.FLEX_VERTICAL;
    _editorSubpanel.sizeProperties.alignment = LAYOUT_ALIGNMENT.STRETCH;
    _editorSubpanel.sprite_index = spr_bg_panel_clear_1;
    _editorSubpanel.visible = true;
    _editorSubpanel.image_blend = c_blue;

    _editorSubpanelTitle.sizeProperties.padding = new Box(8, 8, 8, 8);
    _editorSubpanelTitle.textDescription.text = "Editor Subpanel";
    _editorSubpanelTitle.textDescription.halign = fa_center;
    _editorSubpanelTitle.textDescription.valign = fa_middle;
    _editorSubpanelTitle.textDescription.color = c_black;
    _editorSubpanelTitle.sprite_index = spr_bg_panel_metal;
    _editorSubpanelTitle.visible = true;
    _editorSubpanelTitle.image_blend = c_white;

    node_append_child(_editorUiRoot, _editorMenubar);
    node_append_child(_editorUiRoot, _editorContentArea);

    node_append_child(_editorContentArea, _editorMainPanel);
    node_append_child(_editorContentArea, _editorLevelView);
    node_append_child(_editorContentArea, _editorSubpanel);

    node_append_child(_editorMainPanel, _editorMainPanelTitle);
    node_append_child(_editorMainPanel, _editorMainPanelContent);
    
    node_append_child(_editorMainPanelContent, _createMechEditorButton);
    
    node_append_child(_editorSubpanel, _editorSubpanelTitle);
    
    var _componentDataProvider = global.gameContainer.get("mechComponentProvider");
    var _componentsMap = _componentDataProvider.componentMap;
    var _components = struct_get_values(_componentsMap);
    var _compCount = array_length(_components);
    
    
    for(var i = 0; i < _compCount; i += 1) {
        var _compData = _components[i];
    
        var _newButton = component_card_create(_compData);
        node_append_child(_editorSubpanel, _newButton);
    }

    /*
    node_foreach(_editorUiRoot, function(_node) {
         _node.depth = -_node.nodeDepth;
    }, true);
    */


    return {
         root: _editorUiRoot,
         menubar: _editorMenubar,
         mainPanel: _editorMainPanel,
         subPanel: _editorSubpanel
    };
}