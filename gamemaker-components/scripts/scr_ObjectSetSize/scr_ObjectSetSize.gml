/// @function object_set_size
/// @param {Id.Instance}        _inst
/// @param {Real}               _xWidth
/// @param {Real}               _yWidth
/// @param {Asset.GMSprite}     _maskSpr
function object_set_size(_inst, _xWidth, _yWidth, _maskSpr = undefined) {
    with(_inst) {
        if(_maskSpr != undefined) {
            mask_index = _maskSpr;
        }

        if(mask_index < 0) {
            throw "Cannot set size of object with no mask";
        }

        image_xscale = _xWidth / sprite_get_width(mask_index);
        image_yscale = _yWidth / sprite_get_width(mask_index);
    }
}