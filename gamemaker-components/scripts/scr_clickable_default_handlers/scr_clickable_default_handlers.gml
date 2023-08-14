function clickable_on_mouse_over() {
    show_debug_message($"moused over {id}");
}

function clickable_on_mouse_out() {
    show_debug_message($"moused out {id}");
}

/// @function clickable_on_pressed
/// @description default handler for mouse button pressed
/// @param {Constant.MouseButton}    _button
function clickable_on_pressed(_button) {
    show_debug_message($"mouse button {_button} pressed {id}");
}

/// @function clickable_on_released
/// @description default handler for mouse button released
/// @param {Constant.MouseButton}    _button
function clickable_on_released(_button) {
    show_debug_message($"mouse button {_button} released {id}");
}

/// @function clickable_on_clicked
/// @description default handler for mouse button clicked
/// @param {Constant.MouseButton}    _button
function clickable_on_clicked(_button) {
    show_debug_message($"mouse button {_button} clicked {id}");
}

/// @function clickable_on_drag_start
/// @description default handler for drag start
function clickable_on_drag_start() {
    show_debug_message($"drag from {id} started");
}

/// @function clickable_on_drag_abort
/// @description default handler for when a drag is aborted
function clickable_on_drag_abort() {
    show_debug_message($"drag from {id} aborted");
}

/// @function clickable_on_drag_end
/// @description default handler for when a drag ends
/// @param {Id.Instance}    _dropTarget
function clickable_on_drag_end(_dropTarget) {
    show_debug_message($"drag from {id} finished on {_dropTarget}");
}

/// @function clickable_on_drop_target_change
/// @description default handler for when a drop target chagnes.
/// @param {Id.Instance}    _dropTarget
function clickable_on_drop_target_change(_dropTarget) {
    show_debug_message($"New drop target: {_dropTarget}");
}
