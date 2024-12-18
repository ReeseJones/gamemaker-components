function make_test_ui() {
    var _editorUiRoot = new UIElement({
        flexDirection: "column",
        width: "100%",
        height: "100%",
        alignItems: "stretch",
        padding: 0,
        margin: 0,
    });
    var _editorMenubar = new UIElement({
        flexDirection: "row",
        width: "100%",
        alignItems: "stretch",
        height: 64,
        padding: 8,
        margin: 0,
    });
    var _editorContentArea = new UIElement({
        flexDirection: "row",
        width: "100%",
        alignItems: "stretch",
        flexGrow: 1,
        padding: 0,
        margin: 0,
    });
    var _editorMainPanel = new UIElement({
        flexDirection: "column",
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
        flexDirection: "row",
        alignItems: "stretch",
        height: 64,
        padding: 8,
        margin: 0,
    });
    var _editorMainPanelContent = new UIElement({
        flexDirection: "column",
        flexGrow: 1,
        padding: 8,
        margin: 0,
    });
    
    var _editorSubpanel = new UIElement({
        flexDirection: "column",
        width: "33%",
        height: "100%",
        position: "absolute",
        right: 0,
        top: 0,
        padding: 8,
        margin: 0,
    });
    var _editorSubpanelTitle = new UIElement({
        flexDirection: "row",
        alignItems: "stretch",
        height: 64,
        padding: 8,
        margin: 0,
    });
    var _editorSubpanelContent = new UIElement({
        flexDirection: "column",
        flexGrow: 1,
        padding: 8,
        margin: 0,
    });
    var _createMechEditorButton = new UIElement({
        flexDirection: "row",
        alignItems: "stretch",
        height: 64,
        padding: 8,
        margin: 0,
    });

    _editorUiRoot.interceptPointerEvents = false;

    _editorMenubar.spriteIndex = spr_button_blue;

    _editorContentArea.interceptPointerEvents = false;

    _editorMainPanel.spriteIndex = spr_bg_panel_clear_1;

    _editorMainPanelTitle.spriteIndex = spr_bg_panel_metal;

    _editorMainPanelContent.spriteIndex = spr_bg_slate;

    _createMechEditorButton.spriteIndex = spr_bg_panel_metal;

    _editorSubpanel.spriteIndex = spr_bg_panel_clear_1;

    _editorSubpanelTitle.spriteIndex = spr_bg_panel_metal;
    
    _editorSubpanelContent.spriteIndex = spr_bg_slate;

    _editorUiRoot.append(_editorMenubar);
    _editorUiRoot.append(_editorContentArea);

    _editorContentArea.append(_editorMainPanel);
    _editorContentArea.append(_editorSubpanel);

    _editorMainPanel.append(_editorMainPanelTitle);
    _editorMainPanel.append(_editorMainPanelContent);
    
    _editorMainPanelContent.append(_createMechEditorButton);
    _editorSubpanel.append(_editorSubpanelTitle);
    
    return _editorUiRoot;
}