event_inherited();
textDescription = new UiTextDescription();
postLayoutCallback = function() {
    if(!is_string(textDescription.text)) return;
    var _extraHeight = calculatedSize.border.top + calculatedSize.border.bottom + calculatedSize.padding.top + calculatedSize.padding.bottom;
    sizeProperties.height = string_height_ext(textDescription.text, textDescription.lineSpacing, calculatedSize.innerWidth) + _extraHeight;
};