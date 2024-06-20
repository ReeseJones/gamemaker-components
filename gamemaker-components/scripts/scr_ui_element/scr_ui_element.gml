enum ELEMENT_LAYOUT_TYPE {
    NONE = 0,
    MANUAL = 1,
    FLEX_HORIZONTAL = 2,
    FLEX_VERTICAL = 3
}
///@param {real} _width A width equal to or less than 1.0 is interpreted as a percentage of the parents size
// A number greater than or equal to 2 is interpreted as a gui pixel size
// Undefined means something else calculates size
// 0.0 - 1.0 | N >= 2 | undefined
///@param {real} _height
///@param {Struct.Box} _border
///@param {Struct.Box} _padding
///@param {Struct.Box} _position
function ElementSizeDescription(_width = undefined, _height = undefined, _border = new Box(), _padding = new Box(), _position = new Box() ) constructor {
    width = _width;
    height = _height;
    border = _border;
    padding = _padding;
    position = _position;
    layout = ELEMENT_LAYOUT_TYPE.MANUAL;
}

///@description The caculated sizes derived from the ElementSizeDescription
///@param {real} _width
///@param {real} _height
///@param {Struct.Box} _border
///@param {Struct.Box} _padding
///@param {Struct.Box} _position
function ElementSizeProperties(_width = undefined, _height = undefined, _border = new Box(), _padding = new Box(), _position = new Box() ) constructor {
    width = _width;
    height = _height;
    innerWidth = _width;
    innerHeight = _height;
    border = _border;
    padding = _padding;
    position = _position;
}

///@description DO NOT USE. Just for autocomplete.
function ElementProperties() : EventNode() constructor {
    sizeProperties = new ElementSizeDescription();
    calculatedSize = new ElementSizeProperties();
}
