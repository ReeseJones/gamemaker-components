
function DrawState() constructor {
    alpha = 0;
    color = c_black;
    font = undefined;
    halign = undefined;
    valign = undefined;
}

global.drawStateStack = [];

/// @return {Struct.DrawState}
function draw_get_state() {
    var _state = new DrawState();

    _state.alpha = draw_get_alpha();
    _state.color = draw_get_color();
    _state.font = draw_get_font();
    _state.halign = draw_get_halign();
    _state.valign = draw_get_valign();

    return _state;
}

/// @param {Struct.DrawState} _state
function draw_state_apply(_state) {
    draw_set_alpha(_state.alpha);
    draw_set_color(_state.color);
    draw_set_font(_state.font);
    draw_set_halign(_state.halign);
    draw_set_valign(_state.valign);
}

function draw_state_push() {
    array_push(global.drawStateStack, draw_get_state());
}

function draw_state_pop() {
    var _state = array_pop(global.drawStateStack);
    if(_state != undefined) {
        draw_state_apply(_state);
    }
}