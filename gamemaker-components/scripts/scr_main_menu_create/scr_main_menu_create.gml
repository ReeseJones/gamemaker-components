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
    
    var _startButton = new UIButton({
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
        ui_focus(self);
        room_goto(rm_arena);
    }));
    
    var _startUiEditor = new UIButton({
        name: "Start Ui Editor",
        width: "80%",
        height: "14%",
        alignItems: "center",
    });
    _startUiEditor.spriteIndex = spr_bg_slate;
    _startUiEditor.textDescription.font = font_ui_large;
    _startUiEditor.textDescription.color = c_black;
    _startUiEditor.textDescription.halign = fa_center;
    _startUiEditor.textDescription.valign = fa_middle;
    event_add_listener(_startUiEditor, EVENT_CLICKED, method(_startUiEditor, function(_event) {
        show_debug_message("Start Ui Editor Clicked");
        ui_focus(self);
        room_goto(rm_ui_editor);
    }));

    var _textInputTest = new UITextInput({
        name: "UITextInput",
        width: "80%",
        height: "14%",
        alignItems: "center",
    });
    _textInputTest.spriteIndex = spr_bg_slate;
    _textInputTest.textDescription.font = font_ui_large;
    _textInputTest.textDescription.color = c_black;
    _textInputTest.textDescription.halign = fa_center;
    _textInputTest.textDescription.valign = fa_middle;
    event_add_listener(_textInputTest, EVENT_CLICKED, method(_textInputTest, function(_event) {
        show_debug_message("UITextInput clicked");
        ui_focus(self);
    }));

    _root.append(_buttonPanel);
    _buttonPanel.append(_startButton);
    _buttonPanel.append(_startUiEditor);
    _buttonPanel.append(_textInputTest);

    _startButton.setText("Start");
    _startUiEditor.setText("UI Editor");

    return _root;
}