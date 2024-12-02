function DisplayInfo() constructor {
    width = 0;
    height = 0;
    orientation = display_landscape;
    dpiX = 0;
    dpiY = 0;
    frequency = 0;
}

///@returns {Struct.DisplayInfo}
function display_get_info() {
    var _displayInfo = new DisplayInfo();

    _displayInfo.dpiX = display_get_dpi_x();
    _displayInfo.dpiY = display_get_dpi_y();
    _displayInfo.frequency = display_get_frequency();
    _displayInfo.width = display_get_width();
    _displayInfo.height = display_get_height();
    _displayInfo.orientation = display_get_orientation();

    return _displayInfo;
}