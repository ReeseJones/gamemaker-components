struct_save_static(nameof(UiTextDescription), UiTextDescription);
///@param {string} _text
function UiTextDescription(_text = undefined) constructor {
    text = _text;
    lineSpacing = TEXT_DEFAULT_LINE_HEIGHT;
    isSelectable = true;
    halign = fa_left;
    valign = fa_top;
    //TODO: ADD FONT SERIALIZE TYPE
    font = font_console;
    alpha = 1;
    color = c_white;
}