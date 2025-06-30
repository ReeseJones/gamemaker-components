logger.log(LOG_LEVEL.INFORMATIONAL, $"Started Room: {room_get_name(room)}");
//At the start of every room make sure correct layers are there.
layerManager.updateLayers();
var _oldRoot = root;
root = new UIElement(rootElementStyle);
root.isConnected = true;
ui_element_destroy_tree(_oldRoot);


switch (room) {
    case rm_init: {
        
    } break;

    case rm_arena: {
        instance_create_depth(0, 0, 0, obj_arena_manager);
    } break;

    case rm_main_menu: {
        var _mainMenuButtons = main_menu_create();
        root.append(_mainMenuButtons);
    } break;

    case rm_splash: {
        layer_sequence_create("instances", room_width / 2, room_height / 2, sequence_game_splash);
    } break;

    case  rm_store: {
        
    } break;

    case  rm_ui_editor: {
        var _editorObj = instance_create_layer(0, 0, "instances", obj_ui_editor);
        root.append(_editorObj.root);
    } break;

    default:
        logger.logError(LOG_LEVEL.URGENT, $"Unknown room started! ${room}");
    break;
}

