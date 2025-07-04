
function game_ui_reset_root() {
    with(obj_game) {
        var _oldRoot = root;
        root = new UIElement({
            name: "root",
            width: "100%",
            height: "100%",
            flexDirection: "column",
        });
        // The root is always considered connected because it is how all other elements
        // derive the connected status. If a tree of elements is created but never attached to the 
        // root they will not appear connected.
        root.isConnected = true;
        // Focus indicates which UI element has focus
        // reset focus to root when whole ui is reset.
        focus = root;

        ui_element_destroy_tree(_oldRoot);
    }
}