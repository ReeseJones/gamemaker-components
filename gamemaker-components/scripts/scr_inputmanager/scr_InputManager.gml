enum DEVICE_INDEX {
    MOUSE_AND_KEYBOARD = -1,
    //The rest are gamepads 0 to n
    GAMPEPAD0 = 0,
    GAMPEPAD1 = 1,
    GAMPEPAD2 = 2,
    GAMPEPAD3 = 3,
    GAMPEPAD4 = 4,
    GAMPEPAD5 = 5,
    GAMPEPAD6 = 6,
    GAMPEPAD7 = 7,
    GAMPEPAD8 = 8,
    GAMPEPAD9 = 9
}

enum INPUT_TYPE {
    MOUSE_AND_KEYBOARD,
    GAMEPAD
}

enum BINDING_TYPE {
    KEYBOARD_KEY,
    MOUSE_BUTTON,
    MOUSE_WHEEL,
    GAMEPAD_BUTTON,
    GAMEPAD_AXIS
}

enum MOUSE_WHEEL_DIRECTION {
    UP,
    DOWN
}

enum BUTTON_PRESS_TYPE {
    HELD,
    PRESS,
    RELEASE
}

enum ACTION_INPUT {
    MOVE_UP,
    MOVE_DOWN,
    MOVE_LEFT,
    MOVE_RIGHT,
    MOVE_HORIZONTAL,
    MOVE_VERTICAL,
    SHOOT,
    SHOOT_SECONDARY,
    THROW_GRENADE,
    JUMP,
    USE_EQUIPMENT,
    TOGGLE_INVENTORY,
    PAUSE,
    NEXT_WEAPON,
    PREVIOUS_WEAPON,
    CROUCH,
    LOOK_VERTICAL,
    LOOK_HORIZONTAL,
    ACTIONS_COUNT,
}

//TODO CONVERT FROM ARRAYS TO STRUCTS

