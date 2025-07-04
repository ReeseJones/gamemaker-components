function dialog_initialize() {
    obj_game.dialogCallbacks = {};
}

///@param {string} _message A yes or no question
///@param {function} _callback When the user answers its provided to this callback.
function dialog_show_question(_message, _callback) {
    var _id = show_question_async(_message);
    obj_game.dialogCallbacks[$ _id] = _callback;
}

function dialog_handle_event() {
    var _id = async_load[? "id"];
    var _callback = obj_game.dialogCallbacks[$ _id];
    struct_remove(obj_game.dialogCallbacks, _id);
    var _status = async_load[? "status"];
    _callback(_status);
}