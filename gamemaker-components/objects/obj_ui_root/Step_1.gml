var _newWidth = window_get_width();
var _newHeight = window_get_height();

if(_newHeight != windowPreviousHeight || _newWidth != windowPreviousWidth) {
    // window size changed
    object_set_size(id, _newWidth, _newHeight);
}
windowPreviousHeight = _newHeight;
windowPreviousWidth = _newWidth;