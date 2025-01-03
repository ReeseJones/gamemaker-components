function make_test_ui() {
    var _editorUiRoot = new UIElement({
        flexDirection: "column",
        name: "EditorUIRoot",
        width: "100%",
        height: "100%",
        alignItems: "stretch",
        padding: 0,
        margin: 0,
    });
    var _editorMenubar = new UIElement({
        name: "EditorMenuBar",
        flexDirection: "row",
        width: "100%",
        alignItems: "stretch",
        height: 64,
        padding: 8,
        margin: 0,
    });
    var _editorContentArea = new UIElement({
        name: "EditorContentArea",
        flexDirection: "row",
        width: "100%",
        alignItems: "stretch",
        flexGrow: 1,
        padding: 0,
        margin: 0,
    });
    var _editorMainPanel = new UIElement({
        flexDirection: "column",
        name: "Main Panel",
        width: "33%",
        height: "100%",
        position: "absolute",
        alignItems: "stretch",
        left: 0,
        top: 0,
        padding: 8,
        margin: 0,
    });
    var _editorMainPanelTitle = new UIElement({
        name: "Main Panel Title",
        flexDirection: "row",
        alignItems: "stretch",
        height: 64,
        padding: 8,
        margin: 0,
    });
    var _editorMainPanelContent = new UIElement({
        name: "Main Panel Content",
        flexDirection: "column",
        flexGrow: 1,
        padding: 8,
        margin: 0,
    });
    
    var _editorSubpanel = new UIElement({
        name: "Sub Panel",
        flexDirection: "column",
        width: "33%",
        height: "100%",
        position: "absolute",
        right: 0,
        top: 0,
        padding: 32,
        margin: 0,
    });
    var _editorSubpanelTitle = new UIElement({
        name: "Sub Panel Title",
        flexDirection: "row",
        alignItems: "stretch",
        height: 500,
        padding: 8,
        margin: 0,
    });
    var _editorSubpanelContent = new UIElement({
        name: "Sub Panel Content",
        flexDirection: "column",
        flexGrow: 1,
        padding: 8,
        margin: 0,
    });
    var _createMechEditorButton = new UIElement({
        name: "Create button",
        flexDirection: "row",
        alignItems: "stretch",
        height: 64,
        padding: 8,
        margin: 0,
    });
    
    var _scrollPanel = new UIScrollContainer({
        name: "ScrollPanel",
        flexGrow: 1
    });
    
    var _scrollPanelNested = new UIScrollContainer({
        name: "ScrollPanelNested",
        flexGrow: 1
    });

    _editorUiRoot.interceptPointerEvents = false;
    _editorMenubar.spriteIndex = spr_button_blue;
    
    _editorMenubar.textDescription.valign = fa_middle;
    _editorMenubar.textDescription.halign = fa_left;
    
    _editorContentArea.interceptPointerEvents = false;
    _editorMainPanel.spriteIndex = spr_bg_panel_clear_1;
    _editorMainPanelTitle.spriteIndex = spr_bg_panel_metal;
    _editorMainPanelContent.spriteIndex = spr_bg_slate;
    _createMechEditorButton.spriteIndex = spr_bg_panel_metal;
    _editorSubpanel.spriteIndex = spr_bg_panel_clear_1;
    _editorSubpanelTitle.spriteIndex = spr_bg_panel_metal;
    _editorSubpanelContent.spriteIndex = spr_bg_slate;

    _editorUiRoot.append(_editorMenubar, _editorContentArea);
    _editorContentArea.append(_editorMainPanel, _editorSubpanel);
    _editorMainPanel.append(_editorMainPanelTitle, _editorMainPanelContent);
    _editorMainPanelContent.append(_createMechEditorButton);
    
    _editorSubpanel.append(_editorSubpanelTitle, _scrollPanel);
    //_editorSubpanel.append(_scrollPanel);
    
    var _leeroy = undefined;
    
    for(var i = 0; i < 4; i += 1) {
        var _tempEl = new UIElement({
            name: $"Filler List Item: {i}",
            flexDirection: "row",
            alignItems: "stretch",
            height: 500,
            padding: 8,
            margin: 0,
        });
        _tempEl.spriteIndex = spr_bg_panel_metal;
        _scrollPanel.contentContainer.append(_tempEl);
        _leeroy = _tempEl;
    }
    
    for(var i = 0; i < 4; i += 1) {
        var _tempEl = new UIElement({
            name: $"Filler List Item: {i}",
            flexDirection: "row",
            alignItems: "stretch",
            height: 500,
            padding: 8,
            margin: 0,
        });
        _tempEl.spriteIndex = spr_bg_panel_metal;
        _scrollPanelNested.contentContainer.append(_tempEl);
    }
    
    _leeroy.append(_scrollPanelNested);
    
    
    _editorMenubar.setText("Mech Game", false);
    _editorMainPanelTitle.setText("Main Panel");
    _editorMainPanelTitle.textDescription.valign = fa_middle;
    _editorMainPanelTitle.textDescription.halign = fa_center;
    _editorMainPanelTitle.textDescription.color = c_black;
    _editorMainPanelTitle.textDescription.font = font_ui_large;
    _editorSubpanelTitle.setText("Subpanel");
    _editorSubpanelTitle.textDescription.valign = fa_middle;
    _editorSubpanelTitle.textDescription.halign = fa_center;
    _editorSubpanelTitle.textDescription.color = c_black;
    _editorSubpanelTitle.textDescription.font = font_ui_large;
    
    return _editorUiRoot;
}