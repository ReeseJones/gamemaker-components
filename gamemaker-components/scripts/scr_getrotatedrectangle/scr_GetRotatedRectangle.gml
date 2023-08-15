tag_script(rect_get_rotated, [TAG_MATH, TAG_GEOMETRY])
function rect_get_rotated(_x, _y, _halfWidth, _halfHeight, _angleDeg) {
    var _rads = degtorad(-_angleDeg);
    var c = cos(_rads);
    var s = sin(_rads);

    var _tl = {x: -_halfWidth, y: _halfHeight};
    var _tr = {x: _halfWidth, y: _halfHeight};
    var _bl = {x: -_halfWidth, y: -_halfHeight};
    var _br = {x: _halfWidth, y: -_halfHeight};
   
    var _xx = _tl.x * c - _tl.y * s;
    var _yy = _tl.x * s + _tl.y * c;
    _tl.x = _x + _xx;
    _tl.y = _y +_yy;
    
    _xx = _tr.x * c - _tr.y * s;
    _yy = _tr.x * s + _tr.y * c;
    _tr.x = _x + _xx;
    _tr.y = _y +_yy;
    
    _xx = _bl.x * c - _bl.y * s;
    _yy = _bl.x * s + _bl.y * c;
    _bl.x = _x + _xx;
    _bl.y = _y +_yy;
    
    _xx = _br.x * c - _br.y * s;
    _yy = _br.x * s + _br.y * c;
    _br.x = _x + _xx;
    _br.y = _y +_yy;

    return {
        tl: _tl,
        tr: _tr,
        bl: _bl,
        br: _br
    };
}


function rect_draw_bbox(_bbox) {
    draw_line(_bbox.tl.x, _bbox.tl.y, _bbox.tr.x, _bbox.tr.y);
    draw_line(_bbox.tr.x, _bbox.tr.y, _bbox.br.x, _bbox.br.y);
    draw_line(_bbox.br.x, _bbox.br.y, _bbox.bl.x, _bbox.bl.y);
    draw_line(_bbox.bl.x, _bbox.bl.y, _bbox.tl.x, _bbox.tl.y);
}