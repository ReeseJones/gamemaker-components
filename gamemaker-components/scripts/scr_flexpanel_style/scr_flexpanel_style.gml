/*
struct_save_static(nameof(FlexpanelStyle), FlexpanelStyle);
///@param {string} _name Optional node name to help developers identify it.
///@param {struct} _data A mutatable struct that is reference shared. Modifications in this struct will be seen anywhere this nodes data is accsed.
///@param {real} _aspectRatio The aspect ratio that the node must maintain and corresponds to the horizontal axis. 1 -> square, 2 -> widthx2 height 0.5 -> width0.5 of height
///@param {any} _display flexpanel_display -> "flex" | "none"
///@param {any} _position flexpanel_position_type -> "relative" | "absolute" | "static"
///@param {any} _direction flexpanel_direction -> "ltr" | "rtl"
///@param {real} _marginLeft
///@param {real} _marginRight
///@param {real} _marginTop
///@param {real} _marginBottom
///@param {real} _paddingLeft
///@param {real} _paddingRight
///@param {real} _paddingTop
///@param {real} _paddingBottom
///@param {real} _gapRow
///@param {real} _gapColumn
///@param {any} _flexDirection flexpanel_flex_direction -> "column" | "row" | "column-reverse" | "row-reverse"
///@param {any} _flexWrap flexpanel_wrap -> "no-wrap" | "wrap" | "wrap-reverse"
///@param {real} _flexBasis Size requested for item before any shrink or grow is a applied.
///@param {real} _flexGrow
///@param {real} _flexShrink
///@param {any} _justifyContent Controls how the children are aligned along its main axis (i.e. the direction of flexDirection).
///@param {any} _alignSelf Controls how this child is aligned along its parents cross axis (direction perpendicular to flexDirection)
///@param {any} _alignContent Controls how wrapped content are distributed along the cross axis
///@param {any} _alignItems This controls how children are aligned along its cross axis (direction perpendicular to flexDirection)
///@param {real} _left
///@param {real} _right,
///@param {real} _top
///@param {real} _bottom
///@param {any} _width
///@param {any} _height
///@param {any} _minWidth
///@param {any} _minHeight
///@param {any} _maxWidth
///@param {any} _maxHeight
function FlexpanelStyle(
_name = "undefined",
_data = {},
_aspectRatio = undefined,
_display = flexpanel_display.flex,
_position = flexpanel_position_type.relative,
_direction = flexpanel_direction.LTR,
_marginLeft = 0,
_marginRight = 0,
_marginTop = 0,
_marginBottom = 0,
_paddingLeft = 0,
_paddingRight = 0,
_paddingTop = 0,
_paddingBottom = 0,
_gapRow = 0,
_gapColumn = 0,
_flexDirection = flexpanel_flex_direction.column,
_flexWrap = flexpanel_wrap.no_wrap,
_flexBasis = 0,
_flexGrow = 1,
_flexShrink = 1,
_justifyContent = flexpanel_justify.start,
_alignSelf = undefined,
_alignContent = flexpanel_justify.start,
_alignItems = flexpanel_align.stretch,
_left = undefined,
_right = undefined,
_top = undefined,
_bottom = undefined,
_width = "100%",
_height = "100%",
_minWidth = undefined,
_minHeight = undefined,
_maxWidth = undefined,
_maxHeight = undefined,
) constructor {
    name = _name;
    data = _data;
    aspectRatio = _aspectRatio;
    display = _display; //flexpanel_display
    
    position = _position; //flexpanel_position_type
    direction = _direction; //flexpanel_direction
    
    marginLeft = _marginLeft;
    marginRight = _marginRight;
    marginTop = _marginTop;
    marginBottom = _marginBottom;
    
    paddingLeft = _paddingLeft;
    paddingRight = _paddingRight;
    paddingTop = _paddingTop;
    paddingBottom = _paddingBottom;
    
    gapRow = _gapRow;
    gapColumn = _gapColumn;

    flexDirection = _flexDirection;
    flexWrap = _flexWrap; //flexpanel_wrap
    
    flexBasis = _flexBasis;
    flexGrow = _flexGrow;
    flexShrink = _flexShrink;
    justifyContent = _justifyContent;
    alignSelf = _alignSelf;
    alignContent = _alignContent;
    alignItems = _alignItems;
    
    left = _left;
    right = _right;
    top = _top;
    bottom = _bottom;
    
    width = _width;
    height = _height;
    minWidth = _minWidth;
    maxWidth = _maxWidth;
    minHeight = _minHeight;
    maxHeight = _maxHeight;
}
*/