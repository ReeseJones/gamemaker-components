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

    var _makeButtonText = ui_make_button_sprite(spr_icon_buttons_text, spr_menu_button_default, action_editor_ui_make_button_text, 8, "MakeButtonText");
    var _makeButtonSprite = ui_make_button_sprite(spr_icon_buttons_alt, spr_menu_button_default, action_editor_ui_make_button_sprite, 8, "MakeButtonSprite");
    var _makeText = ui_make_button_sprite(spr_icon_insert_text, spr_menu_button_default, action_editor_ui_make_text, 8, "MakeText");
    var _makeTextInput = ui_make_button_sprite(spr_icon_terminal, spr_menu_button_default, action_editor_ui_make_text_input, 8, "MakeTextInput");
    var _makeElement = ui_make_button_sprite(spr_icon_responsive_layout, spr_menu_button_default, action_editor_ui_make_element, 8, "MakeElement");
    var _makeScroll = ui_make_button_sprite(spr_icon_list, spr_menu_button_default, action_editor_ui_make_scroll_panel, 8, "MakeScrollPanel");

    _elementCreationControlsPanel.append(_headerContainer, _buttonContainer);
    _buttonContainer.append(_makeButtonText, _makeButtonSprite, _makeText, _makeTextInput, _makeElement, _makeScroll);

    return _elementCreationControlsPanel;
}

function action_editor_ui_make_button_text() {
    
}

function action_editor_ui_make_button_sprite() {
    with(obj_ui_editor) {
        //TODO: Multipart ui elements need a ui element indicator for every element
        //TODO: UI Focus Indicators need to be positioned based on full dom hierarchy (not just inserted to the list view)
        var _newButton = ui_make_button_sprite(undefined, spr_menu_button_default, undefined, 8);
        focusedElement.append(_newButton);
        var _editorUiController = new EditorUiElementController(_newButton);
        uiElementListScrollContainer.append( _editorUiController.listViewElement );

    }
}

function action_editor_ui_make_text() {
    
}

function action_editor_ui_make_text_input() {
    
}

function action_editor_ui_make_element() {
    
}

function action_editor_ui_make_scroll_panel() {

}