function InputManager(_inputDeviceManager) constructor {
    keyboardCheckMethod = (os_type == os_windows) ? keyboard_check_direct : keyboard_check;
    inputDeviceManager = _inputDeviceManager;

    bindings = []
    bindings[INPUT_TYPE.MOUSE_AND_KEYBOARD] = [];
    bindings[INPUT_TYPE.GAMEPAD] = [];

    functionsMap = [];
    functionsMap[BUTTON_PRESS_TYPE.HELD] = [];
    functionsMap[BUTTON_PRESS_TYPE.PRESS] = [];
    functionsMap[BUTTON_PRESS_TYPE.RELEASE] = [];

/// @function        getInputTypeFromDeviceIndex(_deviceIndex)
/// @param {Real}    _deviceIndex
/// @return {Real}
    static getInputTypeFromDeviceIndex = function get_input_type_from_device_index(_deviceIndex) {
        return _deviceIndex == DEVICE_INDEX.MOUSE_AND_KEYBOARD 
        ? INPUT_TYPE.MOUSE_AND_KEYBOARD
        : INPUT_TYPE.GAMEPAD;
    }

    static checkPressed = function check_pressed(_deviceIndex, _actionInput) {
        var _inputType = getInputTypeFromDeviceIndex(_deviceIndex)
        var _actionInputMap = bindings[_inputType];
        var _actionSetting = _actionInputMap[_actionInput];
        var _checkMethod = functionsMap[BUTTON_PRESS_TYPE.PRESS][_actionSetting.type];
        return _checkMethod(_deviceIndex, _actionSetting.value);
    }
    
    static checkReleased = function check_released(_deviceIndex, _actionInput) {
        var _inputType = getInputTypeFromDeviceIndex(_deviceIndex)
        var _actionInputMap = bindings[_inputType];
        var _actionSetting = _actionInputMap[_actionInput];
        var _checkMethod = functionsMap[BUTTON_PRESS_TYPE.RELEASE][_actionSetting.type];
        return _checkMethod(_deviceIndex, _actionSetting.value);
    }
    
    static checkHeld = function check_held(_deviceIndex, _actionInput) {
        var _inputType = getInputTypeFromDeviceIndex(_deviceIndex)
        var _actionInputMap = bindings[_inputType];
        var _actionSetting = _actionInputMap[_actionInput];
        var _checkMethod = functionsMap[BUTTON_PRESS_TYPE.HELD][_actionSetting.type];
        return _checkMethod(_deviceIndex, _actionSetting.value);
    }
    
    static readAxis = function read_axis(_deviceIndex, _actionInput) {
        var _inputType = getInputTypeFromDeviceIndex(_deviceIndex)
        var _actionInputMap = bindings[_inputType];
        var _actionSetting = _actionInputMap[_actionInput];
        return gamepad_axis_value(_deviceIndex, _actionSetting.value);
    }

/// @function        checkAllDeviceInput()
/// @return {Real OR Undefined} return the DEVICE_INDEX from which input was detected first.
    static checkAllDeviceInput = function check_all_device_input() {
        var _devices = inputDeviceManager.getAllDevices();
        var _deviceCount = array_length(_devices);
        for(var i = 0; i < _deviceCount; i += 1) {
            var _deviceIndex = _devices[i];
            
            if(_deviceIndex == DEVICE_INDEX.MOUSE_AND_KEYBOARD) {
                if(keyboard_check_pressed(vk_anykey)
                || device_mouse_check_button_pressed(0, mb_any)) {
                    return DEVICE_INDEX.MOUSE_AND_KEYBOARD;
                }
            } else {
                var _gamepadBindings = array_filter(bindings[INPUT_TYPE.GAMEPAD], is_defined);
                var _actionCount = array_length(_gamepadBindings);

                for(var j = 0; j < _actionCount; j += 1) {
                    var _actionSetting = _gamepadBindings[j];
                    if(_actionSetting.type == BINDING_TYPE.GAMEPAD_BUTTON) {
                        var _isPressed = gamepad_button_check_pressed(_deviceIndex, _actionSetting.value);
                        if(_isPressed) {
                            return _deviceIndex;
                        }
                    }
                }
            }
        }

        //no device input detected
        return undefined;
    }
    
    static initializeFunctionMap = function initialize_function_map() {
        var _heldMap = functionsMap[BUTTON_PRESS_TYPE.HELD];
        var _pressMap = functionsMap[BUTTON_PRESS_TYPE.PRESS];
        var _releaseMap = functionsMap[BUTTON_PRESS_TYPE.RELEASE];

        _heldMap[BINDING_TYPE.KEYBOARD_KEY] = function(_device, _key) { return keyboardCheckMethod(_key); };
        _heldMap[BINDING_TYPE.MOUSE_BUTTON] = device_mouse_check_button;
        _heldMap[BINDING_TYPE.GAMEPAD_BUTTON] = gamepad_button_check;
        _heldMap[BINDING_TYPE.MOUSE_WHEEL] = function(_device, _key) { return _key == MOUSE_WHEEL_DIRECTION.UP ? mouse_wheel_up() : mouse_wheel_down() };
        
        _pressMap[BINDING_TYPE.KEYBOARD_KEY] = function(_device, _key) { return keyboard_check_pressed(_key); };
        _pressMap[BINDING_TYPE.MOUSE_BUTTON] = device_mouse_check_button_pressed;
        _pressMap[BINDING_TYPE.GAMEPAD_BUTTON] = gamepad_button_check_pressed;
        _pressMap[BINDING_TYPE.MOUSE_WHEEL] = function(_device, _key) { return _key == MOUSE_WHEEL_DIRECTION.UP ? mouse_wheel_up() : mouse_wheel_down() };
        
        _releaseMap[BINDING_TYPE.KEYBOARD_KEY] = function(_device, _key) { return keyboard_check_released(_key); };
        _releaseMap[BINDING_TYPE.MOUSE_BUTTON] = device_mouse_check_button_released;
        _releaseMap[BINDING_TYPE.GAMEPAD_BUTTON] = gamepad_button_check_released;
        _releaseMap[BINDING_TYPE.MOUSE_WHEEL] = function() { return false };

    }
    
    static initializeBindings = function initialize_bindings() {
        var _keyboardBindings = bindings[INPUT_TYPE.MOUSE_AND_KEYBOARD];
        var _gamepadBindings = bindings[INPUT_TYPE.GAMEPAD];
    
        _keyboardBindings[ACTION_INPUT.CROUCH] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value: vk_control
        };
        _keyboardBindings[ACTION_INPUT.USE_EQUIPMENT] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value:  ord("Q")
        };
        _keyboardBindings[ACTION_INPUT.JUMP] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value:  vk_space
        };
        _keyboardBindings[ACTION_INPUT.MOVE_DOWN] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value:  ord("S")
        };
        _keyboardBindings[ACTION_INPUT.MOVE_LEFT] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value:  ord("A")
        };
        _keyboardBindings[ACTION_INPUT.MOVE_RIGHT] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value:  ord("D")
        };
        _keyboardBindings[ACTION_INPUT.MOVE_UP] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value: ord("W")
        };
        _keyboardBindings[ACTION_INPUT.SHOOT] = {
            type: BINDING_TYPE.MOUSE_BUTTON,
            value: mb_left
        };
        _keyboardBindings[ACTION_INPUT.SHOOT_SECONDARY] = {
            type: BINDING_TYPE.MOUSE_BUTTON,
            value: mb_right
        };
        _keyboardBindings[ACTION_INPUT.THROW_GRENADE] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value: ord("G")
        };
        _keyboardBindings[ACTION_INPUT.TOGGLE_INVENTORY] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value: ord("T")
        };
        _keyboardBindings[ACTION_INPUT.NEXT_WEAPON] = {
            type: BINDING_TYPE.MOUSE_WHEEL,
            value: MOUSE_WHEEL_DIRECTION.UP
        };
        _keyboardBindings[ACTION_INPUT.PREVIOUS_WEAPON] = {
            type: BINDING_TYPE.MOUSE_WHEEL,
            value: MOUSE_WHEEL_DIRECTION.DOWN
        };
        _keyboardBindings[ACTION_INPUT.PAUSE] = {
            type: BINDING_TYPE.KEYBOARD_KEY,
            value: vk_escape
        };
    
        //GAMEPAD Bindings
        _gamepadBindings[ACTION_INPUT.CROUCH] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value: gp_stickl
        };
        _gamepadBindings[ACTION_INPUT.USE_EQUIPMENT] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value:  gp_face3
        };
        _gamepadBindings[ACTION_INPUT.JUMP] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value:  gp_face1
        };
        _gamepadBindings[ACTION_INPUT.MOVE_VERTICAL] = {
            type: BINDING_TYPE.GAMEPAD_AXIS,
            value:  gp_axislv
        };
        _gamepadBindings[ACTION_INPUT.MOVE_HORIZONTAL] = {
            type: BINDING_TYPE.GAMEPAD_AXIS,
            value:  gp_axislh
        };
        _gamepadBindings[ACTION_INPUT.SHOOT] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value: gp_shoulderrb
        };
        _gamepadBindings[ACTION_INPUT.SHOOT_SECONDARY] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value: gp_shoulderlb
        };
        _gamepadBindings[ACTION_INPUT.THROW_GRENADE] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value: gp_shoulderl
        };
        _gamepadBindings[ACTION_INPUT.TOGGLE_INVENTORY] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value: gp_select
        };
        _gamepadBindings[ACTION_INPUT.NEXT_WEAPON] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value: gp_padu
        };
        _gamepadBindings[ACTION_INPUT.PREVIOUS_WEAPON] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value: gp_padd
        };
        _gamepadBindings[ACTION_INPUT.LOOK_VERTICAL] = {
            type: BINDING_TYPE.GAMEPAD_AXIS,
            value: gp_axisrv
        };
        _gamepadBindings[ACTION_INPUT.LOOK_HORIZONTAL] = {
            type: BINDING_TYPE.GAMEPAD_AXIS,
            value: gp_axisrh
        };
        _gamepadBindings[ACTION_INPUT.PAUSE] = {
            type: BINDING_TYPE.GAMEPAD_BUTTON,
            value: gp_start
        };
    }

    initializeFunctionMap();
    initializeBindings();
}