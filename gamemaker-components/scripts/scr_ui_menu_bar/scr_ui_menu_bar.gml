function editor_ui_make_menubar() {
    var _menuBarContainer = new UIElement({
        name: "menuBarContainer",
        alignItems: "center",
        flexDirection: "row",
    });
    _menuBarContainer.spriteIndex = spr_bg_menubar;
    var _startContainer = new UIElement({
        name: "menuBarStartContainer",
        alignItems: "center",
        flexDirection: "row",
        padding: 16,
        gap: 8,
    });
    var _endContainer = new UIElement({
        name: "menuBarEndContainer",
        alignItems: "center",
        flexDirection: "row",
        justifyContent: "flex-end",
        padding: 16,
        gap: 8,
        flex: 1,
    });

    var _mainMenuButton = ui_make_button_text("Main Menu", function() {room_goto(rm_main_menu);}, "MainMenuButton");
    var _exitGameButton = ui_make_button_text("Exit Game", game_close_debug, "ExitGameButton");
    var _exitGameButtonTwo = ui_make_button_sprite(spr_icon_close, spr_menu_button_default, game_close_debug, 8, "ExitGameButtonTwo");

    _menuBarContainer.append(_startContainer, _endContainer);
    _startContainer.append(_mainMenuButton, _exitGameButton);
    _endContainer.append(_exitGameButtonTwo);

    return _menuBarContainer;
}