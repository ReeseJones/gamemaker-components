logger.log(LOG_LEVEL.INFORMATIONAL, $"Started Room: {room_get_name(room)}");
ui_element_destroy_tree(root);
root = new UIElement(rootElementStyle);

switch (room) {
    case rm_init: {
        
    } break; 
    
    case rm_arena: {
        
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
    
    default:
        logger.logError(LOG_LEVEL.URGENT, $"Unknown room started! ${room}");
    break;
}

