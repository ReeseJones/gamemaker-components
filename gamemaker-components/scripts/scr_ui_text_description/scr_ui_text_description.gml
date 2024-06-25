struct_save_static(nameof(UiTextDescription), UiTextDescription);
function UiTextDescription() constructor {
    text = "default";
    lineSpacing = TEXT_DEFAULT_LINE_HEIGHT;
    isSelectable = true;
    halign = fa_left;
    valign = fa_top;
    //TODO: ADD FONT SERIALIZE TYPE
    font = font_console;
    alpha = 1;
    color = c_white;
}