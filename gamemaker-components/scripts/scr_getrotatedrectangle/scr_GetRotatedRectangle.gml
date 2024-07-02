tag_script(rect_get_rotated, [TAG_MATH, TAG_GEOMETRY])
function rect_get_rotated(_x, _y, _halfWidth, _halfHeight, _angleDeg) {
    var _rads = degtorad(-_angleDeg);
    var _c = cos(_rads);
    var _s = sin(_rads);

    var _tl = {x: -_halfWidth, y: _halfHeight};
    var _tr = {x: _halfWidth, y: _halfHeight};
    var _bl = {x: -_halfWidth, y: -_halfHeight};
    var _br = {x: _halfWidth, y: -_halfHeight};

    var _xx = _tl.x * _c - _tl.y * _s;
    var _yy = _tl.x * _s + _tl.y * _c;
    _tl.x = _x + _xx;
    _tl.y = _y +_yy;
    
    _xx = _tr.x * _c - _tr.y * _s;
    _yy = _tr.x * _s + _tr.y * _c;
    _tr.x = _x + _xx;
    _tr.y = _y +_yy;

    _xx = _bl.x * _c - _bl.y * _s;
    _yy = _bl.x * _s + _bl.y * _c;
    _bl.x = _x + _xx;
    _bl.y = _y +_yy;

    _xx = _br.x * _c - _br.y * _s;
    _yy = _br.x * _s + _br.y * _c;
    _br.x = _x + _xx;
    _br.y = _y +_yy;

    var _bbox = {
        tl: _tl,
        tr: _tr,
        bl: _bl,
        br: _br
    };

    return _bbox;
}


function rect_draw_bbox(_bbox) {
    draw_line(_bbox.tl.x, _bbox.tl.y, _bbox.tr.x, _bbox.tr.y);
    draw_line(_bbox.tr.x, _bbox.tr.y, _bbox.br.x, _bbox.br.y);
    draw_line(_bbox.br.x, _bbox.br.y, _bbox.bl.x, _bbox.bl.y);
    draw_line(_bbox.bl.x, _bbox.bl.y, _bbox.tl.x, _bbox.tl.y);
}