function editor_ui_make_creation_controls() {

    var _elementCreationControlsPanel = new UIElement({
        flexDirection: "column",
    });

    var _headerContainer = new UIElement({
        flexDirection: "row",
        justifyContent: "center",
        alignItems: "stretch",
        padding: 8,
    });
    _headerContainer.spriteIndex = spr_bg_menu_panel;
    var _header = ui_make_text({
        font: font_ui_small,
        valign: fa_middle,
        halign: fa_center,
        text: "Create Element",
    });
    _headerContainer.append(_header);

    var _buttonContainer = new UIElement({
        flexDirection: "row",
        flexWrap: "wrap",
        gap: "8",
        padding: 8,
    });
    _buttonContainer.spriteIndex = spr_bg_menu_panel;
    
    var _placeHolder = function(){};

    var _makeButtonText = ui_make_button_sprite(spr_icon_buttons_text, spr_menu_button_default, _placeHolder, 8, "MakeButtonText");
    var _makeButtonSprite = ui_make_button_sprite(spr_icon_buttons_alt, spr_menu_button_default, _placeHolder, 8, "MakeButtonSprite");
    var _makeText = ui_make_button_sprite(spr_icon_insert_text, spr_menu_button_default, _placeHolder, 8, "MakeText");
    var _makeElement = ui_make_button_sprite(spr_icon_responsive_layout, spr_menu_button_default, _placeHolder, 8, "MakeElement");
    var _makeScroll = ui_make_button_sprite(spr_icon_list, spr_menu_button_default, _placeHolder, 8, "MakeScroll");

    _elementCreationControlsPanel.append(_headerContainer, _buttonContainer);
    _buttonContainer.append(_makeButtonText, _makeButtonSprite, _makeText, _makeElement, _makeScroll);

    return _elementCreationControlsPanel;
}