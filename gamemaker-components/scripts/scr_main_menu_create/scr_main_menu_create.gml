function main_menu_create() {
    var _root = new UIElement({
        flexDirection: "column",
        name: "MainMenuRoot",
        width: "100%",
        height: "100%",
        alignItems: "center",
        justifyContent: "center",
        padding: "8%",
    });
    
    var _buttonPanel = new UIElement({
        flexDirection: "column",
        name: "MainMenuButtonContainer",
        width: "35%",
        height: "80%",
        alignItems: "center",
        padding: "8%",
    });
    _buttonPanel.spriteIndex = spr_bg_panel_clear_1;
    
    var _startButton = new UIElement({
        name: "StartButton",
        width: "80%",
        height: "14%",
        alignItems: "center",
    });
    _startButton.spriteIndex = spr_bg_slate;
    _startButton.textDescription.font = font_ui_large;
    _startButton.textDescription.color = c_black;
    _startButton.textDescription.halign = fa_center;
    _startButton.textDescription.valign = fa_middle;
    event_add_listener(_startButton, EVENT_CLICKED, method(_startButton, function(_event) {
        show_debug_message("Start clicked");
        room_goto(rm_arena);
    }));
    
    _root.append(_buttonPanel);
    _buttonPanel.append(_startButton);
    
    _startButton.setText("Start");
    
    return _root;
}